//
//  LawUserInfo.h
//  GKHelpOutApp
//
//  Created by kky on 2019/3/5.
//  Copyright © 2019年 kky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LawUserInfo : NSObject

@property (nonatomic,copy) NSString *disabledReason;
@property (nonatomic,copy) NSString *accountName;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *realName;
@property (nonatomic,copy) NSString *pName;
@property (nonatomic , strong) NSArray *cName;
@property (nonatomic , strong) NSString *isEnabled;
@property (nonatomic , strong) NSString *jailName;
@property (nonatomic , strong) NSString *account;


@end

NS_ASSUME_NONNULL_END
