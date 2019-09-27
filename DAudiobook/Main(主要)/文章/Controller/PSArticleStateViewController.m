//
//  PSArticleStateViewController.m
//  PrisonService
//
//  Created by kky on 2019/8/6.
//  Copyright © 2019年 calvin. All rights reserved.
//

#import "PSArticleStateViewController.h"
#import "PSPlatformArticleCell.h"
#import "PSArticleStateViewModel.h"
#import "PSArticleDDetailViewModel.h"
#import "PSDetailArticleViewController.h"

@interface PSArticleStateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation PSArticleStateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏文章";
    self.view.backgroundColor = [UIColor clearColor];
    [self addBackItem];
    [self setupUI];
    [self refreshData];
    self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImage:ImageNamed(@"noData") titleStr:@"暂无数据" detailStr:nil btnTitleStr:@"" btnClickBlock:^{
        [self refreshData];
    }];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}

#pragma mark - PrivateMethods
- (void)setupUI {
    
    NSString *title = @"";
    if ([self.viewModel.status isEqualToString:@"published"]) {
        title = @"我的文章-已发布";
    } else if ([self.viewModel.status isEqualToString:@"not-published"]) {
        title = @"我的文章-未发布";
    } else if([self.viewModel.status isEqualToString:@"not-pass"]) {
        title = @"我的文章-未通过";
    }
    self.title = title;
    
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
     @weakify(self)
    [self.viewModel loadMoreMessagesCompleted:^(id data) {
        @strongify(self)
          [self reloadContents];
    } failed:^(NSError *error) {
        @strongify(self)
         [self reloadContents];
    }];
}

- (void)refreshData {
   
    [[PSLoadingView sharedInstance] show];
    @weakify(self)
    [self.viewModel refreshMessagesCompleted:^(id data) {
        @strongify(self)
        [[PSLoadingView sharedInstance] dismiss];
        [self reloadContents];
    } failed:^(NSError *error) {
        @strongify(self)
        [[PSLoadingView sharedInstance] dismiss];
        [self reloadContents];
    }];
}

- (void)reloadContents {
  
    if (self.viewModel.hasNextPage) {
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,self.view.width,kScreenHeight-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(249,248,254);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSPlatformArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PSPlatformArticleCell"];
    cell.model = [self.viewModel.messages objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PSArticleDetailModel*model = [self.viewModel.messages objectAtIndex:indexPath.row];
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
        if (indexPath.row<self.viewModel.messages.count) {
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
//        KPostNotification(KNotificationRefreshInteractiveArticle, nil);
        KPostNotification(KNotificationHomePageRefreshList, nil);
//        KPostNotification(KNotificationRefreshMyArticle, nil);
        
    };
    
    //热度刷新
    DetailArticleVC.hotChangeBlock = ^(NSString *clientNum) {
        model.clientNum = clientNum;
        //刷新
//        KPostNotification(KNotificationRefreshInteractiveArticle, nil);
        KPostNotification(KNotificationHomePageRefreshList, nil);
//        KPostNotification(KNotificationRefreshMyArticle, nil);
    };
    [self.navigationController pushViewController:DetailArticleVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 175;
}



@end
