//
//  DHomeViewController.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/9.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DHotNovelViewController.h"
#import "DRadioListCell.h"
#import "DRadioModel.h"
#import "DAlbumViewController.h"
#import "DMessageViewController.h"
#import "HomePageLogic.h"
#import "PSPlatformArticleCell.h"
#import "PSPublishArticleViewModel.h"
#import "PSPublishArticleViewController.h"
#import "PSArticleDDetailViewModel.h"
#import "PSDetailArticleViewController.h"
#import "SearchBarDisplayCenter.h"
#import "MMDrawerBarButtonItem.h"
#import "UIBarButtonItem+Helper.h"
#import "LLSearchViewController.h"
#import "PPBadgeView.h"
@interface DHotNovelViewController()<UITableViewDelegate,UITableViewDataSource,SearchBarDisplayCenterDelegate> {

    
}
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UIButton *publishBtn;
@property (nonatomic,strong) HomePageLogic *logic;

@end

#pragma mark - 热门小说
@implementation DHotNovelViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self GDTadvertising];
  
    self.logic = [HomePageLogic new];
    [self SearchBar];
    [self setupUI];
    
//    [self setupData];
    
    //下啦刷新
    [self refreshData];
    
    self.tableview.ly_emptyView = [LYEmptyView emptyActionViewWithImage:ImageNamed(@"noData") titleStr:@"暂无数据" detailStr:nil btnTitleStr:@"" btnClickBlock:^{
        [self refreshData];
    }];
    
    //刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:KNotificationHomePageRefreshList object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRedDot) name:KNotificationRedDotRefresh object:nil];
    

}

-(void)refreshRedDot{
  [self.navigationItem.rightBarButtonItem pp_addDotWithColor:[UIColor redColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupData];
}

- (void)setupNavItem
{
    //设置导航栏唤醒抽屉按钮
    MMDrawerBarButtonItem *leftItem = [MMDrawerBarButtonItem itemWithNormalIcon:@"我的icon" highlightedIcon:nil target:self action:@selector(leftDrawerButtonPress)];

    //设置紧挨着左侧按钮的标题按钮
    //    MMDrawerBarButtonItem *titleItem = [MMDrawerBarButtonItem itemWithTitle:[self getMenuTitle] target:self action:@selector(leftDrawerButtonPress)];
    
    self.navigationItem.leftBarButtonItems = @[leftItem];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithNormalIcon:@"消息icon" highlightedIcon:nil target:self action:@selector(rightBarItemPress)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
    
}


- (BOOL)prefersStatusBarHidden{
    return NO;
}
//下啦刷新
- (void)refreshData{
    [[PSLoadingView sharedInstance] show];
    [self.logic refreshArticleListCompleted:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview.mj_header endRefreshing];
            [self.tableview reloadData];
             [self reloadContents];
            [[PSLoadingView sharedInstance] dismiss];
        });
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview.mj_header endRefreshing];
            [self.tableview reloadData];
            [self reloadContents];
            [[PSLoadingView sharedInstance] dismiss];
        });
    }];
}
//上啦
-(void)loadMore {
    [[PSLoadingView sharedInstance] show];
    [_logic loadMoreArticleListCompleted:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[PSLoadingView sharedInstance] dismiss];
            [self.tableview.mj_footer endRefreshing];
            [self.tableview reloadData];
            [self reloadContents];
        });
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[PSLoadingView sharedInstance] dismiss];
            [self.tableview.mj_footer endRefreshing];
            [self.tableview reloadData];
            [self reloadContents];
        });
    }];
    
}


- (void)rightBarItemPress{
    DMessageViewController*vc=[[DMessageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationItem.rightBarButtonItem  pp_hiddenBadge];
}

#pragma - PrivateMethods
- (void)setupUI {
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.publishBtn];
    [self.tableview registerClass:[PSPlatformArticleCell class] forCellReuseIdentifier:@"PSPlatformArticleCell"];
    self.tableview.tableFooterView = [UIView new];
    @weakify(self)
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self refreshData];
    }];
    
}

- (void)reloadContents {

    if (self.logic.hasNextPage) {
        @weakify(self)
        self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self loadMore];
        }];
    }else{
        self.tableview.mj_footer = nil;
    }
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
    [self.tableview reloadData];
}

