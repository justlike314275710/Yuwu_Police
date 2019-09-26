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
#import "PSArticleDetailViewModel.h"
#import "PSDetailArticleViewController.h"

@interface DHotNovelViewController()<UITableViewDelegate,UITableViewDataSource> {
    
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
//    [self SearchBar];

    self.logic = [HomePageLogic new];
    
    [self setupUI];
    
    [self setupData];
    //下啦刷新
    [self refreshData];
    
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
}

#pragma - PrivateMethods
- (void)setupUI {

    [self.view addSubview:self.tableview];
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


//获取发布文章权限
- (void)setupData{
    [self.logic authorArticleCompleted:^(id data) {
        [self.publishBtn setImage:ImageNamed(@"发布") forState:UIControlStateNormal];
    } failed:^(NSError *error) {
        [_publishBtn setImage:IMAGE_NAMED(@"不能发布") forState:UIControlStateNormal];
    }];
}

#pragma - TouchEvent
//MARK:发布
-(void)publishAction:(UIButton *)sender{
    PSPublishArticleViewModel *viewModel = [[PSPublishArticleViewModel alloc] init];
    if (!self.logic.author) {
        [PSTipsView showTips:@"暂无权限!"];
        return;
    }
    viewModel.type = PSPublishArticle;
    PSPublishArticleViewController *publishVC = [[PSPublishArticleViewController alloc] init];
    publishVC.viewModel = viewModel;
    [self.navigationController pushViewController:publishVC animated:YES];
}



-(void)SearchBar{
//    UISearchBar*searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,30,SCREEN_WIDTH-6*15,15)];
//    searchBar.delegate = self;
//    searchBar.placeholder = @"搜索文章|连载书籍";
//    searchBar.barTintColor = [UIColor whiteColor];
//    searchBar.tintColor = [UIColor blackColor];
//    searchBar.layer.borderWidth = 1.0f;
//    searchBar.layer.cornerRadius = 5.0f;
//    searchBar.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);
//    
//    UIView *searchBarBgView = [[UIView alloc]init];
//    searchBarBgView.backgroundColor = [UIColor clearColor];
//    searchBar.clipsToBounds = YES;
//    [searchBarBgView addSubview:searchBar];
//    
//    self.navigationItem.titleView= searchBarBgView;
//    self.navigationItem.titleView.frame = CGRectMake(0,30,SCREEN_WIDTH-6*15,15);
}

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
//        if (action) {
//            [self praiseActionid:id result:result];
//        } else {
//            [self deletePraiseActionid:id result:result];
//        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 175;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    PSArticleDetailModel *model = [self.logic.datalist objectAtIndex:indexPath.row];
    PSArticleDetailViewModel *viewModel = [PSArticleDetailViewModel new];
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
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        //刷新另外的列表
//        KPostNotification(KNotificationRefreshCollectArticle, nil);
//        KPostNotification(KNotificationRefreshMyArticle, nil);
        
    };
    //热度刷新
    DetailArticleVC.hotChangeBlock = ^(NSString *clientNum) {
        //刷新
        model.clientNum = clientNum;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//        KPostNotification(KNotificationRefreshCollectArticle, nil);
//        KPostNotification(KNotificationRefreshMyArticle, nil);
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



#pragma mark - 相声评书
@implementation DCrosstalkViewController

//获取URL
-(NSString *)getURL{
    return CrosstalkUrl;
}
//获取title
-(NSString *)getMenuTitle{
    return @"相声";
}

@end




#pragma mark - 玄幻小说
@implementation DFantasyViewController

//获取URL
-(NSString *)getURL{
    return FantasyUrl;
}
//获取title
-(NSString *)getMenuTitle{
    return @"玄幻";
}

@end


#pragma mark - 都市小说
@implementation DCityViewController

//获取URL
-(NSString *)getURL{
    return CityUrl;
}
//获取title
-(NSString *)getMenuTitle{
    return @"都市";
}
@end


#pragma mark - 恐怖小说
@implementation DTerroristViewController

//获取URL
-(NSString *)getURL{
    return TerroristUrl;
}
//获取title
-(NSString *)getMenuTitle{
    return @"恐怖";
}

@end


#pragma mark - 历史小说
@implementation DHistoryViewController

//获取URL
-(NSString *)getURL{
    return HistoryUrl;
}
//获取title
-(NSString *)getMenuTitle{
    return @"历史";
}

@end


#pragma mark - 武侠小说
@implementation DMartialViewController

//获取URL
-(NSString *)getURL{
    return MartialUrl;
}
//获取title
-(NSString *)getMenuTitle{
    return @"武侠";
}

@end
