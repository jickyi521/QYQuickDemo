//
//  TRTCDemoViewController.m
//  QYQuickDemo
//
//  Created by qianyi on 2023/1/31.
//

@import TUILiveRoom;
@import TUICore;

#import "TRTCDemoViewController.h"

@interface TRTCDemoViewController ()

@end

@implementation TRTCDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.组件登录
    [TUILogin login:@"您的SDKAppID" userID:@"您的UserID" userSig:@"您的UserSig" succ:^{
        
        // 2.初始化TUILiveRoom实例
        TUILiveRoom *mLiveRoom = [TUILiveRoom sharedInstance];
        [mLiveRoom createRoomWithRoomId:123 roomName:@"test room" coverUrl:@""];


    } fail:^(int code, NSString *msg) {


    }];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
