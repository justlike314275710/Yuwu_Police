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
#import "DAccountViewController.h"
#import "MineArticleViewController.h"
#import "CollectionArtcleViewController.h"
#import "PSCollecArtcleListViewModel.h"
#import "DStorageViewController.h"

@interface DLeftMenuViewController ()

@property (nonatomic,strong) DMenuHeadView  *menuHeadView;
@property (nonatomic,strong) DPlayMusicView *playMusicView;
@property (nonatomic , strong)NSString * pseudinym ;
@property (nonatomic , strong)  NSArray *array ;
@end

@implementation DLeftMenuViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadHeaderView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top =-MenuHeadViewTopDistance;
    [self.tableView setContentInset:contentInset];
    //self.tableView.backgroundColor=ImportantColor;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadHeaderView)
                                                 name:KNotificationMineDataChange
                                               object:nil];
    [self setTableViewBackcolorUI];
}


-(void)setTableViewBackcolorUI{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:76/255.0 green:179/255.0 blue:244/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:32/255.0 green:124/255.0 blue:251/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0f)];
    
    [view.layer addSublayer:gl];
    view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:42/255.0 blue:162/255.0 alpha:0.2].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,4);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 9;
    [self.tableView setBackgroundView:view];
}

-(void)initializeData{
    [self.listArray  addObjectsFromArray:[DMenuModel getMenuModeldataArry]];
    [self.tableView  reloadData];
    
}

-(void)reloadHeaderView{
    NSString *access_token =help_userManager.oathInfo.access_token;
    NSString *token = NSStringFormat(@"Bearer %@",access_token);
    [PPNetworkHelper setValue:token forHTTPHeaderField:@"Authorization"];
    NSString *url = NSStringFormat(@"%@%@",EmallHostUrl,URL_get_im_info);
    [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[PSLoadingView sharedInstance]dismiss];
        });
        if (ValidDict(responseObject)) {
            UserInfo *userInfo = [UserInfo modelWithDictionary:responseObject];
            help_userManager.curUserInfo.avatar=userInfo.avatar;
            [self initializeTableHeaderView];
        } else {
            
        }
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[PSLoadingView sharedInstance]dismiss];
        });
    }];
    
   
}

//区头
-(void)initializeTableHeaderView{
     self.menuHeadView.frame=CGRectMake(0, 0, kScreenWidth,200+MenuHeadViewTopDistance);
    
    [self.menuHeadView.iconView setImageWithURL:[NSURL URLWithString:help_userManager.curUserInfo.avatar] placeholder:[UIImage imageNamed:@"侧滑－大头像"]];
     self.tableView.tableHeaderView = self.menuHeadView;
    [self getArticeData];
     WEAKSELF
     self.menuHeadView.headerViewBlock = ^{
         DAccountViewController*vc=[[DAccountViewController alloc]init];
         DNavigationController*nav=[[DNavigationController alloc]initWithRootViewController:vc];
         [weakSelf presentViewController:nav animated:YES completion:nil];
         
       };
    [self.menuHeadView.AuthenticaBtn bk_whenTapped:^{
        DAccountViewController*vc=[[DAccountViewController alloc]init];
        DNavigationController*nav=[[DNavigationController alloc]initWithRootViewController:vc];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    }];
}

-(void)getArticeData{
    NSString *url = NSStringFormat(@"%@%@",ServerUrl,URL_Police_updateArticle);
    NSString*token=[NSString stringWithFormat:@"Bearer %@",help_userManager.oathInfo.access_token];
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setValue:token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
        NSString*code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            self.pseudinym=responseObject[@"data"][@"pseudonym"];
            if( ValidStr(self.pseudinym)){
                 _array = [self.pseudinym componentsSeparatedByString:@"-"];
                 self.menuHeadView.nameLable.text=_array[1];
            }
            else{
                self.menuHeadView.nameLable.text=@"";}
        }
        else{
            [PSTipsView showTips:@"获取账号信息失败!"];
        }
    } failure:^(NSError *error) {
        [PSTipsView showTips:@"获取账号信息失败!"];
    }];
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
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    titleLable.text=NSStringFormat(@"版本号:v%@",app_Version);
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


#pragma mark  - UITableViewDelegate-回调
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSideMenuTableViewCell *cell = [DSideMenuTableViewCell cellWithTableView:tableView];
    cell.backgroundColor=[UIColor clearColor];
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
            [self mycollectionArticle];
        }
            break;
            
        case KArticleType:{
           // navVC=self.crosstalkNavigationController;
            [self myAllArticle];
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
            
        case KStorageType:{
           // navVC=self.historyNavigationController;
             [self storageOutAction];
            
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

#pragma mark -- 存储空间
-(void)storageOutAction{
    DStorageViewController*storageVC=[[DStorageViewController alloc]init];
    DNavigationController*navVC=[[DNavigationController alloc]initWithRootViewController:storageVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark -- 我的收藏
-(void)mycollectionArticle {
    PSCollecArtcleListViewModel *collecArtcleViewModel = [PSCollecArtcleListViewModel new];
    CollectionArtcleViewController*collecArticleVC=[[CollectionArtcleViewController alloc]init];
    collecArticleVC.viewModel = collecArtcleViewModel;
    DNavigationController*navVC=[[DNavigationController alloc]initWithRootViewController:collecArticleVC];
    [self presentViewController:navVC animated:YES completion:nil];
}
#pragma mark -- 我的文章
-(void)myAllArticle {
    MineArticleViewController*mineArticleVC=[[MineArticleViewController alloc]init];
    DNavigationController*navVC=[[DNavigationController alloc]initWithRootViewController:mineArticleVC];
    [self presentViewController:navVC animated:YES completion:nil];
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
