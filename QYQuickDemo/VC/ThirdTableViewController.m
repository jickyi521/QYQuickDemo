//
//  ThirdTableViewController.m
//  QYQuickDemo
//
//  Created by qianyi on 2023/1/30.
//

#import "ThirdTableViewController.h"
#import "RDVTabBarController.h"
#import "DetailViewController.h"
#import "QYQuickDemo.pch"
#import "WebViewController.h"

@interface ThirdTableViewController ()

YDL_PROPERTY_STRONG NSArray *dataSource;

@end

@implementation ThirdTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Third", nil);
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.rdv_tabBarController.tabBar.translucent) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0,
                                               0,
                                               CGRectGetHeight(self.rdv_tabBarController.tabBar.frame),
                                               0);
        
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    self.dataSource = @[@{@"title": @"腾讯云直播 TRTCDemo", @"class": @"TRTCDemoViewController"},
                        @{@"title": @"开屏广告", @"class": @"LaunchAdViewController"},
                        @{@"title": @"webview", @"class": @"WebViewController"},
                        @{@"title": @"demo-4", @"class": @"DetailViewController"},
                        @{@"title": @"demo-5", @"class": @"DetailViewController"},
                        @{@"title": @"demo-6", @"class": @"DetailViewController"},
                        @{@"title": @"demo-7", @"class": @"DetailViewController"},
                        @{@"title": @"demo-8", @"class": @"DetailViewController"},
                        @{@"title": @"demo-9", @"class": @"DetailViewController"},
                        @{@"title": @"demo-10", @"class": @"DetailViewController"},
                        @{@"title": @"demo-11", @"class": @"DetailViewController"},
                        @{@"title": @"demo-12", @"class": @"DetailViewController"},
                        @{@"title": @"demo-13", @"class": @"DetailViewController"},
                        @{@"title": @"demo-14", @"class": @"DetailViewController"}];
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
    
//    UIViewController *viewController = [[DetailViewController alloc] init];
//    [self.navigationController pushViewController:viewController animated:YES];
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    NSString *className = dic[@"class"];
    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    
    if([vc isKindOfClass:[WebViewController class]]) {
        vc = [[WebViewController alloc] init];
        ((WebViewController *)vc).URLString = @"https://www.ydl.com";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
