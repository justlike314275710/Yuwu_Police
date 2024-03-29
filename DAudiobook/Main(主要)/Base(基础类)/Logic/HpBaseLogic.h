//
//  HpBaseLogic.h
//  GKHelpOutApp
//
//  Created by kky on 2019/2/20.
//  Copyright © 2019年 kky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PSDataStatus) {
    PSDataInitial = 0, //类刚刚初始化，还未获取数据
    PSDataError,       //接口获取数据失败
    PSDataEmpty,       //接口正常返回无数据
    PSDataNormal       //接口返回有正常数据
};

typedef void(^RequestDataCompleted)(id data);
typedef void(^RequestDataFailed)(NSError *error);
typedef void(^RequestDataTaskCompleted)(id data);
typedef void(^CheckDataCallback)(BOOL successful, NSString *tips);
typedef void(^Complete)(void);

@interface HpBaseLogic : NSObject

@property (nonatomic, assign) PSDataStatus dataStatus;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) BOOL hasNextPage;


- (void)checkDataWithCallback:(CheckDataCallback)callback;

- (void)fetchDataWithParams:(id)params completed:(RequestDataCompleted)completedCallback failed:(RequestDataFailed)failedCallback;








@end

