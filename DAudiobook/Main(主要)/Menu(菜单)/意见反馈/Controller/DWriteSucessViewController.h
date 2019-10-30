//
//  DWriteSucessViewController.h
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DViewController.h"
typedef void (^BackBlock)();
@interface DWriteSucessViewController : DViewController
@property(nonatomic,copy)BackBlock backBlock;

@end
