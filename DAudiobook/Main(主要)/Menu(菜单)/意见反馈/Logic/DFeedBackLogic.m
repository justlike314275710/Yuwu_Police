//
//  DFeedBackLogic.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/20.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DFeedBackLogic.h"
#import "NSString+emoji.h"
#import "FeedbackTypeModel.h"
@implementation DFeedBackLogic

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)checkDataWithCallback:(CheckDataCallback)callback {
    if (self.detail.length <10) {
        if (callback) {
            NSString *less_msg = @"请输入不少于10个字的描述";
            callback(NO,less_msg);
        }
        return;
    }
    if ([NSString hasEmoji:self.detail]||[NSString stringContainsEmoji:self.detail]) {
        if (callback) {
            NSString *msg = @"输入的反馈详情不能包含表情,请重新输入";
            callback(NO,msg);
        }
        return;
    }
    if (callback) {
        callback(YES,nil);
    }
    
}

- (void)sendFeedbackCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    switch (self.writefeedType) {
        case PSWritefeedBack:
        {
            [self sendAppFeedbackCompleted:completedCallback failed:failedCallback];
        }
            break;
        case PSPrisonfeedBack:
        {
            [self sendSuggestionCompleted:completedCallback failed:failedCallback];
        }
            break;
            
        default:
            break;
    }
}

- (void)sendAppFeedbackCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    NSString *platform = @"assistant.app";  
    NSDictionary *params = @{@"clientKey":platform,
                             @"problem":self.problem,
                             @"detail":self.detail,
                             @"attachments":self.attachments,
                             @"isCo":@"0"
                             };
    
    NSString *url = NSStringFormat(@"%@%@",EmallHostUrl,URL_feedbacks_add);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString*token=[NSString stringWithFormat:@"Bearer %@",help_userManager.oathInfo.access_token];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if (completedCallback) {
                completedCallback(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedCallback) {
            failedCallback(error);
        }
    }];
}


- (void)sendSuggestionCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
 
}
- (void)sendFeedbackTypesCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {

    
}


-(NSArray *)reasons {
    return @[@"功能异常：功能故障或不可使用",
             @"产品建议：使用体验不佳，我有建议",
             @"安全问题：隐私信息不安全等",
             @"其他问题"];
}

//删除图片
-(void)requestdeleteFinish:(void(^)(id responseObject))finish
                   enError:(void(^)(NSError *error))enError {
    //删除图片
    NSArray *ary = [NSArray arrayWithArray:self.urls];
    NSDictionary *deleDic = @{@"urls":ary};
    /*
     [PSDeleteRequest requestPUTWithURLStr:ImageDeleteUrl paramDic:deleDic finish:^(id  _Nonnull responseObject) {
     finish(responseObject);
     } enError:^(NSError * _Nonnull error) {
     enError(error);
     }];
     */
}




@end
