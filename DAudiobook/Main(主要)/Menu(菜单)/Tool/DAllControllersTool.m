//
//  DAllControllersTool.m
//  DAudiobook
//
//  Created by DUCHENGWEN on 2019/4/22.
//  Copyright © 2019 liujiliu. All rights reserved.
//

#import "DAllControllersTool.h"
#import "DLeftMenuViewController.h"
#import "DNavigationController.h"
#import "DHotNovelViewController.h"
#import "DPasswordLogic.h"
#import "DLoginViewController.h"
#import "DResetPasswordViewController.h"
@interface DAllControllersTool ()

@property (nonatomic,strong) DLeftMenuViewController *menuController;

@property (nonatomic,strong) DNavigationController  *hotNovelNavigationController;
@property (nonatomic,strong) DNavigationController  *crosstalkNavigationController;
@property (nonatomic,strong) DNavigationController  *fantasyNavigationController;
@property (nonatomic,strong) DNavigationController  *cityNavigationController;
@property (nonatomic,strong) DNavigationController  *terroristNavigationController;
@property (nonatomic,strong) DNavigationController  *historyNavigationController;
@property (nonatomic,strong) DNavigationController  *martialNavigationController;

@property (nonatomic,strong) DNavigationController  *ResetPasswordNavigationController;

@end

@implementation DAllControllersTool

+ (instancetype)shareOpenController
{
    //获取到调度的唯一对象
    static DAllControllersTool *tempTool = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempTool = [[DAllControllersTool alloc] init];
    });
    
    return tempTool;
}
#pragma mark -懒加载
- (DLeftMenuViewController *)menuController
{
    if (!_menuController) {
        _menuController = [[DLeftMenuViewController alloc] init];
    }
    return _menuController;
}
- (MMDrawerController *)drawerController
{
    
    if (!_drawerController) {
        _drawerController = [[MMDrawerController alloc] init];
        _drawerController.showsShadow = YES;
        [_drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width * 0.75];
        [_drawerController setOpenDrawerGestureModeMask: MMOpenDrawerGestureModeNone ];
        [_drawerController setCloseDrawerGestureModeMask:
         MMCloseDrawerGestureModeNone];
        [_drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
            KPostNotification(@"hideKeyboard", nil);
            MMDrawerControllerDrawerVisualStateBlock block = [MMDrawerVisualState slideVisualStateBlock];
            if (block) {
                block(drawerController,drawerSide,percentVisible);
            }
        }];
        
        [_drawerController setLeftDrawerViewController:self.menuController];
    }
    
    return _drawerController;
}
- (NSMutableArray *)controllerArray
{
    
    if (!_controllerArray) {
        _controllerArray = [NSMutableArray array];
    }
    return _controllerArray;
}
- (DNavigationController *)hotNovelNavigationController
{
    if (!_hotNovelNavigationController) {
        DHotNovelViewController *VC = [[DHotNovelViewController alloc] init];
        _hotNovelNavigationController = [[DNavigationController alloc] initWithRootViewController:VC];
    }
    return _hotNovelNavigationController;
}

- (DNavigationController *)crosstalkNavigationController
{
    if (!_crosstalkNavigationController) {
//         DCrosstalkViewController *VC = [[DCrosstalkViewController alloc] init];
//        _crosstalkNavigationController = [[DNavigationController alloc] initWithRootViewController:VC];
    }
    return _crosstalkNavigationController;
}
- (DNavigationController *)fantasyNavigationController
{
    if (!_fantasyNavigationController) {
//        DFantasyViewController *VC = [[DFantasyViewController alloc] init];
//        _fantasyNavigationController = [[DNavigationController alloc] initWithRootViewController:VC];
    }
    return _fantasyNavigationController;
}
- (DNavigationController *)cityNavigationController
{
    if (!_cityNavigationController) {
//        DCityViewController *VC = [[DCityViewController alloc] init];
//        _cityNavigationController = [[DNavigationController alloc] initWithRootViewController:VC];
    }
    return _cityNavigationController;
}
- (DNavigationController *)terroristNavigationController
{
    if (!_terroristNavigationController) {
//        DTerroristViewController *VC = [[DTerroristViewController alloc] init];
//        _terroristNavigationController = [[DNavigationController alloc] initWithRootViewController:VC];
    }
    return _terroristNavigationController;
}
- (DNavigationController *)historyNavigationController
{
    if (!_historyNavigationController) {
//        DHistoryViewController *VC = [[DHistoryViewController alloc] init];
//        _historyNavigationController = [[DNavigationController alloc] initWithRootViewController:VC];
    }
    return _historyNavigationController;
}
- (DNavigationController *)martialNavigationController
{
    if (!_martialNavigationController) {
//        DMartialViewController *VC = [[DMartialViewController alloc] init];
//        _martialNavigationController = [[DNavigationController alloc] initWithRootViewController:VC];
    }
    return _martialNavigationController;
}

- (DNavigationController *)ResetPasswordNavigationController{
    if (!_ResetPasswordNavigationController) {
        DResetPasswordViewController *VC = [[DResetPasswordViewController alloc] init];
        _ResetPasswordNavigationController = [[DNavigationController alloc] initWithRootViewController:VC];
    }
    return _ResetPasswordNavigationController;
}


#pragma mark - 调度方法
+ (void)createViewControllerWithIndex:(DMenuModel*)menuModel
{
    //获取当前类的(唯一)对象
    DAllControllersTool *dispatchTool = [DAllControllersTool shareOpenController];
    //用当前类的对象 执行实际选择执行的方法
    [dispatchTool openViewControllerWithIndex:menuModel];

}





#pragma mark - 实际选择执行的方法
- (void)openViewControllerWithIndex:(DMenuModel*)menuModel;
{
    static DNavigationController *navVC = nil;
    switch (menuModel.menuType) {
            
        case KCollectionType:{
            navVC=self.hotNovelNavigationController;
            
        }
            break;
            
        case KArticleType:{
            navVC=self.crosstalkNavigationController;
            
        }
            break;
            
        case KOpinionType:{
            navVC=self.fantasyNavigationController;
            
        }
            break;
          
        case KPasswordType:{
//            DPasswordLogic*logic=[[DPasswordLogic alloc]init];
//            [logic requestBoolPasswordCompleted:^(id data) {
//                navVC=self.cityNavigationController;
//            } failed:^(NSError *error) {
//                [PSAlertView showWithTitle:@"提示" message:@"请先设置密码" messageAlignment:NSTextAlignmentCenter image:nil handler:^(PSAlertView *alertView, NSInteger buttonIndex) {
//                    if (buttonIndex==1) {
//
//                    }
//                } buttonTitles:@"取消",@"设置", nil];
//            }];
            navVC=self.ResetPasswordNavigationController;
            }
            break;
            
           
        case KPhonenumberType:{
            navVC=self.terroristNavigationController;
            
        }
            break;
            
        case KStorageType:{
            navVC=self.historyNavigationController;
            
        }
            break;
            
        case KLogoutType:{
            navVC=self.martialNavigationController;
            
        }
            break;
            
    }
    //切换根控制器
    [self.drawerController setCenterViewController:navVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = self.drawerController;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    [self.drawerController closeDrawerAnimated:YES completion:nil];
}

@end
