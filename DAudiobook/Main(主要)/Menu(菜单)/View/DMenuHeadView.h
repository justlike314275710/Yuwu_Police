//
//  DMenuHeadView.h
//  DAudiobook
//
//  Created by DUCHENGWEN on 2019/4/20.
//  Copyright © 2019 liujiliu. All rights reserved.
//
#import "LPButton.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define MenuHeadViewTopDistance 200

@interface DMenuHeadView : DView

typedef void(^HeaderViewClickEvent)(void);

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, copy) HeaderViewClickEvent headerViewBlock;

@property(nonatomic, strong) UIImageView    *iconView;
@property(nonatomic, strong) UILabel        *nameLable;

@property(nonatomic, strong) NSString *uesrName;
@property(nonatomic, strong) UIImage  *userIcon;
@property(nonatomic, strong) NSString *userInfo;

@property(nonatomic, strong) UIScrollView   *backView;
@property(nonatomic, strong) UIImageView    *scrollImageView;
@property(nonatomic, strong) UIButton       *tapButton;
@property(nonatomic, strong) LPButton * AuthenticaBtn;


@end

NS_ASSUME_NONNULL_END
