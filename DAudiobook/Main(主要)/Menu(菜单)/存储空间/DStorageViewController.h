//
//  DStorageViewController.h
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/10/28.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DViewController.h"
typedef void (^ClearScuessBlock)();
@interface DStorageViewController : DViewController
@property (nonatomic, copy)ClearScuessBlock clearScuessBlock;
@end
