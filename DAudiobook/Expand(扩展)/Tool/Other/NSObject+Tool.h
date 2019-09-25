//
//  NSObject+Tool.h
//  DAudiobook
//
//  Created by kky on 2019/9/25.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Tool)

//解析json 数组
+ (NSArray *)jsonsToModelsWithJsons:(NSArray *)jsons;

@end

NS_ASSUME_NONNULL_END
