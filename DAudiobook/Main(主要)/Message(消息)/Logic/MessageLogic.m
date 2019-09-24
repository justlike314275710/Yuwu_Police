//
//  MessageLogic.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "MessageLogic.h"
#import "DMessageModel.h"
@interface MessageLogic()
@property (nonatomic, strong) NSMutableArray *logs;

@end


@implementation MessageLogic
@synthesize dataStatus = _dataStatus;

- (id)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.pageSize = 10;
    }
    return self;
}
- (NSArray *)messages {
    return _logs;
}

- (void)refreshMessagesCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    self.page = 1;
    self.logs = nil;
    self.hasNextPage = NO;
    self.dataStatus = PSDataInitial;
    [self requestMessagesCompleted:completedCallback failed:failedCallback];
}

- (void)loadMoreMessagesCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    self.page ++;
    [self requestMessagesCompleted:completedCallback failed:failedCallback];
}

- (void)requestMessagesCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    NSString*page=[NSString stringWithFormat:@"%ld",(long)self.page];
    NSString*pageSize=[NSString stringWithFormat:@"%ld",(long)self.pageSize];
    NSDictionary*param=@{@"page":page,@"rows":pageSize,@"type":@"4"};
    NSString*url=@"http://120.79.251.238:8022/ywgk-app/api/family_logs/findPage";
    
    NSString *access_token = help_userManager.oathInfo.access_token;
    NSString *token = NSStringFormat(@"Bearer %@",access_token);
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper setValue:token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:url parameters:param success:^(id responseObject) {
        NSString*code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            if (self.page == 1) {
                self.logs = [NSMutableArray array];
            }
            [self.logs addObjectsFromArray:[DMessageModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"logs"]]];
            if (self.logs.count == 0) {
                self.dataStatus = PSDataEmpty;
            }else{
                self.dataStatus = PSDataNormal;
            }
            self.hasNextPage = self.logs.count >= self.pageSize;
            
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
//    self.familyLogsRequest = [PSFamilyLogsRequest new];
//    self.familyLogsRequest.page = self.page;
//    self.familyLogsRequest.rows = self.pageSize;
//    if (self.type&&self.type.length>0) {
//        self.familyLogsRequest.type = self.type;
//    }
//    self.familyLogsRequest.familyId = [PSSessionManager sharedInstance].session.families.id;
//    @weakify(self)
//    [self.familyLogsRequest send:^(PSRequest *request, PSResponse *response) {
//        @strongify(self)
//
//        if (response.code == 200) {
//            PSFamilyLogsResponse *logsResponse = (PSFamilyLogsResponse *)response;
//
//            if (self.page == 1) {
//                self.logs = [NSMutableArray array];
//            }
//            if (logsResponse.logs.count == 0) {
//                self.dataStatus = PSDataEmpty;
//            }else{
//                self.dataStatus = PSDataNormal;
//            }
//            self.hasNextPage = logsResponse.logs.count >= self.pageSize;
//            [self.logs addObjectsFromArray:[self buildMessages:logsResponse.logs]];
//        }else{
//            if (self.page > 1) {
//                self.page --;
//                self.hasNextPage = YES;
//            }else{
//                self.dataStatus = PSDataError;
//            }
//        }
//        if (completedCallback) {
//            completedCallback(response);
//        }
//
//    } errorCallback:^(PSRequest *request, NSError *error) {
//        @strongify(self)
//        if (self.page > 1) {
//            self.page --;
//            self.hasNextPage = YES;
//        }else{
//            self.dataStatus = PSDataError;
//        }
//        if (failedCallback) {
//            failedCallback(error);
//        }
//    }];
}



@end
