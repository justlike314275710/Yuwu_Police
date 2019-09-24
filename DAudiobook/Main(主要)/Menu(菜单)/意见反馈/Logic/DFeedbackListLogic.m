//
//  DFeedbackListLogic.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/19.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DFeedbackListLogic.h"

@interface DFeedbackListLogic()

@property (nonatomic , strong) NSMutableArray *items;

@end



@implementation DFeedbackListLogic
@synthesize dataStatus = _dataStatus;
-(id)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.pageSize = 10;
    }
    return self;
}


-(NSArray*)Recodes{
    return _items;
}

- (void)refreshFeedbackListCompleted:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    self.page = 1;
    self.items = nil;
    self.hasNextPage = NO;
    self.dataStatus = PSDataInitial;
}


@end
