//
//  LaunchAdViewController.m
//  QYQuickDemo
//
//  Created by qianyi on 2023/2/6.
//

#import "LaunchAdViewController.h"
#import "QYQuickDemo.pch"


@interface LaunchAdViewController ()

YDL_PROPERTY_STRONG NSArray *dataSource;

@end

@implementation LaunchAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = @[@{@"title": @"图片开屏广告 - 网络数据", @"class": @"DetailViewController"},
                        @{@"title": @"图片开屏广告 - 本地数据", @"class": @"DetailViewController"}];
}

#pragma mark - Methods

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    [[cell textLabel] setText:self.dataSource[indexPath.row][@"title"]];
}

#pragma mark - Table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setInteger:(indexPath.row+1) forKey:kLaunchAdChoiceMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    abort();
}

@end
