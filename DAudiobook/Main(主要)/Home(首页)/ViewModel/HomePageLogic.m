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


@end
