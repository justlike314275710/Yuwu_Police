//
//  DNavigationController.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/9.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DNavigationController.h"

@implementation DNavigationController

- (void)viewDidLoad
{
    //=============================自定义返回按钮，开启原生滑动返回功能
    WEAKSELF
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = (id)weakSelf;
        self.delegate = (id)weakSelf;
    }
    //=============================
    [self setItems];
}
-(void)setItems
{

    //动态更改导航背景 / 样式
    //开启编辑
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置导航条背景颜色
   
//        UIView *view = [[UIView alloc] init];
//        view.frame = CGRectMake(0,25,SCREEN_WIDTH,48);
//
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,25,SCREEN_WIDTH,48);
//        gl.startPoint = CGPointMake(0, 0);
//        gl.endPoint = CGPointMake(1, 1);
//        gl.colors = @[(__bridge id)[UIColor colorWithRed:32/255.0 green:124/255.0 blue:251/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:76/255.0 green:179/255.0 blue:244/255.0 alpha:1.0].CGColor];
//        gl.locations = @[@(0.0),@(1.0f)];
//
//        [self.view.layer addSublayer:gl];
//        view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:42/255.0 blue:162/255.0 alpha:0.2].CGColor;
//        view.layer.shadowOffset = CGSizeMake(0,4);
//        view.layer.shadowOpacity = 1;
//        view.layer.shadowRadius = 9;
//        [self.navigationBar setBackgroundImage:[self convertViewToImage:view] forBarMetrics:UIBarMetricsDefault];
   
        [bar setBarTintColor:ImportantColor];
    
    
    
   // [bar setBarTintColor:ImportantColor];
    //设置字体颜色
    [bar setTintColor:[UIColor whiteColor]];
    //设置样式
    [bar setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName : [UIColor whiteColor],
                                  NSFontAttributeName : [UIFont boldSystemFontOfSize:14]
                                  }];
    
    //设置导航条按钮样式
    //开启编辑
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    //设置样式
    [item setTitleTextAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor whiteColor],
                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:16]
                                   } forState:UIControlStateNormal]; 
    
    
}




-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//==========================================================滑动返回卡住问题解决
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES)
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES)
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
}
#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}
#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer)
    {
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0])
        {
            return NO;
        }
    }
    return YES;
}
/**
 *  更改状态栏颜色
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


//设置状态栏是否隐藏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
