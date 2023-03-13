# -*- coding: utf-8 -*-

import sys, os, getopt, re, shutil
from pathlib import Path
from diskcache import Cache
from git import Repo

specs_git_local_path = None


def check_specs_local():
    global cache, specs_git_local_path
    specs_git_local_path = cache.get('specs_local_path')
    if specs_git_local_path is None:
        default_specs_git_local_path = Path.home().joinpath('.cocoapods/repos/yidianling-app_ios-specs')
        specs_git_local_path_tmp = input(f'当前specs仓库目录位置未设置，立即设置(回车使用默认路径：{default_specs_git_local_path})：')
        if specs_git_local_path_tmp == '':
            specs_git_local_path_tmp = default_specs_git_local_path
        if specs_git_local_path_tmp is None or not os.path.exists(specs_git_local_path_tmp):
            print('specs仓库目录位置设置错误！')
            check_specs_local()
        else:
            specs_git_local_path = specs_git_local_path_tmp
            cache.set('specs_local_path', specs_git_local_path)
    else:
        print(f'当前specs仓库目录位置：{specs_git_local_path}')


def check_repo_ok(repo: Repo, target_branch: str = 'dev'):
    if repo.is_dirty():
        assert False, f'当前仓库有未提交代码！仓库：{repo.git.working_dir}'
    git_name = os.path.basename(repo.working_dir)
    print(f'> git开始处理仓库：{git_name}')
    before_branch = repo.active_branch
    if before_branch != target_branch:
        print(f'当前git库分支为：{before_branch}, 开始切换分支到`{target_branch}`')
        repo.git.checkout(target_branch)
    print('git开始拉取远端最新代码...')
    repo.git.pull()
    print('git拉取远端最新代码完毕')


def query_repo_branch(repo: Repo, target_branch: str = 'dev') -> str:
    git_name = os.path.basename(repo.working_dir)
    print(f'> 查询{git_name}的最佳目标分支')
    if target_branch not in ['dev', 'develop']:
        return target_branch
    branches = repo.remote().refs
    branch_str_list = [item.remote_head for item in branches if item.remote_head not in ['HEAD', ]]
    if target_branch in branch_str_list:
        return target_branch
    target_branch_rename = [i for i in ['dev', 'develop'] if i != target_branch][0]
    if target_branch_rename in branch_str_list:
        return target_branch_rename
    assert False, f'没有找到对应远端分支：{target_branch}'
    return None


def check_specs_repo():
    specs_repo = Repo(specs_git_local_path)
    check_repo_ok(specs_repo, 'dev')


def query_pod_spec_version(pod_spec_path: str) -> str:
    with open(pod_spec_path, 'r') as f:
        pod_spec_content = f.read()
        res = re.search('version.+([0-9]\.[0-9]+\..+)\'', pod_spec_content, flags=0)
        from_version = res.group(1)
        return from_version
    raise ValueError('无法发现版本号！')

def update_pod_spec_version(pod_spec_path: str, from_version: str, to_version: str):
    with open(pod_spec_path, 'r') as f:
        file_data = ""
        for line in f:
            if from_version in line:
                res = re.search('version.+([0-9]\.[0-9]+\..+)\'', line, flags=0)
                if res is not None and res.group() is not None:
                    line = line.replace(from_version, to_version)
            file_data += line

    with open(pod_spec_path, 'w') as f:
        f.write(file_data)
        print(f'完成版本号变更： {from_version} -> {to_version}')


def update_lib(lib_git_dir: str):
    lib_git_repo = Repo(lib_git_dir)
    # lib_git_repo.git.branch()
    branch = query_repo_branch(lib_git_repo, 'develop')
    print(f'查询最佳目标分支：{branch}')
    check_repo_ok(lib_git_repo, branch)

    lib_name = os.path.basename(lib_git_dir)
    print(f'获取组件名称：{lib_name}')
    pod_spec_file_path = os.path.join(lib_git_dir, f'{lib_name}.podspec')
    print(f'podspec文件路径：{pod_spec_file_path}')

    from_version = query_pod_spec_version(pod_spec_file_path)
    print(f'查询到版本号：{from_version}')
    last_version_code = int(from_version.split('.')[-1]) + 1
    to_version = '.'.join(from_version.split('.')[:-1]) + '.' + str(last_version_code)
    print(f'即将升级到版本号：{to_version}')

    cmd = input(f'请输入版本号(回车默认版本号为{to_version})：\n')
    if cmd != '':
        to_version = cmd
        cmd = input(f'确认版本号将变更为：{to_version} ？\n')
        if cmd != '':
            print('退出版本发布系统！')
            exit()
    update_pod_spec_version(pod_spec_file_path, from_version, to_version)
    print('> 准备提交仓库版本号变更...')
    commit_info = lib_name + " " + to_version
    lib_git_repo.git.add('.')
    lib_git_repo.git.commit(m=commit_info)
    lib_git_repo.git.tag(to_version)
    print(f'完成仓库({lib_name})版本号变更、tag打标')

    print('> 准备提交specs仓库版本号变更...')
    specs_git_version_file_dir = specs_git_local_path + '/' + to_version
    if os.path.exists(specs_git_version_file_dir):
        print('specs git已存在当前版本specs！')
        exit()
    else:
        os.makedirs(specs_git_version_file_dir)
    specs_git_version_file_path = f'{specs_git_version_file_dir}/{lib_name}.podspec'
    shutil.copyfile(pod_spec_file_path, specs_git_version_file_path)
    specs_git_repo.git.add('.')
    specs_git_repo.git.commit(m=commit_info)
    print(f'完成specs仓库针对({lib_name})版本号变更')

    lib_git_repo.git.push()
    print(f'完成仓库({lib_name})版本号变更推送远端')
    specs_git_repo.git.push()
    print(f'完成specs仓库针对({lib_name})版本号变更推送远端')
    print(f'* {lib_name} 完成版本号变更流程：{from_version} -> {to_version}')


if __name__ == '__main__':
    opts, args = getopt.getopt(sys.argv[1:], 'hd:', ['help', 'dir='])
    print(f'> 开始检测开发环境...')
    cache = Cache('~/Dowloads/diskcache')

    check_specs_local()
    check_specs_repo()
    specs_git_repo = Repo(specs_git_local_path)

    lib_git_dir = None
    for opt, arg in opts:
        if opt in ('-d', '--dir'):
            if not os.path.exists(arg):
                assert os.path.exists(arg)
            lib_git_dir = arg
    if lib_git_dir is None:
        lib_git_dir = os.getcwd()

    update_lib(lib_git_dir)

    cache.close()
