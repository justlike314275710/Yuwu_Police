//
//  PSLoginBackgroundView.m
//  PrisonService
//
//  Created by calvin on 2018/4/9.
//  Copyright © 2018年 calvin. All rights reserved.
//

#import "PSLoginBackgroundView.h"
#import "CAGradientLayer+Gradient.h"

@implementation PSLoginBackgroundView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *color1 =UIColorHex(0xffffff) ;
        UIColor *color2 = UIColorHex(0xe6e7e1);
        CAGradientLayer *gradientLayer = [CAGradientLayer layerWithFrame:[UIScreen mainScreen].bounds colors:@[(__bridge id)color1.CGColor,(__bridge id)color2.CGColor]];
        [self.layer addSublayer:gradientLayer];
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
