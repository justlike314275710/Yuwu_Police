//
//  DLeftMenuViewController.m
//  DAudiobook
//
//  Created by DUCHENGWEN on 2019/4/20.
//  Copyright © 2019 liujiliu. All rights reserved.
//

#import "DLeftMenuViewController.h"
#import "DMenuModel.h"
#import "DSideMenuTableViewCell.h"
#import "DAllControllersTool.h"
#import "DMenuHeadView.h"
#import "DPlayMusicView.h"
#import "DMeViewController.h"
#import "DNavigationController.h"
#import "DMusicDetailVIewController.h"
#import "DResetPasswordViewController.h"
#import "DPasswordLogic.h"
#import "DPasswordViewController.h"
#import "DModiyPhoneViewcontroller.h"
#import "DWriteFeedListViewController.h"

@interface DLeftMenuViewController ()

@property (nonatomic,strong) DMenuHeadView  *menuHeadView;
@property (nonatomic,strong) DPlayMusicView *playMusicView;

@end

@implementation DLeftMenuViewController
- (void)viewDidAppear:(BOOL)animated {
    [self.menuHeadView.timer fire];
    [self.menuHeadView refreshvView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.menuHeadView.timer invalidate];
    self.menuHeadView.timer = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top =-MenuHeadViewTopDistance;
    [self.tableView setContentInset:contentInset];
    self.tableView.backgroundColor=ImportantColor;
}

-(void)initializeData{
    [self.listArray  addObjectsFromArray:[DMenuModel getMenuModeldataArry]];
    [self.tableView  reloadData];
    
}
//区头
-(void)initializeTableHeaderView{
     self.menuHeadView.frame=CGRectMake(0, 0, kScreenWidth,200+MenuHeadViewTopDistance);
     self.tableView.tableHeaderView = self.menuHeadView;
     WEAKSELF
     self.menuHeadView.headerViewBlock = ^{
        DMeViewController *VC = [[DMeViewController alloc] init];
        DNavigationController*NVC = [[DNavigationController alloc] initWithRootViewController:VC];
        [weakSelf presentDropsWaterViewController:NVC];
       };
}
//区尾
- (void)initializeTableFooterView
{
    /*
    //设置尾部播放音乐视图
    [self.playMusicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    
    WEAKSELF
    self.playMusicView.bottomMusicBlock = ^(void) {
        if ([DPlayerManager defaultManager].musicArray.count) {
            DMusicDetailVIewController*VC=[[DMusicDetailVIewController alloc]init];
            [weakSelf presentDropsWaterViewController:VC];
        }else{
             [weakSelf.view showLoadingMeg:@"未选择音乐" time:kDefaultShowTime];
        }
    };
     */
    UIView*versionView=[[UIView alloc]init];
    [self.view addSubview:versionView];
    [versionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-100);
        make.height.mas_equalTo(20);
    }];
  
    UILabel*titleLable=[UILabel new];
    [versionView addSubview:titleLable];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.font=FontOfSize(12);
    titleLable.text=@"版本号:v1.00";
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-50);
        make.height.mas_equalTo(20);
    }];
    //titleLable.textAlignment=NSTextAlignmentCenter;
}
//加载刷新控件
-(void)initializeRefresh{

}
- (void)setupNavItem
{
}

#pragma mark  - UITableViewDelegate-回调
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSideMenuTableViewCell *cell = [DSideMenuTableViewCell cellWithTableView:tableView];
    DMenuModel *model = self.listArray[indexPath.row];
    [cell setData:model];
    return cell;
}
 //点击对应的cell切换对应的视图控制器
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DMenuModel *model = self.listArray[indexPath.row];
   // [DAllControllersTool createViewControllerWithIndex:model];
    [self pushViewControllerWithIndex:model];
    
}



- (void)pushViewControllerWithIndex:(DMenuModel*)menuModel;
{
    
    switch (menuModel.menuType) {
            
        case KCollectionType:{
            //[self.navigationController pushViewController:[[DLoginViewController alloc]init] animated:YES];
//            [self presentViewController:[[DLoginViewController alloc]init]  animated:YES completion:^{
//
//            }];
            
        }
            break;
            
        case KArticleType:{
           // navVC=self.crosstalkNavigationController;
            
        }
            break;
            
        case KOpinionType:{
            [self opinionAction];
            
        }
            break;
            
        case KPasswordType:{
            [self passwordAction];
        }
            break;
            
            
        case KPhonenumberType:{
            [self phonePhoneAction];
            
        }
            break;
            
        case KVersionType:{
           // navVC=self.historyNavigationController;
             [self loginOutAction];
            
        }
            break;
            
        case KLogoutType:{
            //navVC=self.martialNavigationController;
            [self loginOutAction];
            
        }
            break;
        default:
            break;
    }
    //切换根控制器
//    [self.drawerController setCenterViewController:navVC];
//    [UIApplication sharedApplication].keyWindow.rootViewController = self.drawerController;
//    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
//    [self.drawerController closeDrawerAnimated:YES completion:nil];
}

#pragma mark -- 注销登录
-(void)loginOutAction{
    
    [PSAlertView showWithTitle:nil message:@"确定要退出吗?" messageAlignment:NSTextAlignmentCenter image:nil handler:^(PSAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [help_userManager logout:nil];
        }
    } buttonTitles:@"取消",@"确定", nil];
}

#pragma mark -- 修改手机号码
-(void)phonePhoneAction{
    DModiyPhoneViewcontroller*modiyPhoneViewcontroller=[[DModiyPhoneViewcontroller alloc]init];
    DNavigationController*navVC=[[DNavigationController alloc]initWithRootViewController:modiyPhoneViewcontroller];
    [self presentViewController:navVC animated:YES completion:nil];
}
#pragma mark -- 意见反馈
-(void)opinionAction{
    DWriteFeedListViewController*feedList=[[DWriteFeedListViewController alloc]init];
    DNavigationController*navVC=[[DNavigationController alloc]initWithRootViewController:feedList];
    [self presentViewController:navVC animated:YES completion:nil];
}
#pragma mark -- 重置密码
-(void)passwordAction{
    DPasswordLogic*logic=[[DPasswordLogic alloc]init];
    [logic requestBoolPasswordCompleted:^(id data) {
        DNavigationController *navVC = [[DNavigationController alloc]initWithRootViewController:[[DResetPasswordViewController alloc]init]];
        [self presentViewController:navVC animated:YES completion:nil];
    } failed:^(NSError *error) {
        [PSAlertView showWithTitle:@"提示" message:@"请先设置密码" messageAlignment:NSTextAlignmentCenter image:nil handler:^(PSAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==1) {
                DNavigationController *navVC = [[DNavigationController alloc]initWithRootViewController:[[DPasswordViewController alloc]init]];
                [self presentViewController:navVC animated:YES completion:nil];
            }
        } buttonTitles:@"取消",@"设置", nil];
    }];
}

#pragma mark - 懒加载
- (DMenuHeadView *)menuHeadView
{
    if (!_menuHeadView) {
        _menuHeadView = [[DMenuHeadView alloc] init];
        [self.view addSubview:_menuHeadView];
    }
    return _menuHeadView;
}
- (DPlayMusicView *)playMusicView
{
    if (!_playMusicView) {
        _playMusicView= [[DPlayMusicView alloc]init];
         [self.view addSubview:_playMusicView];
    }
    return _playMusicView;
}


@end
