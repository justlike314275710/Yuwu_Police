//
//  DStorageLogic.h
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/10/28.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "HpBaseLogic.h"

@interface DStorageLogic : HpBaseLogic
@property(nonatomic,copy) NSString *allStorage;
@property(nonatomic,copy,readonly) NSString *usedStorage;
@end
