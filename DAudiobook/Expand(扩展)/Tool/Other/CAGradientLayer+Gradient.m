//
//  CAGradientLayer+Gradient.m
//  Start
//
//  Created by calvin on 2017/11/21.
//  Copyright © 2017年 DingSNS. All rights reserved.
//

#import "CAGradientLayer+Gradient.h"

@implementation CAGradientLayer (Gradient)

+ (CAGradientLayer *)layerWithFrame:(CGRect)frame
                  byRoundingCorners:(UIRectCorner)corners
                        cornerRadii:(CGSize)cornerRadii
                             colors:(NSArray *)colors {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.colors = colors;
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:gradientLayer.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = gradientLayer.bounds;
    maskLayer.path = maskPath.CGPath;
    gradientLayer.mask = maskLayer;
    return gradientLayer;
}

+ (CAGradientLayer *)layerWithFrame:(CGRect)frame
                             colors:(NSArray *)colors {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.colors = colors;
    return gradientLayer;
}

@end
