//
//  DFeedbackListLogic.h
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/19.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "HpBaseLogic.h"

@interface DFeedbackListLogic : HpBaseLogic
@property (nonatomic, strong,readonly) NSArray *Recodes;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL hasNextPage;
@property (nonatomic, copy)   NSString *id;


- (void)refreshFeedbackListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;


@end
