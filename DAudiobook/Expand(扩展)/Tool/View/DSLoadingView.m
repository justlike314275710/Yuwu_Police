//
//  STLoadingView.m
//  Components
//
//  Created by calvin on 14-5-5.
//  Copyright (c) 2014年 BuBuGao. All rights reserved.
//

#import "DSLoadingView.h"
#import "DGActivityIndicatorView.h"
#import "LLGifImageView.h"
@interface DSLoadingView ()

@property (nonatomic, strong) DGActivityIndicatorView *indicatorView;
@property (nonatomic, strong) LLGifImageView *gifImageView;
@end

@implementation DSLoadingView

+ (DSLoadingView *)sharedInstance {
    static DSLoadingView *loadingView = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken,^{
        if (!loadingView) {
            loadingView = [[self alloc] init];
        }
    });
    return loadingView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"加载动画" ofType:@"gif"]];
        _gifImageView = [[LLGifImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
        _gifImageView.gifData = localData;
        [self addSubview:_gifImageView];
    }
    return self;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.gifImageView.center = self.center;
}

- (void)show {
    if ([NSThread mainThread]) {
        [self showOnView:[[UIApplication sharedApplication] keyWindow]];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showOnView:[[UIApplication sharedApplication] keyWindow]];
        });
    }
}

- (void)showOnView:(UIView *)view {
    self.frame = view.bounds;
    [self.gifImageView startGif];
    self.gifImageView.center = self.center;
    [view addSubview:self];
    [view bringSubviewToFront:self];
}

- (void)dismiss {
    if ([NSThread mainThread]) {
        [self.gifImageView stopGif];
        [self removeFromSuperview];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.gifImageView stopGif];
            [self removeFromSuperview];
        });
    }
}



@end

