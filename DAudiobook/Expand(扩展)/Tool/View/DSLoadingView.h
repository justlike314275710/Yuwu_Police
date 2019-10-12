//
//  DSLoadingView.h
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/10/12.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLoadingView : UIView
+ (DSLoadingView *)sharedInstance;
- (void)show;
- (void)showOnView:(UIView *)view;
- (void)dismiss;
@end
