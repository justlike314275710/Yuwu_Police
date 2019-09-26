//
//  PSMyTotalArtcleListViewModel.h
//  PrisonService
//
//  Created by kky on 2019/9/12.
//  Copyright © 2019年 calvin. All rights reserved.
//

#import "HpBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface PSMyTotalArtcleListViewModel : HpBaseLogic
@property (nonatomic, strong, readonly) NSArray *articles_notpublished;
@property (nonatomic, strong, readonly) NSArray *articles_notpass;
@property (nonatomic, strong, readonly) NSArray *articles_published;
@property (nonatomic, strong) NSMutableArray *articles;

- (void)refreshMessagesCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;
- (void)loadMoreMessagesCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;
@end

NS_ASSUME_NONNULL_END
