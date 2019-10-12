//
//  DWriteFeedListViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/19.
//  Copyright © 2019年 liujiliu. All rights reserved.
//
#import "DFeedBackDetailViewController.h"
#import "DWriteFeedListViewController.h"
#import "DWriteFeedbackViewController.h"
#import "FeedbackListCell.h"
#import "DFeedbackListLogic.h"
#import "XXEmptyView.h"
@interface DWriteFeedListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableview;
@property (nonatomic , strong) DFeedbackListLogic *logic;
@end

@implementation DWriteFeedListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self p_refreshData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"意见反馈";
    self.logic=[[DFeedbackListLogic alloc]init];
    [self addBackItem];
    [self addRightBarButtonItem:IMAGE_NAMED(@"投诉建议icon")];
    [self renderContents];
    [self p_refreshData];

    // Do any additional setup after loading the view.
}


-(void)renderContents{
    self.view.backgroundColor=UIColorFromRGBA(248, 247, 254, 1);
    [self.view addSubview:self.myTableview];
    [self.myTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(5,0,0,0));
    }];
    [self.myTableview registerClass:[FeedbackListCell class] forCellReuseIdentifier:@"FeedbackListCell"];
   WEAKSELF
    self.myTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf p_refreshData];
    }];
}


- (void)p_refreshData {
    [[PSLoadingView sharedInstance]show];
    [_logic refreshFeedbackListCompleted:^(id data) {
         [[PSLoadingView sharedInstance] dismiss];
        
        switch (_logic.dataStatus) {
            case PSDataEmpty:{
                [XXEmptyView diyEmptyView];}
                 [self p_reloadContents];
                break;
                
            default:{
                  [self p_reloadContents];
            }
                break;
        }
    } failed:^(NSError *error) {
          [[PSLoadingView sharedInstance] dismiss];
          [self p_reloadContents];
    }];
   
}

- (void)p_reloadContents {
  
    if (_logic.hasNextPage) {
        self.myTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self p_loadMore];
        }];
    }else{
        self.myTableview.mj_footer = nil;
    }
    [self.myTableview.mj_header endRefreshing];
    [self.myTableview.mj_footer endRefreshing];
    [self.myTableview reloadData];
}

- (void)p_loadMore {
    [_logic loadMoreFeedbackListCompleted:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self p_reloadContents];
        });
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self p_reloadContents];
        });
    }];
}


#pragma mark - Delegate

//MARK:UITableViewDelegate&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _logic.Recodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedbackListCell *feedbackListCell = [[FeedbackListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FeedbackListCell"];
    FeedbackTypeModel *model = _logic.Recodes[indexPath.row];
    feedbackListCell.model = model;
    return feedbackListCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedbackTypeModel *model = _logic.Recodes[indexPath.row];
    NSArray *imageUrls = [NSArray array];
    if (model.imageUrls.length > 0) {
        imageUrls = [model.imageUrls componentsSeparatedByString:@";"];
    }
    return imageUrls.count>0?190:120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedbackTypeModel *model = _logic.Recodes[indexPath.row];
    DFeedBackDetailViewController*feedbackDetailVC=[[DFeedBackDetailViewController alloc]init];
    feedbackDetailVC.detailId=model.id;
    [self.navigationController pushViewController:feedbackDetailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//意见反馈
- (void)rightItemClick{
    DWriteFeedbackViewController*feedBackViewController=[[DWriteFeedbackViewController alloc]init];
    [self.navigationController pushViewController:feedBackViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Setting&&Getting
- (UITableView *)myTableview {
    if (!_myTableview) {
        _myTableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableview.tableFooterView = [UIView new];
        _myTableview.backgroundColor = [UIColor clearColor];
        _myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableview.dataSource = self;
        _myTableview.delegate = self;
        _myTableview.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                                titleStr:@"暂无数据"
                                                               detailStr:nil];
       // _myTableview.emptyDataSetDelegate=self;
       // _myTableview.emptyDataSetSource=self;
    }
    return _myTableview;
}

@end
