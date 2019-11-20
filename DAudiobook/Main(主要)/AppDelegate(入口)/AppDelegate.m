//
//  AppDelegate.m
//  SIXRichEditor
//
//  Created by  on 2018/7/29.
//  Copyright © 2018年 liujiliu. All rights reserved.
//

#import <BmobSDK/Bmob.h>
//#import <UMSocialCore/UMSocialCore.h>
//#import <Bugly/Bugly.h>
#import "AppDelegate.h"
#import "DAllControllersTool.h"
#import "DMenuModel.h"
#import "DNavigationController.h"
#import "DLoginViewController.h"
#import "IQKeyboardManager.h"
#import "IMManager.h"
#import "PPNetworkHelper.h"
#import "KGStatusBar.h"
#import "DVersionManger.h"
#import "DHotNovelViewController.h"
#import "DMessageViewController.h"
#import "AppDelegate+other.h"

@interface AppDelegate ()
@property (retain, nonatomic) GDTSplashAd  *splash;
@property (retain, nonatomic) UIView       *bottomView;
@end

@implementation AppDelegate
//应用将要完成启动
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions{
    //键盘
    [self registerThirdParty];
    //im初始化
    [[IMManager sharedIMManager]initIM];
    //注册apns
    [self registerAPNS:application launchOptions:launchOptions];
    //网络监听
    [self monitorNetworkStatus];
    //版本更新
    DVersionManger*versonManger=[DVersionManger new];
    [versonManger jundgeVersonUpdate];
    //初始化window
    [self  initWindow];
    //初始化app服务
    [self  initService];
    //初始化用户系统
    [self initUserManager];
   
    [self addCycleTime];
    self.openByNotice=NO;
    if (launchOptions) {
        // 获取推送通知定义的userinfo
        NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            self.openByNotice=YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self userNotificationCenterApns:userInfo];
            });
        }
    }
    
    return YES;
}
-(void)addCycleTime{
    
    
}

//应用完成启动
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //初始化IM
    [[IMManager sharedIMManager]initIM];
    return YES;
}
// 当应用界面回到活跃Activate状态时
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"%s", __func__);
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_token" object:nil];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //注册成功后上传Token至服务器
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}
//分享
-(void)initializeShareSDK{
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppkey appSecret:WXAppSecret redirectURL:@""];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppkey  appSecret:QQAppSecret redirectURL:@""];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:WBAppkey  appSecret:WBAppSecret redirectURL:@""];
}

#pragma mark ————— 注册第三方库 —————
- (void)registerThirdParty {
    //键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

}


-(void)initService{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNotificationLoginStateChange
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(EBBannerViewDidClickNotification)
                                                 name:@"EBBannerViewDidClickNotification"
                                               object:nil];
    
    //网络状态监听
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(netWorkStateChange:)
//                                                 name:KNotificationNetWorkStateChange
//                                               object:nil];
}


#pragma mark ————— EBBanner点击事件 —————
-(void)EBBannerViewDidClickNotification{
    DMessageViewController *VC = [[DMessageViewController alloc] init];
    DNavigationController *nav = [[DNavigationController alloc] initWithRootViewController:VC];
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationRedDothide object:nil];
}

//
#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus
{
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {

        switch (networkStatus) {
                // 未知网络
            case PPNetworkStatusUnknown:
            {
                [KGStatusBar dismiss];
                //self.IS_NetWork = YES;
                // 无网络
            }
            case PPNetworkStatusNotReachable:
            {
                //KPostNotification(KNotificationNetWorkStateChange, @NO);
                NSString *msg =  @"当前网络不可用,请检查你的网络设置";
                [KGStatusBar showWithStatus:msg];
                //self.IS_NetWork = NO;
            }
                break;
                // 手机网络
            case PPNetworkStatusReachableViaWWAN:
            {

                [KGStatusBar dismiss];
                // 无线网络
                //self.IS_NetWork = YES;
            }
            case PPNetworkStatusReachableViaWiFi:
                [KGStatusBar dismiss];
                //KPostNotification(KNotificationNetWorkStateChange, @YES);
                //self.IS_NetWork = YES;
                break;
        }

    }];

}



-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];
    //    [[UIButton appearance] setShowsTouchWhenHighlighted:YES];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

#pragma mark ————— 初始化用户系统 —————
-(void)initUserManager{
    if([help_userManager loadUserInfo]){
        //加载用户token
        [help_userManager loadUserOuathInfo];
        //加载监狱端用户资料
        [help_userManager loadLawUserInfo];
        
        //如果有本地数据，先展示TabBar 随后异步自动登录
        DMenuModel*menuModel=[DMenuModel new];
        menuModel.menuType=KCollectionType;
        [DAllControllersTool createViewControllerWithIndex:menuModel];
        self.window.rootViewController = [DAllControllersTool shareOpenController].drawerController;
        
        // 自动登录
        [help_userManager autoLoginToServer:^(BOOL success, NSString *des) {
            if (success) {
                //[MBProgressHUD showSuccessMessage:@"自动登录成功"];
                KPostNotification(KNotificationAutoLoginSuccess, nil);
            }else{
                //[MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
                [PSTipsView showTips:@"自动登录失败"];
            }
        }];
        
        
    }else{
        //没有登录过，展示登录页面
        KPostNotification(KNotificationLoginStateChange, @NO)
    }
}

#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    
    if (loginSuccess) {//登陆成功加载主窗口控制器
        DMenuModel*menuModel=[DMenuModel new];
        menuModel.menuType=KCollectionType;
        [DAllControllersTool createViewControllerWithIndex:menuModel];
        self.window.rootViewController = [DAllControllersTool shareOpenController].drawerController;
       
    }else {//登陆失败加载登陆页面控制器
        DNavigationController*navController=[[DNavigationController alloc]initWithRootViewController:[[DLoginViewController alloc]init]];
        [navController setNavigationBarHidden:YES];
        self.window.rootViewController=navController;
        
    }

}


-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - 接收远程事件
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause://暂停
            {
                [[DPlayerManager defaultManager] playAndPause];
               
                break;
            }case UIEventSubtypeRemoteControlPlay://播放
            {
                [[DPlayerManager defaultManager] playAndPause];
              
                break;
            }case UIEventSubtypeRemoteControlPreviousTrack://前一首
            {
                [[DPlayerManager defaultManager] playPrevious];
                
                break;
            }case UIEventSubtypeRemoteControlNextTrack://下一首
            {
                [[DPlayerManager defaultManager] playNext];
               
                break;
            }
            default:
                break;
        }
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([touches.anyObject locationInView:nil].y > 20) return;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"statusBarTappedNotification" object:nil];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0]; //清除角标
    [[UIApplication sharedApplication] cancelAllLocalNotifications];//清除APP所
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    //在这个方法里输入如下清除方法
    [application setApplicationIconBadgeNumber:0]; //清除角标
    [[UIApplication sharedApplication] cancelAllLocalNotifications];//清除APP所
}





@end
