//
//  DFeedBackLogic.h
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/20.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "HpBaseLogic.h"
//枚举---
typedef NS_ENUM(NSInteger,WritefeedType) {
    PSWritefeedBack,   //app投诉反馈
    PSPrisonfeedBack,  //监狱投诉建议
};
@interface DFeedBackLogic : HpBaseLogic
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *imageUrls;
@property (nonatomic, strong) NSArray *reasons;
@property (nonatomic, assign)WritefeedType writefeedType;

@property (nonatomic, strong) NSString *platform; //
@property (nonatomic, strong) NSString *problem;  //
@property (nonatomic, strong) NSString *detail; //
@property (nonatomic, strong) NSArray *attachments;


@property (nonatomic, assign)NSArray *urls; //要删除图片数组

- (void)checkDataWithCallback:(CheckDataCallback)callback ;

- (void)sendFeedbackCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;

- (void)sendFeedbackTypesCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;

-(void)requestdeleteFinish:(void(^)(id responseObject))finish
                   enError:(void(^)(NSError *error))enError;

@end
