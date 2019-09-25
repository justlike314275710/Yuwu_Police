//
//  NSObject+Tool.m
//  DAudiobook
//
//  Created by kky on 2019/9/25.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "NSObject+Tool.h"

@implementation NSObject (Tool)

+ (NSArray *)jsonsToModelsWithJsons:(NSArray *)jsons {
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *json in jsons) {
        id model = [[self class] modelWithJSON:json];
        if (model) {
            [models addObject:model];
        }
    }
    return models;
}

@end
