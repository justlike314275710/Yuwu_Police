//
//  AppDelegate+other.h
//  DAudiobook
//
//  Created by kky on 2019/11/5.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (other)
- (void)userNotificationCenterApns:(NSDictionary*)userInfo;
- (void)registerAPNs;
- (void)registerAPNS:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
