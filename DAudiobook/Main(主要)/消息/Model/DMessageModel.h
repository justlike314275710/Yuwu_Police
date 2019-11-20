//
//  DMessageModel.h
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMessageModel : NSObject
@property (nonatomic , strong) NSString *familyId;
@property (nonatomic , strong) NSString *createdAt;
@property (nonatomic , strong) NSString *prisonerId;
@property (nonatomic , strong) NSString *type;
@property (nonatomic , strong) NSString *content;
@property (nonatomic , strong) NSString *applicationDate;
@property (nonatomic , strong) NSString *isNoticed;
@end
