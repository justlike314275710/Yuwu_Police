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
@interface DHotNovelViewController() {
    
}
@property (nonatomic,strong) UIButton *publishBtn;
@property (nonatomic,strong) HomePageLogic *logic;

@end

#pragma mark - 热门小说
@implementation DHotNovelViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self onHeaderRefreshing];
   // [self GDTadvertising];
    [self SearchBar];
    
    //加载刷新控件
    [self initializeRefresh];
    
    [self setupUI];
    
    [self setupData];
    //下啦刷新
    [self onHeaderRefreshing];
    
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}
//下啦刷新
- (void)onHeaderRefreshing{
    [[PSLoadingView sharedInstance] show];
    [self.logic refreshArticleListCompleted:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            [self setTableleUI];
            [[PSLoadingView sharedInstance] dismiss];
        });
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            [self setTableleUI];
            [[PSLoadingView sharedInstance] dismiss];
        });
    }];
}
//上啦
-(void)onFooterRefreshing {
    [[PSLoadingView sharedInstance] show];
    [_logic loadMoreArticleListCompleted:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[PSLoadingView sharedInstance] dismiss];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            [self setTableleUI];
        });
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[PSLoadingView sharedInstance] dismiss];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            [self setTableleUI];
        });
    }];
    
}
-(void)setTableleUI {
    @weakify(self);
    if (_logic.hasNextPage) {
        @strongify(self);
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self onFooterRefreshing];
        }];
    }else{
        self.tableView.mj_footer = nil;
    }
}

- (void)rightBarItemPress{
    DMessageViewController*vc=[[DMessageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma - PrivateMethods
-(void)setupUI{
    
    self.logic = [HomePageLogic new];
    
    [self.view addSubview:self.publishBtn];
    
    NSString *token = help_userManager.curUserInfo.token;
    
    NSLog(@"%@",token);
    
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
    DRadioModel *model = self.listArray[indexPath.row];
    DAlbumViewController *VC = [[DAlbumViewController alloc] init];
    VC.model=model;
    //[self presentViewController:VC animated:YES completion:nil];
   // [self.navigationController pushViewController:VC animated:YES];
    
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
