//
//  LLSearchSuggestionVC.m
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//
#import "DTitleTableViewCell.h"
#import "LLSearchSuggestionVC.h"
#import "DSearchLogic.h"
#import "PSArticleDetailModel.h"
#import "PSDetailArticleViewController.h"
#import "PSArticleDDetailViewModel.h"
@interface LLSearchSuggestionVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, copy)   NSString *searchString;
@property (nonatomic , strong) DSearchLogic *logic;
@end

@implementation LLSearchSuggestionVC

- (UITableView *)contentView
{
    if (!_contentView) {
        self.contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.tableFooterView = [UIView new];
       
        _contentView.separatorStyle=UITableViewCellAccessoryNone;
    }
    return _contentView;
}


- (void)viewDidLoad
{
    _logic=[[DSearchLogic alloc]init];
    [super viewDidLoad];
    [self.view addSubview:self.contentView];
    [self.contentView registerClass:[DTitleTableViewCell class] forCellReuseIdentifier:@"DTitleTableViewCell"];
}

- (void)searchTestChangeWithTest:(NSString *)test
{
    _searchString = test;
    _logic.title=test;
    [self refreshData];
    //[_contentView reloadData];
}


-(void)refreshData{
    [[PSLoadingView sharedInstance]show];
    [_logic refreshArticlesCompleted:^(id data) {
        [[PSLoadingView sharedInstance]dismiss];
        [_contentView reloadData];
        [self.view endEditing:YES];
    } failed:^(NSError *error) {
        [[PSLoadingView sharedInstance]dismiss];
    }];
}



#pragma mark - UITableViewDataSource -



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;//最小数，相当于0
    }
    else if(section == 1){
        return CGFLOAT_MIN;//最小数，相当于0
    }
    return 0;//机器不可识别，然后自动返回默认高度
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*headView=[UIView new];
    headView.frame=CGRectMake(20, 5, SCREEN_WIDTH-40, 44);
    //headView.backgroundColor=[UIColor grayColor];
    
    UILabel*countLable=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 14)];
    countLable.text=NSStringFormat(@"搜索到%ld条结果",_logic.Articles.count);
    countLable.font=FontOfSize(12);
    countLable.textColor=AppColor(102, 102, 102);
    [headView addSubview:countLable];
    
    UILabel*titleLable=[[UILabel alloc]initWithFrame:CGRectMake(20, 30, 200, 15)];
    titleLable.text=@"相关文章";
    titleLable.textColor=[UIColor blackColor];
    titleLable.font=FontOfSize(15);
    [headView addSubview:titleLable];
    
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _logic.Articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DTitleTableViewCell";

    PSArticleDetailModel*model=_logic.Articles[indexPath.row];
     DTitleTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
   
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:model.title];
    NSRange range = [model.title rangeOfString:_searchString];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor],   NSFontAttributeName : [UIFont systemFontOfSize:15]} range:range];
     cell.titleLable.attributedText=attrituteString;
    [cell.dataButton setTitle:NSStringFormat(@" %@",model.publishAt) forState:UIControlStateNormal];
    [cell.hotButton setTitle:NSStringFormat(@" %@",model.praiseNum) forState:UIControlStateNormal];
    cell.nameLable.text=model.penName;
    return cell;
}


#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      PSArticleDetailModel*model=_logic.Articles[indexPath.row];
    if (self.searchBlock) {
        self.searchBlock(_searchString);
    }
    
    PSArticleDDetailViewModel *viewModel = [PSArticleDDetailViewModel new];
    viewModel.id = model.id;
    PSDetailArticleViewController *DetailArticleVC = [[PSDetailArticleViewController alloc] init];
    DetailArticleVC.viewModel = viewModel;
    [self.navigationController pushViewController:DetailArticleVC animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
