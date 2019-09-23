//
//  PSLoginTopView.m
//  PrisonService
//
//  Created by calvin on 2018/4/9.
//  Copyright © 2018年 calvin. All rights reserved.
//

#import "PSLoginTopView.h"

@implementation PSLoginTopView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"登录logo"]];
        [self addSubview:logoImageView];
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(logoImageView.frame.size);
        }];
        
        NSString*textImage=@"登录狱务通－狱警版";
        UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:textImage]];
        [self addSubview:textImageView];
        [textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(logoImageView.mas_bottom).offset(9);
            make.size.mas_equalTo(textImageView.frame.size);
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
