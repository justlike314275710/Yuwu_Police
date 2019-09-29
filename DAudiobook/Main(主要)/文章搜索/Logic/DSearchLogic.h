//
//  DSearchLogic.h
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/29.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "HpBaseLogic.h"

@interface DSearchLogic : HpBaseLogic
@property (nonatomic, strong, readonly) NSArray *Articles;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic , strong) NSString *title;

- (void)refreshArticlesCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;
- (void)loadMoreArticlesCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;
@end
