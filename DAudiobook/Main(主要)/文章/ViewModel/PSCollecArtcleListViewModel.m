//
//  PSCollecArtcleListViewModel.m
//  PrisonService
//
//  Created by kky on 2019/9/11.
//  Copyright © 2019年 calvin. All rights reserved.
//

#import "PSCollecArtcleListViewModel.h"
#import "PSCollectArticleListModel.h"


@interface PSCollecArtcleListViewModel ()

@property (nonatomic, strong) NSMutableArray *logs;

@end

@implementation PSCollecArtcleListViewModel
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
    
    NSString*urlString=[NSString stringWithFormat:@"%@%@",ServerUrl,URL_Article_collectList];
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page],@"rows":[NSString stringWithFormat:@"%ld",(long)self.pageSize],@"type":@"2"};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    NSString *access_token = help_userManager.oathInfo.access_token;
    access_token = NSStringFormat(@"Bearer %@",access_token);
    [PPNetworkHelper setValue:access_token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:urlString parameters:parameters success:^(id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 200) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *collectList = [[PSCollectArticleListModel class] jsonsToModelsWithJsons:[data valueForKey:@"collectList"]];
            
            if (self.page == 1) {
                self.logs = [NSMutableArray array];
            }
            if (collectList.count == 0) {
                self.dataStatus = PSDataEmpty;
            }else{
                self.dataStatus = PSDataNormal;
            }
            self.hasNextPage = collectList.count >= self.pageSize;
            [self.logs addObjectsFromArray:collectList];
        }else{
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
        if (self.page > 1) {
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


@end
