//
//  HpBaseLogic.m
//  GKHelpOutApp
//
//  Created by kky on 2019/2/20.
//  Copyright © 2019年 kky. All rights reserved.
//

#import "HpBaseLogic.h"

@implementation HpBaseLogic

//- (void)checkDataWithCallback:(CheckDataCallback)callback {
//    
//}

- (void)fetchDataWithParams:(id)params completed:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback {
    
}

+ (NSArray *)jsonsToModelsWithJsons:(NSArray *)jsons {
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *json in jsons) {
        id model = [[self class] yy_modelWithJSON:json];
        if (model) {
            [models addObject:model];
        }
    }
    return models;
}

@end
