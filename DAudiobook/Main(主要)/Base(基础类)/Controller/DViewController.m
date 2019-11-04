//
//  DViewController.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/9.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DViewController.h"
#import "AppDelegate.h"

@interface DViewController ()<UIGestureRecognizerDelegate>

@end

@implementation DViewController
//视图出现
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.indicatorAnimationView];
    [self.indicatorAnimationView resumeLayer];
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //网络状态返回
    self.indicatorAnimationView=[[DIndicatorView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, 1)];
    [self.view addSubview:self.indicatorAnimationView];
    self.indicatorAnimationView.hidden=YES;
    self.count=12;
    
    
    
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    self.navigationController.interactivePopGestureRecognizer.delegate=self;
//}
//
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    return NO;
//}

-(void)addBackItem{
   

//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
  self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:IMAGE_NAMED(@"返回") style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}
-(void)backAction{
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count > 1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) { //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else { //present方式
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
-(void)addRightBarButtonItem:(UIImage *)rightImage{
      self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
}

-(void)addRightBarButtonTitleItem:(NSString *)rightTitle{
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
}
-(void)rightItemClick{
    
}
/*
- (void)showNetError:(NSError *)error {
    
    if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"Request failed: unauthorized (401)"]) {
        [self showTokenError];
    } else {
        NSDictionary *body = [self errorData:error];
        if (body) {
            NSString*message=body[@"message"];
            if (message) {
                [PSTipsView showTips:message];
            } else {
                [self showNetErrorMsg];
            }
        } else {
            [self showNetErrorMsg];
        }
    }
}

//服务器异常OR没有网络
-(void)showNetErrorMsg{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdelegate.IS_NetWork == NO) {
        NSString*InternetError=NSLocalizedString(@"InternetError", @"无法连接到服务器，请检查网络");
        [PSTipsView showTips:InternetError];
    } else {
        NSString*NetError=NSLocalizedString(@"NetError", @"服务器异常");
        [PSTipsView showTips:NetError];
    }
}
//token过期
-(void)showTokenError {
    NSString*NetError=NSLocalizedString(@"Login status expired, please log in again", @"登录状态过期,请重新登录!");
    NSString*determine=NSLocalizedString(@"determine", @"确定");
    NSString*Tips=NSLocalizedString(@"Tips", @"提示");
    XXAlertView*alert=[[XXAlertView alloc]initWithTitle:Tips message:NetError sureBtn:determine cancleBtn:nil];
    alert.clickIndex = ^(NSInteger index) {
        if (index==2) {
            [[PSSessionManager sharedInstance] doLogout];
        }
    };
    [alert show];
}

//服务器异常OR没有网络
-(void)showNetErrorMsg{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdelegate.IS_NetWork == NO) {
        NSString*InternetError=NSLocalizedString(@"InternetError", @"无法连接到服务器，请检查网络");
        [PSTipsView showTips:InternetError];
    } else {
        NSString*NetError=NSLocalizedString(@"NetError", @"服务器异常");
        [PSTipsView showTips:NetError];
    }
}

-(NSDictionary*)errorData:(NSError*)error {
    NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (data) {
        id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return body;
    } else {
        return nil;
    }
}
 */

- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

@end