//点赞
-(void)praiseActionid:(NSString *)articleID result:(PSPraiseResult)result {
    PSArticleDDetailViewModel *viewModel = [PSArticleDDetailViewModel new];
    viewModel.id = articleID;
    [viewModel praiseArticleCompleted:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *msg = data[@"msg"];
            NSInteger code = [data[@"code"] integerValue];
            [PSTipsView showTips:msg];
            if (code == 200){
                result(YES);
            } else {
                result(NO);
            }
        });
    } failed:^(NSError *error) {
        [PSTipsView showTips:@"点赞失败"];
        result(NO);
    }];
}
//取消点赞
-(void)deletePraiseActionid:(NSString *)articleId result:(PSPraiseResult)result {
    PSArticleDDetailViewModel *viewModel = [PSArticleDDetailViewModel new];
    viewModel.id = articleId;
    [viewModel deletePraiseArticleCompleted:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *msg = data[@"msg"];
            NSInteger code = [data[@"code"] integerValue];
            [PSTipsView showTips:msg];
            if (code == 200){
                result(YES);
            } else {
                result(NO);
            }
        });
    } failed:^(NSError *error) {
        [PSTipsView showTips:@"取消点赞失败"];
        result(NO);
    }];
}


//获取发布文章权限
- (void)setupData{
    [self.logic authorArticleCompleted:^(id data) {
        if (self.logic.author==YES) {
            [self.publishBtn setImage:ImageNamed(@"发布") forState:UIControlStateNormal];
        } else {
            [self.publishBtn setImage:IMAGE_NAMED(@"不能发布") forState:UIControlStateNormal];
        }
    } failed:^(NSError *error) {
        [_publishBtn setImage:IMAGE_NAMED(@"不能发布") forState:UIControlStateNormal];
    }];
}

#pragma - TouchEvent
//MARK:发布
-(void)publishAction:(UIButton *)sender{

    if (!self.logic.author) {
        [PSTipsView showTips:@"暂无权限!"];
        return;
    }
    PSPublishArticleViewModel *viewModel = [[PSPublishArticleViewModel alloc] init];
    viewModel.type = PSPublishArticle;
    PSPublishArticleViewController *publishVC = [[PSPublishArticleViewController alloc] init];
    publishVC.viewModel = viewModel;
    [self.navigationController pushViewController:publishVC animated:YES];
}



-(void)SearchBar{
    self.view.backgroundColor = [UIColor orangeColor];
    SearchBarDisplayCenter *searchBar = [[SearchBarDisplayCenter alloc]initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width-60, 30.0 )];
    searchBar.placeholderStr=@"搜索文章|连载书籍";
    searchBar.delegate = self;
    self.navigationItem.titleView= searchBar;
}

- (void)tapAction:(NSString *)searchWord{
    LLSearchViewController *seachVC = [[LLSearchViewController alloc] init];
    [self.navigationController pushViewController:seachVC animated:YES];
}



//-(void)getSearchKeyWord:(NSString *)searchWord{
//    LLSearchViewController *seachVC = [[LLSearchViewController alloc] init];
//    [self.navigationController pushViewController:seachVC animated:YES];
//}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logic.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSPlatformArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PSPlatformArticleCell"];
    cell.model = [self.logic.datalist objectAtIndex:indexPath.row];
    @weakify(self);
    cell.praiseBlock = ^(BOOL action, NSString *id, PSPraiseResult result) {
        @strongify(self);
        if (action) {
            [self praiseActionid:id result:result];
        } else {
            [self deletePraiseActionid:id result:result];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 175;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    PSArticleDetailModel *model = [self.logic.datalist objectAtIndex:indexPath.row];
    PSArticleDDetailViewModel *viewModel = [PSArticleDDetailViewModel new];
    viewModel.id = model.id;
    PSDetailArticleViewController *DetailArticleVC = [[PSDetailArticleViewController alloc] init];
    DetailArticleVC.viewModel = viewModel;
    //点赞回调刷新
    DetailArticleVC.praiseBlock = ^(BOOL isPraise, NSString *id, BOOL result) {
        if (isPraise) {
            model.praiseNum = [NSString stringWithFormat:@"%ld",[model.praiseNum integerValue]+1];
            model.ispraise = @"1";
        } else {
            model.praiseNum = [NSString stringWithFormat:@"%ld",[model.praiseNum integerValue]-1];
            model.ispraise = @"0";
        }
        //刷新
        if (indexPath.row<self.logic.datalist.count) {
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    //热度刷新
    DetailArticleVC.hotChangeBlock = ^(NSString *clientNum) {
        //刷新
        model.clientNum = clientNum;
        if (indexPath.row<self.logic.datalist.count) {
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    
    [self.navigationController pushViewController:DetailArticleVC animated:YES];
    
}

#pragma mark -Setting&&Getting
- (UIButton *)publishBtn {
    if (!_publishBtn) {
        _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishBtn.frame = CGRectMake(kScreenWidth-59,kScreenHeight-150,50,50);
        [_publishBtn setImage:IMAGE_NAMED(@"发布") forState:UIControlStateNormal];
        [_publishBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,64,self.view.width,kScreenHeight-64) style:UITableViewStyleGrouped];
        _tableview.backgroundColor = UIColorFromRGB(249,248,254);
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.dataSource = self;
        _tableview.delegate = self;
    }
    return _tableview;
}

@end






