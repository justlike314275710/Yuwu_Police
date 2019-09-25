//
//  HomePageLogic.m
//  DAudiobook
//
//  Created by kky on 2019/9/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "HomePageLogic.h"
#import "PSArticleDetailModel.h"
@interface HomePageLogic()
@property (nonatomic,strong)NSMutableArray *items;

@end
@implementation HomePageLogic
-(id)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.pageSize = 10;
    }
    return self;
}

-(NSMutableArray *)datalist {
    return _items;
}

- (void)requestArticleListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    
    NSString*urlString=[NSString stringWithFormat:@"%@%@",ServerUrl,URL_Article_GetPublishArticle];
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page],@"rows":[NSString stringWithFormat:@"%ld",(long)self.pageSize]};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    NSString *access_token = help_userManager.oathInfo.access_token;
    access_token = NSStringFormat(@"Bearer %@",access_token);
    [PPNetworkHelper setValue:access_token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:urlString parameters:parameters success:^(id responseObject) {
        if (ValidDict(responseObject)) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code==200) {
                NSDictionary *data=[responseObject objectForKey:@"data"];
                NSArray *articles = [data valueForKey:@"articles"];
                NSArray *dataAry = [[PSArticleDetailModel class] jsonsToModelsWithJsons:articles];
                if (self.page==1) {
                    self.items = [NSMutableArray array];
                }
                [self.items addObjectsFromArray:dataAry];
                if (self.items.count == 0) {
                    self.dataStatus = PSDataEmpty;
                } else {
                    self.dataStatus = PSDataNormal;
                }
                self.hasNextPage = dataAry.count>= self.pageSize;
                
            } else {
                if (self.page > 0) {
                    self.page --;
                    self.hasNextPage = YES;
                }else{
                    self.dataStatus = PSDataError;
                }
            }
        }
        if (completedCallback) {
            completedCallback(responseObject);
        }
        
    } failure:^(NSError *error) {
        if (self.page > 0) {
            self.page --;
            self.hasNextPage = YES;
        }else{
            self.dataStatus = PSDataError;
        }
        if (failedCallback) {
            failedCallback(error);
        }
    }];
    
}

- (void)refreshArticleListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    self.pageSize = 0;
    self.items = nil;
    self.hasNextPage = NO;
    self.dataStatus = PSDataInitial;
    [self requestArticleListCompleted:completedCallback failed:failedCallback];
}
- (void)loadMoreArticleListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    self.page ++;
    [self requestArticleListCompleted:completedCallback failed:failedCallback];
}

//获取是否能发文章权限
- (void)authorArticleCompleted:(RequestDataCompleted)completedCallback
                        failed:(RequestDataFailed)failedCallback {
    NSString *userName = help_userManager.curUserInfo.account;
    userName = @"62806af99c544995a32d9bdd87a70508";
    NSString*urlString=[NSString stringWithFormat:@"%@%@",ServerUrl,URL_Article_author];
    NSDictionary *parameters = @{@"userName":userName,@"type":@"1"};
    NSString *access_token = help_userManager.oathInfo.access_token;
    NSString *token = NSStringFormat(@"Bearer %@",access_token);
    token = @"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOlsidHJhZGUiLCJ5d2drLmFwcCIsImF1dGgiLCJsZWdhbCJdLCJ1c2VyX25hbWUiOiI2MjgwNmFmOTljNTQ0OTk1YTMyZDliZGQ4N2E3MDUwOCIsInNjb3BlIjpbInB1YmxpYyJdLCJvcmdhbml6YXRpb24iOm51bGwsImV4cCI6MTU2OTQ2MjM4NiwianRpIjoiMzExYmEzNGEtZjMxZC00MzFmLWEzYTUtMWY5MDFkMGUwNGM4IiwidGVuYW50IjpudWxsLCJjbGllbnRfaWQiOiJwcmlzb24uYXBwIiwiZ3JvdXAiOiJjdXN0b21lciJ9.4344pxQA1aEhC5qGY-gNRxeG6NGPs3R4SMzd1Qs29AI";
//    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    //http://120.79.251.238:8022/ywgk-app/families/author/enabled?
    [PPNetworkHelper setValue:token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper POST:urlString parameters:parameters success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    //POST /families/author/enabled
    

    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    NSString*token=NSStringFormat(@"Bearer %@",help_userManager.oathInfo.access_token);
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        if (responses.statusCode==201||responses.statusCode==200||responses.statusCode==204) {
            if (completedCallback) {
                completedCallback(responseObject);
    
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failedCallback(error);
        }
        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (data) {
            id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",body);
        }
        if (failedCallback) {
            failedCallback(error);
        }
    }];
    
    
    
}

@end
