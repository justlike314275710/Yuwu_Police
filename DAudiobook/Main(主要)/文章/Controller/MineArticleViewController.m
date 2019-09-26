//
//  MineArticleViewController.m
//  PrisonService
//
//  Created by kky on 2019/8/2.
//  Copyright © 2019年 calvin. All rights reserved.
//

#import "MineArticleViewController.h"
#import "PSPlatformArticleCell.h"
#import "PSMyTotalArtcleListViewModel.h"
#import "PSPlatformHeadView.h"
#import "PSArticleStateViewController.h"
#import "PSArticleStateViewModel.h"
#import "PSArticleDetailViewModel.h"
#import "PSDetailArticleViewController.h"

@interface MineArticleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MineArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的文章";
    self.view.backgroundColor = [UIColor clearColor];
    [self setupUI];
    [self refreshData];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:KNotificationRefreshMyArticle object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - PrivateMethods
- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[PSPlatformArticleCell class] forCellReuseIdentifier:@"PSPlatformArticleCell"];
    self.tableView.tableFooterView = [UIView new];
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self refreshData];
    }];
    
}

- (void)loadMore {
    /*
    @weakify(self)
    [self.viewModel loadMoreMessagesCompleted:^(PSResponse *response) {
        @strongify(self)
        [self reloadContents];
    } failed:^(NSError *error) {
        @strongify(self)
        [self reloadContents];
    }];
     */
}

- (void)refreshData {
    /*
    PSMyTotalArtcleListViewModel *messageViewModel = (PSMyTotalArtcleListViewModel *)self.viewModel;
    [[PSLoadingView sharedInstance] show];
    @weakify(self)
    [messageViewModel refreshMessagesCompleted:^(PSResponse *response) {
        @strongify(self)
        [[PSLoadingView sharedInstance] dismiss];
        [self reloadContents];
    } failed:^(NSError *error) {
        @strongify(self)
        [[PSLoadingView sharedInstance] dismiss];
        [self reloadContents];
    }];
     */
}

- (void)reloadContents {
    PSMyTotalArtcleListViewModel *messageViewModel = (PSMyTotalArtcleListViewModel *)self.viewModel;
    if (messageViewModel.hasNextPage) {
        @weakify(self)
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self loadMore];
        }];
    }else{
        self.tableView.mj_footer = nil;
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - Setting&&Getting
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.view.width,kScreenHeight-164) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(249,248,254);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    PSMyTotalArtcleListViewModel *messageViewModel = (PSMyTotalArtcleListViewModel *)self.viewModel;
    return [messageViewModel.articles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PSMyTotalArtcleListViewModel *messageViewModel = (PSMyTotalArtcleListViewModel *)self.viewModel;
    NSArray *models = [messageViewModel.articles objectAtIndex:section];
    return models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSPlatformArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PSPlatformArticleCell"];
    PSMyTotalArtcleListViewModel *messageViewModel = (PSMyTotalArtcleListViewModel *)self.viewModel;
    NSArray *models = [messageViewModel.articles objectAtIndex:indexPath.section];
    cell.model = [models objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PSMyTotalArtcleListViewModel *messageViewModel = (PSMyTotalArtcleListViewModel *)self.viewModel;
    NSArray *models = [messageViewModel.articles objectAtIndex:indexPath.section];
    PSArticleDetailModel*model = [models objectAtIndex:indexPath.row];
    
    PSArticleDetailViewModel *viewModel = [PSArticleDetailViewModel new];
    viewModel.id = model.id;
    PSDetailArticleViewController *DetailArticleVC = [[PSDetailArticleViewController alloc] init];    //点赞回调刷新
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
//        KPostNotification(KNotificationRefreshInteractiveArticle, nil);
//        KPostNotification(KNotificationRefreshCollectArticle, nil);
    };
    
    //热度刷新
    DetailArticleVC.hotChangeBlock = ^(NSString *clientNum) {
        model.clientNum = clientNum;
        //刷新
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//        KPostNotification(KNotificationRefreshInteractiveArticle, nil);
//        KPostNotification(KNotificationRefreshCollectArticle, nil);
    };
    [self.navigationController pushViewController:DetailArticleVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 175;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    PSMyTotalArtcleListViewModel *messageViewModel = (PSMyTotalArtcleListViewModel *)self.viewModel;
    NSArray *models = [messageViewModel.articles objectAtIndex:section];
    PSArticleDetailModel *model = [models objectAtIndex:0];
    PSArticleStateViewModel *viewModel = [PSArticleStateViewModel new];
    NSString *title = @"";
    if ([model.status isEqualToString:@"pass"]) {
        title = @"已发布";
        viewModel.status = @"published";
    } else if ([model.status isEqualToString:@"publish"]||[model.status isEqualToString:@"shelf"]) {
        title = @"未发布";
        viewModel.status = @"not-published";
    } else if([model.status isEqualToString:@"reject"]) {
        title = @"未通过";
        viewModel.status = @"not-pass";
    }
    
    PSPlatformHeadView *headView = [[[PSPlatformHeadView alloc] init] initWithFrame:CGRectMake(0, 0, kScreenWidth,40) title:title];
    headView.block = ^(NSString * _Nonnull title) {
        PSArticleStateViewController *ArticleStateVC = [[PSArticleStateViewController alloc] init];
        [self.navigationController pushViewController:ArticleStateVC  animated:YES];
    };
    return headView;
}





@end
