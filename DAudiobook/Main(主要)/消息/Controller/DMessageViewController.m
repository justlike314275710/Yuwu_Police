//
//  DMessageViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DMessageViewController.h"
#import "DMessageTableViewCell.h"
#import "MessageLogic.h"
#import "DMessageModel.h"
#import "NSString+Date.h"

@interface DMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic , strong) MessageLogic *logic;
@end

@implementation DMessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //状态栏点击
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(coverWindowClick) name:@"statusBarTappedNotification" object:nil];
    //token刷新
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:@"refresh_token"
                                               object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"消息";
    self.logic=[[MessageLogic alloc]init];
    [self addBackItem];
    [self renderContents];
    [self refreshData];
    self.view.backgroundColor=AppColor(255, 255, 255);
    self.messageTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:KNotificationMessageList object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)coverWindowClick {
    if (_logic.messages.count>1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}


- (void)refreshData {
    [[PSLoadingView sharedInstance]show];
    [_logic refreshMessagesCompleted:^(id data) {
        [[PSLoadingView sharedInstance] dismiss];
        [self reloadContents];
    } failed:^(NSError *error) {
        NSString *errorInfo = error.userInfo[@"NSLocalizedDescription"];
        if ([errorInfo isEqualToString:@"Request failed: unauthorized (401)"]) {
            [help_userManager refreshOuathToken];
            [[PSLoadingView sharedInstance] dismiss];
            [self reloadContents];
        }else{
        [[PSLoadingView sharedInstance] dismiss];
        [self reloadContents];
        }
    }];
}

- (void)reloadContents {
    if (_logic.hasNextPage) {
        self.messageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadMore];
        }];
    }else{
        self.messageTableView.mj_footer = nil;
    }
    [self.messageTableView.mj_header endRefreshing];
    [self.messageTableView.mj_footer endRefreshing];
    [self.messageTableView reloadData];
}

- (void)loadMore {
    [_logic loadMoreMessagesCompleted:^(id data) {
         [self reloadContents];
    } failed:^(NSError *error) {
         [self reloadContents];
    }];
}


- (void)renderContents {
    self.messageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.messageTableView.dataSource = self;
    self.messageTableView.delegate = self;
   // self.messageTableView.emptyDataSetSource = self;
    //self.messageTableView.emptyDataSetDelegate = self;
    self.messageTableView.tableFooterView = [UIView new];
    self.messageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    [self.messageTableView registerClass:[DMessageTableViewCell class] forCellReuseIdentifier:@"DMessageTableViewCell"];
    [self.view addSubview:self.messageTableView];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.messageTableView .showsVerticalScrollIndicator =NO;
    self.messageTableView.ly_emptyView=[LYEmptyView emptyViewWithImageStr:@"noData"
                                                                 titleStr:@"暂无数据"
                                                                detailStr:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _logic.messages.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier:@"DMessageTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
//        [self configureCell:cell atIndexPath:indexPath];
//    }];
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     DMessageTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"DMessageTableViewCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureCell:(DMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    DMessageModel *message = _logic.messages[indexPath.row];
    cell.titleLable.text=[message.content substringWithRange:NSMakeRange(1, 4)];
    cell.dataLable.text = [message.createdAt timestampToDateDetailSecondString];
    cell.detailLable.text = [message.content substringFromIndex:6];
    if ([message.isNoticed isEqualToString:@"1"]) {
        cell.titleLable.textColor=AppColor(153, 153, 153);
        cell.dataLable.textColor = AppColor(153, 153, 153);
        cell.detailLable.textColor = AppColor(153, 153, 153);
    } else {
        cell.titleLable.textColor=AppColor(51, 51, 51);
        cell.dataLable.textColor = AppColor(51, 51, 51);
        cell.detailLable.textColor = AppColor(51, 51, 51);
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
