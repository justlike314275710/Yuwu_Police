//
//  PSReportArticleViewModel.m
//  PrisonService
//
//  Created by kky on 2019/10/28.
//  Copyright © 2019年 calvin. All rights reserved.
//

#import "PSReportArticleViewModel.h"

@implementation PSReportArticleViewModel

- (void)requestReportArticleCompleted:(RequestDataTaskCompleted)completedCallback failed:(RequestDataFailed)failedCallback{
 
    NSString*urlString=[NSString stringWithFormat:@"%@%@",ServerUrl,URL_api_reportArticle];
    NSDictionary *parameters = @{@"articleId":self.detailModel.id,
                                 @"reportReason":self.reportReason,
                                 @"type":@"2"};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    NSString *access_token = help_userManager.oathInfo.access_token;
    access_token = NSStringFormat(@"Bearer %@",access_token);
    [PPNetworkHelper setValue:access_token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper POST:urlString parameters:parameters success:^(id responseObject) {
        if (completedCallback) {
            completedCallback(responseObject);
        }
    } failure:^(NSError *error) {
        if (failedCallback) {
            failedCallback(error);
        }
    }];
}


@end
