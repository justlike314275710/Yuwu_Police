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
@property(nonatomic,strong)NSMutableArray *datalist;
@property(nonatomic,assign)BOOL author; //是否有权限发布文章
@property(nonatomic,assign)NSInteger count; //新文章条数


- (void)refreshArticleListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;
- (void)loadMoreArticleListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;
//获取是否能发文章权限
- (void)authorArticleCompleted:(RequestDataCompleted)completedCallback
                        failed:(RequestDataFailed)failedCallback;

//查询新文章数量
-(void)getNewArticleCountCompleted:(RequestDataCompleted)completedCallback
                            failed:(RequestDataFailed)failedCallback;




@end

NS_ASSUME_NONNULL_END
