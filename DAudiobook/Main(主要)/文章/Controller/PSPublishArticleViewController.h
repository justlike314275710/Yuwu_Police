//
//  PSPublishArticleViewController.h
//  PrisonService
//
//  Created by kky on 2019/8/5.
//  Copyright © 2019年 calvin. All rights reserved.
//

#import "DViewController.h"
#import "PSPublishArticleViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PSPublishArticleViewController :DViewController
@property(nonatomic,copy)NSString *penName;
@property(nonatomic,strong)PSPublishArticleViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
