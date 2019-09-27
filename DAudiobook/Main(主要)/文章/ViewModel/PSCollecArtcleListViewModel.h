//
//  PSCollecArtcleListViewModel.h
//  PrisonService
//
//  Created by kky on 2019/9/11.
//  Copyright © 2019年 calvin. All rights reserved.
//

#import "HpBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface PSCollecArtcleListViewModel : HpBaseLogic

@property (nonatomic, strong, readonly) NSArray *messages;


- (void)refreshMessagesCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;
- (void)loadMoreMessagesCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;

@end

NS_ASSUME_NONNULL_END
