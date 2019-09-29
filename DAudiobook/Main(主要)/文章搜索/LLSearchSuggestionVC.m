//
//  LLSearchSuggestionVC.m
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//
#import "DTitleTableViewCell.h"
#import "LLSearchSuggestionVC.h"

@interface LLSearchSuggestionVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, copy)   NSString *searchTest;

@end

@implementation LLSearchSuggestionVC

- (UITableView *)contentView
{
    if (!_contentView) {
        self.contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
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
    [super viewDidLoad];
    [self.view addSubview:self.contentView];
    [self.contentView registerClass:[DTitleTableViewCell class] forCellReuseIdentifier:@"DTitleTableViewCell"];
}

- (void)searchTestChangeWithTest:(NSString *)test
{
    _searchTest = test;
    [_contentView reloadData];
}


#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_searchTest.length > 0) ? (10 / _searchTest.length) : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DTitleTableViewCell";
    //DTitleTableViewCell*cell=[UITableViewCell initw];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%@编号%ld", _searchTest, indexPath.row];
     DTitleTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    return cell;
}


#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchBlock) {
        self.searchBlock([NSString stringWithFormat:@"%@编号%ld", _searchTest, indexPath.row]);
    }
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
