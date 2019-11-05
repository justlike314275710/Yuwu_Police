//
//  IMManager.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/6/5.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "IMManager.h"
#import "EBBannerView.h"
//#import "NTESCellLayoutConfig.h"
//#import "NTESAttachmentDecoder.h"
#import "ZQLocalNotification.h"

@interface IMManager()<NIMLoginManagerDelegate,NIMChatManagerDelegate,NIMSystemNotificationManagerDelegate,NIMNetCallManagerDelegate>
//@interface IMManager()
@property (nonatomic, strong) NIMSession *session;
@property (nonatomic , assign) BOOL isOpen;
@end

@implementation IMManager

SINGLETON_FOR_CLASS(IMManager);

#pragma mark ————— 初始化IM —————
-(void)initIM{
    //在注册 NIMSDK appKey 之前先进行配置信息的注册，如是否使用新路径,是否要忽略某些通知，是否需要多端同步未读数
//    self.sdkConfigDelegate = [[NTESSDKConfigDelegate alloc] init];
//    [[NIMSDKConfig sharedConfig] setDelegate:self.sdkConfigDelegate];
    
    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
    [[NIMSDKConfig sharedConfig] setMaxAutoLoginRetryTimes:10];

    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    [[[NIMSDK sharedSDK] chatManager] addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
    
    //注入 NIMKit 布局管理器
   // [[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig new]];

    [[NIMSDK sharedSDK] registerWithAppID:kIMAppKey
                                  cerName:@"com.sinog2c.YuJingTong"];

}

#pragma mark ————— IM登录 —————
-(void)IMLogin:(NSString *)IMID IMPwd:(NSString *)IMPwd completion:(loginBlock)completion{
    //29cdae91fbc64318b608d2db598f0d4c  //15647679903e4e07bd60a54061c9283a
//    accid 29cdae91fbc64318b608d2db598f0d4c
//    appkey 87dae6933488de4bab789054a3a5c720
//    cerName com.sinog2c.YuJingTong
//    deviceToken  b01e5261 8d98b62b 816454a7 ebe7ac5a 9177b733 4df3a7ee 4b2d50f4 73112c36
    
    [[[NIMSDK sharedSDK] loginManager] login:IMID token:IMPwd completion:^(NSError * _Nullable error) {
        if (!error) {
            if (completion) {
                completion(YES,nil);
                /*
                //未读消息
                NSInteger messageCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
                if (messageCount>0) {
                    [kAppDelegate.mainTabBar setRedDotWithIndex:1 isShow:YES];
                } else {
                    [kAppDelegate.mainTabBar setRedDotWithIndex:1 isShow:NO];
                }
                //系统未读消息数
                NSInteger systemCount = [[[NIMSDK sharedSDK] systemNotificationManager] allUnreadCount];
                if (systemCount>0) {
                    [kAppDelegate.mainTabBar setRedDotWithIndex:3 isShow:YES];
                } else {
                    [kAppDelegate.mainTabBar setRedDotWithIndex:3 isShow:NO];
                }
            }
                 */
        }else{
            if (completion) {
                completion(NO,error.localizedDescription);
            }
        }
        }
    }];
}
#pragma mark ————— IM退出 —————
-(void)IMLogout{
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError * _Nullable error) {
        if (!error) {
            //DLog("IM 退出成功");
        }else{
            //DLog("IM 退出失败 %@",error.localizedDescription);
        }
    }];
}

-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NSString *reason = @"你被踢下线";
    switch (code) {
            case NIMKickReasonByClient:
            case NIMKickReasonByClientManually:
            {
                [self onKickShowAler];
                break;
            }
            case NIMKickReasonByServer:
        {
            reason = @"你被服务器踢下线";
            [self onKickShowAler];
        }
            break;
        default:
            break;
    }

}

- (void)onKickShowAler {
    NSString *reason = @"你的帐号被踢出下线，请注意帐号信息安全";
    NSString*determine=@"确定";
    NSString*Tips= @"提示";
//    NSString*pushed_off_line=@"您的账号已在其他设备登陆,已被挤下线";
//    XXAlertView*alert=[[XXAlertView alloc]initWithTitle:Tips message:pushed_off_line sureBtn:determine cancleBtn:nil];
//    alert.clickIndex = ^(NSInteger index) {
//        if (index==2) {
//            KPostNotification(KNotificationOnKick, nil);
//        }
//    };
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [alert show];
//    });
   [ PSAlertView showWithTitle:Tips message:reason messageAlignment:NSTextAlignmentCenter image:nil handler:^(PSAlertView *alertView, NSInteger buttonIndex) {
       if (buttonIndex==0) {
            KPostNotification(KNotificationOnKick, nil);
       }
   } buttonTitles:determine, nil];
}

#pragma mark ————— 代理 收到新消息 —————
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    NSLog(@"收到新消息");
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationRedDotRefresh object:nil];

}


-(void)UserNotificationSettings{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            NSLog(@"推送关闭");
            self.isOpen=NO;
        }else{
            NSLog(@"推送打开");
            self.isOpen=YES;
        }
    }else{
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){
            NSLog(@"推送关闭");
            self.isOpen=NO;
        }else{
            NSLog(@"推送打开");
            self.isOpen=YES;
        }
    }
}

-(void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
        [self UserNotificationSettings];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationRedDotRefresh object:nil];
    NSData *jsonData = [notification.content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary*dic=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSInteger code = [dic[@"code"] integerValue];
    NSString *content = dic[@"msg"];
    NSString *channel = [NSString stringWithFormat:@"%@",dic[@"channel"]];
    if (channel&&[channel isEqualToString:@"1"]) return; //1为家属端推送
    

    //认证文章
    if (code==PSMessageArticleInteractive) {
        
        if (self.isOpen==YES) {
            
            EBBannerView *banner = [EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
                make.style = 11;
                make.content = content;
            }];
            [banner show]; //NOTIFICATION_PRAISE_ADVICE
            [ZQLocalNotification NotificationType:CountdownNotification Identifier:@"3" activityId:1900000 alertBody:content alertTitle:@"狱警通" alertString:@"确定" withTimeDay:0 hour:0 minute:0 second:1];
            KPostNotification(KNotificationHomePageRefreshList, nil);
            KPostNotification(KNotificationCollectArtickeRefreshList, nil);
            KPostNotification(KNotificationRefreshMyArticle, nil);
            //发布文章权限改变
            NSString *isEnabled = [NSString stringWithFormat:@"%@",dic[@"isEnabled"]];
            if ([isEnabled isEqualToString:@"0"]||[isEnabled isEqualToString:@"1"]) {
                KPostNotification(KNotificationArticleAuthor,isEnabled);
            }
        } else {
             NSLog(@"推送关闭");
        }
       
    }
}

@end
