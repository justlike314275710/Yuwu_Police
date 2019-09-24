//
//  HomePageLogic.m
//  DAudiobook
//
//  Created by kky on 2019/9/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "HomePageLogic.h"
#import "PSArticleDetailModel.h"

@implementation HomePageLogic
-(id)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.pageSize = 10;
    }
    return self;
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
//                NSArray *dataAry = [self jsonsToModelsWithJsons:articles ];
                

            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)refreshArticleListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    [self requestArticleListCompleted:completedCallback failed:failedCallback];
}
- (void)loadMoreArticleListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    
}


@end
