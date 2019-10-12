//
//  CollectionArtcleViewController.m
//  PrisonService
//
//  Created by kky on 2019/8/2.
//  Copyright © 2019年 calvin. All rights reserved.
//

#import "CollectionArtcleViewController.h"
#import "PSPlatformArticleCell.h"
#import "PSCollecArtcleListViewModel.h"
#import "PSArticleDDetailViewModel.h"
#import "PSDetailArticleViewController.h"

@interface CollectionArtcleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation CollectionArtcleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏文章";
    self.view.backgroundColor =  UIColorFromRGB(249,248,254);
    [self addBackItem];
    [self setupUI];
    [self refreshData];
    self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImage:ImageNamed(@"noData") titleStr:@"暂无数据" detailStr:nil btnTitleStr:@"" btnClickBlock:^{
        [self refreshData];
    }];
//    收藏列表刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:KNotificationCollectArtickeRefreshList object:nil];
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
//点赞
-(void)praiseActionid:(NSString *)artileid result:(PSPraiseResult)result {
    PSArticleDDetailViewModel *viewModel = [PSArticleDDetailViewModel new];
    viewModel.id = artileid;
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
-(void)deletePraiseActionid:(NSString *)artcleid result:(PSPraiseResult)result {
    PSArticleDDetailViewModel *viewModel = [PSArticleDDetailViewModel new];
    viewModel.id = artcleid;
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
//取消收藏
-(void)deleteCollect:(NSIndexPath *)indexPath model:(PSCollectArticleListModel *)model{
    //刷新
    if (indexPath.row<self.viewModel.messages.count) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Setting&&Getting
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.width,kScreenHeight-Height_NavBar) style:UITableViewStylePlain];
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1,10)];
        _tableView.tableHeaderView = tableHeaderView;
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
    PSCollectArticleListModel *model = [self.viewModel.messages objectAtIndex:indexPath.row];
    cell.collecModel = model;
    @weakify(self);
    //点赞(取消点赞)
    cell.praiseBlock = ^(BOOL action, NSString *id, PSPraiseResult result) {
        @strongify(self);
        if (action) {
            [self praiseActionid:id result:result];
        } else {
            [self deletePraiseActionid:id result:result];
        }
    };
    //取消(收藏)
    cell.deleteCollect = ^(NSString *titleid) {
        @strongify(self);
        model.seleted = !model.seleted;
        [self deleteCollect:indexPath model:model];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 175;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PSCollecArtcleListViewModel *messageViewModel = self.viewModel;
    PSCollectArticleListModel *listmodel = [messageViewModel.messages objectAtIndex:indexPath.row];
    PSArticleDDetailViewModel *viewModel = [PSArticleDDetailViewModel new];
    viewModel.id = listmodel.id;
    PSDetailArticleViewController *DetailArticleVC = [[PSDetailArticleViewController alloc] init];
    DetailArticleVC.viewModel = viewModel;
    //点赞回调刷新
    DetailArticleVC.praiseBlock = ^(BOOL isPraise, NSString *id, BOOL result) {
        if (isPraise) {
            listmodel.praise_num = [NSString stringWithFormat:@"%ld",[listmodel.praise_num integerValue]+1];
            listmodel.is_praise = @"1";
        } else {
            listmodel.praise_num = [NSString stringWithFormat:@"%ld",[listmodel.praise_num integerValue]-1];
            listmodel.is_praise = @"0";
        }
        //刷新
        if (indexPath.row<self.viewModel.messages.count) {
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        KPostNotification(KNotificationHomePageRefreshList, nil);

        
        
    };
    //热度刷新
    DetailArticleVC.hotChangeBlock = ^(NSString *clientNum) {
        listmodel.client_num = clientNum;
        //刷新
        if (indexPath.row<self.viewModel.messages.count) {
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        KPostNotification(KNotificationHomePageRefreshList, nil);
    };
    [self.navigationController pushViewController:DetailArticleVC animated:YES];
}


@end
