//
//  PSTextField.m
//  PrisonService
//
//  Created by calvin on 2018/4/9.
//  Copyright © 2018年 calvin. All rights reserved.
//

#import "PSUnderlineTextField.h"

@implementation PSUnderlineTextField

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, UIColorHex(0xebebeb).CGColor);
    CGContextMoveToPoint(context, 0, CGRectGetHeight(rect) - 1);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect) - 1);
    CGContextStrokePath(context);
}

@end
