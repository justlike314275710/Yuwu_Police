//
//  AppDelegate+other.m
//  DAudiobook
//
//  Created by kky on 2019/11/5.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "AppDelegate+other.h"
#import <Bugly/Bugly.h>
#import <Bugly/Bugly.h>
#import <UserNotifications/UserNotifications.h>
#import "UIViewController+Tool.h"
@interface AppDelegate()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate (other)

#pragma mark ---------- apns
- (void)registerAPNS:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
{
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // granted
                NSLog(@"User authored notification.");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
            } else {
                // not granted
                NSLog(@"User denied notification.");
            }
        }];
    }else if (systemVersion >= 8.0) {
        // iOS >= 8 Notifications
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }else {
        // iOS < 8 Notifications
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}
#pragma mark ---------- 远程APNS推送打开app(点击推送push)
- (void)userNotificationCenterApns:(NSDictionary*)userInfo{
  
}

#pragma mark ---------- UNUserNotificationCenterDelegate
//App处于前台收到本地推送或者远程推送时调用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0){
    NSLog(@"userInfo : %@",notification.request.content.userInfo);
    
    
}
//App处于后台（未杀死）点击本地推送或者远程推送时调用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED{
    NSLog(@"%@",response.notification.request.content.userInfo);
    NSDictionary *userInfo = response.notification.request.content.userInfo;

}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    NSLog(@"userInfo : %@",userInfo);
    if (application.applicationState == UIApplicationStateActive) {
        //app在前台
    }else{
        //app在后台点击远程推送
    }
}
//App处于前台收到本地推送消息，或者后台（未杀死）点击本地推送消息时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"userInfo : %@",notification.userInfo);
    if (application.applicationState == UIApplicationStateActive) {
        //app在前台
    }else{
        //app在后台点击远程推送
    }
}

- (void)registerAPNs
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types         = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |      UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |        UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}

@end
