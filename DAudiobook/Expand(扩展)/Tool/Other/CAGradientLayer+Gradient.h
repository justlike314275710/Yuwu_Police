//
//  CAGradientLayer+Gradient.h
//  Start
//
//  Created by calvin on 2017/11/21.
//  Copyright © 2017年 DingSNS. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAGradientLayer (Gradient)

+ (CAGradientLayer *)layerWithFrame:(CGRect)frame
                  byRoundingCorners:(UIRectCorner)corners
                        cornerRadii:(CGSize)cornerRadii
                             colors:(NSArray *)colors;
+ (CAGradientLayer *)layerWithFrame:(CGRect)frame
                             colors:(NSArray *)colors;

@end
