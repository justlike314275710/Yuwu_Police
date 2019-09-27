//
//  DFeedbackListLogic.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/19.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DFeedbackListLogic.h"
#import "DMessageModel.h"
#import "FeedbackTypeModel.h"
@interface DFeedbackListLogic()

@property (nonatomic , strong) NSMutableArray *items;

@end



@implementation DFeedbackListLogic
@synthesize dataStatus = _dataStatus;
-(id)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.pageSize = 10;
    }
    return self;
}


-(NSArray*)Recodes{
    return _items;
}

- (void)refreshFeedbackListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    self.page = 1;
    self.items = nil;
    self.hasNextPage = NO;
    self.dataStatus = PSDataInitial;
    [self requestFeedbackListCompleted:completedCallback failed:failedCallback];
}

- (void)loadMoreFeedbackListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback{
    self.page ++;
    [self requestFeedbackListCompleted:completedCallback failed:failedCallback];
}

- (void)requestFeedbackListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    NSString*page=[NSString stringWithFormat:@"%ld",(long)self.page];
    NSString*pageSize=[NSString stringWithFormat:@"%ld",(long)self.pageSize];
    NSDictionary*param=
    @{@"page":page,@"rows":pageSize,@"policeId":help_userManager.lawUserInfo.id};
    NSString*url=NSStringFormat(@"%@%@",ServerUrl,URL_feedbacks_page);
    NSString *access_token = help_userManager.oathInfo.access_token;
    NSString *token = NSStringFormat(@"Bearer %@",access_token);
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper setValue:token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:url parameters:param success:^(id responseObject) {
        NSString*code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            if (self.page == 1) {
                self.items = [NSMutableArray array];
            }
            [self.items addObjectsFromArray:[FeedbackTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"feedbacks"]]];
            if (self.items.count == 0) {
                self.dataStatus = PSDataEmpty;
            }else{
                self.dataStatus = PSDataNormal;
            }
            self.hasNextPage = self.items.count >= self.pageSize;
            
        } else {
            if (self.page > 1) {
                self.page --;
                self.hasNextPage = YES;
            }else{
                self.dataStatus = PSDataError;
            }
        }
        if (completedCallback) {
            completedCallback(responseObject);
        }
        
    } failure:^(NSError *error) {
        if (failedCallback) {
            failedCallback(error);
        }
        if (self.page > 0) {
            self.page --;
            self.hasNextPage = YES;
        }else{
            self.dataStatus = PSDataError;
        }
    }];
  
}
- (void)refreshFeedbackDetaik:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback{
    NSString*url=NSStringFormat(@"%@%@",ServerUrl,URL_feedbacks_detai);
    NSString *access_token = help_userManager.oathInfo.access_token;
    NSString *token = NSStringFormat(@"Bearer %@",access_token);
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper setValue:token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}


@end
