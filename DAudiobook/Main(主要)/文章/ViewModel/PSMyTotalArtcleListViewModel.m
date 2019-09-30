//
//  PSMyTotalArtcleListViewModel.m
//  PrisonService
//
//  Created by kky on 2019/9/12.
//  Copyright © 2019年 calvin. All rights reserved.
//

#import "PSMyTotalArtcleListViewModel.h"
#import "PSArticleDetailModel.h"



@interface PSMyTotalArtcleListViewModel ()

@property (nonatomic, strong) NSMutableArray *logs;
@property (nonatomic, strong) NSMutableArray *logs1;
@property (nonatomic, strong) NSMutableArray *logs2;

@end

@implementation PSMyTotalArtcleListViewModel
@synthesize dataStatus = _dataStatus;
- (id)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.pageSize = 3;
    }
    return self;
}

- (NSArray *)articles_notpublished {
    return _logs;
}

- (NSArray *)articles_notpass {
    return _logs1;
}

- (NSArray *)articles_published {
    return _logs2;
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
    
    NSString*urlString=[NSString stringWithFormat:@"%@%@",ServerUrl,URL_Article_getMyTotalArticle];
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page],@"rows":[NSString stringWithFormat:@"%ld",(long)self.pageSize],@"type":@"2"};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    NSString *access_token = help_userManager.oathInfo.access_token;
    access_token = NSStringFormat(@"Bearer %@",access_token);
    @weakify(self)
    [PPNetworkHelper setValue:access_token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:urlString parameters:parameters success:^(id responseObject) {
        @strongify(self)
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        if (code == 200) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *articles_notpublished = [[PSArticleDetailModel class] jsonsToModelsWithJsons:[data valueForKey:@"articles_notpublished"]];
            NSArray *articles_notpass =  [[PSArticleDetailModel class] jsonsToModelsWithJsons:[data valueForKey:@"articles_notpass"]];
            NSArray *articles_published = [[PSArticleDetailModel class] jsonsToModelsWithJsons:[data valueForKey:@"articles_published"]];
            
            if (self.page == 1) {
                self.logs = [NSMutableArray array];
                self.logs1 = [NSMutableArray array];
                self.logs2 = [NSMutableArray array];
            }
            
            
            if (articles_notpublished.count == 0&&articles_notpass.count==0&&articles_published.count==0) {
                self.dataStatus = PSDataEmpty;
            }else{
                self.dataStatus = PSDataNormal;
            }
            self.hasNextPage = NO;
            [self.logs addObjectsFromArray:articles_notpublished];
            [self.logs1 addObjectsFromArray:articles_notpass];
            [self.logs2 addObjectsFromArray:articles_published];
            self.articles = [NSMutableArray array];
            //已发布
            if (self.logs2.count!=0) {
                [self.articles addObject:self.logs2];
            }
            //未发布
            if (self.logs.count!=0) {
                [self.articles addObject:self.logs];
            }
            //未通过
            if (self.logs1.count!=0) {
                [self.articles addObject:self.logs1];
            }
            
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
        @strongify(self)
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
