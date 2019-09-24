//
//  HomePageLogic.h
//  DAudiobook
//
//  Created by kky on 2019/9/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "HpBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePageLogic : HpBaseLogic

@property (nonatomic, assign) BOOL hasNextPage;

- (void)refreshArticleListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;
- (void)loadMoreArticleListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;



@end

NS_ASSUME_NONNULL_END
