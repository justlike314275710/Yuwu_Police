//
//  FeedbackTypeModel.h
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/19.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackTypeModel : NSObject
@property (nonatomic, strong) NSString *feedId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSString *content; //投诉内容
@property (nonatomic, strong) NSString *contents; //监狱投诉内容
@property (nonatomic, strong) NSString *familyId;
@property (nonatomic, strong) NSString *createdAt; //日期
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *relationship;
@property (nonatomic, strong) NSString *jailId;
@property (nonatomic, strong) NSString *idCardFront;
@property (nonatomic, strong) NSString *idCardBack;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *imageUrls;
@property (nonatomic, strong) NSString *isReply;
@property (nonatomic, strong) NSString *reply;
@property (nonatomic, strong) NSString *replyAt;
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) NSString *writefeedType;
@property (nonatomic, strong) NSString *title;

@end
