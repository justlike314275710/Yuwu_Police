//
//  MessageLogic.h
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "HpBaseLogic.h"

@interface MessageLogic : HpBaseLogic
@property (nonatomic, strong, readonly) NSArray *messages;
//@property (nonatomic, assign) NSInteger page;
//@property (nonatomic, assign) NSInteger pageSize;
//@property (nonatomic, assign) BOOL hasNextPage;



- (void)refreshMessagesCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;
- (void)loadMoreMessagesCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;

@end
