//
//  LLSearchViewController.m
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//

#import "LLSearchViewController.h"
#import "LLSearchResultViewController.h"
#import "LLSearchSuggestionVC.h"
#import "LLSearchView.h"


@interface LLSearchViewController ()<UISearchBarDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) LLSearchView *searchView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) LLSearchSuggestionVC *searchSuggestVC;

@end

@implementation LLSearchViewController

- (NSMutableArray *)hotArray
{
    if (!_hotArray) {
        self.hotArray = nil;
    }
    return _hotArray;
}

- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KHistorySearchPath];
        if (!_historyArray) {
            self.historyArray = [NSMutableArray array];
        }
    }
    return _historyArray;
}


- (LLSearchView *)searchView
{
    if (!_searchView) {
        self.searchView = [[LLSearchView alloc] initWithFrame:CGRectMake(0, 5, KScreenWidth, KScreenHeight - 10) hotArray:self.hotArray historyArray:self.historyArray];
        __weak LLSearchViewController *weakSelf = self;
        _searchView.tapAction = ^(NSString *str) {
            [weakSelf pushToSearchResultWithSearchStr:str];
        };
    }
    return _searchView;
}


- (LLSearchSuggestionVC *)searchSuggestVC
{
    if (!_searchSuggestVC) {
        self.searchSuggestVC = [[LLSearchSuggestionVC alloc] init];
        _searchSuggestVC.view.frame = CGRectMake(0, 5, KScreenWidth, KScreenHeight - 10);
        _searchSuggestVC.view.hidden = YES;
        __weak LLSearchViewController *weakSelf = self;
        _searchSuggestVC.searchBlock = ^(NSString *searchTest) {
            [weakSelf pushToSearchResultWithSearchStr:searchTest];
        };
    }
    return _searchSuggestVC;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_searchBar.isFirstResponder) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 回收键盘
    [self.searchBar resignFirstResponder];
    _searchSuggestVC.view.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.searchBar.text=@"";
    if (_searchView) {
        [_searchView removeFromSuperview];
        _searchView = nil;
        [self.view addSubview:self.searchView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBarButtonItem];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.searchSuggestVC.view];
    [self addChildViewController:_searchSuggestVC];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard) name:@"hideKeyboard" object:nil];
}

- (void)hideKeyboard {
    [self.searchBar resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}
    
- (void)setBarButtonItem
{
    [self.navigationItem setHidesBackButton:YES];
    // 创建搜索框
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    ViewBorderRadius(titleView, 15, 1, [UIColor whiteColor]);
    titleView.backgroundColor=[UIColor whiteColor];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(titleView.frame) - 15-5, 30)];
    searchBar.placeholder = @"搜索文章|连载书籍";
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    [searchBar setBackgroundColor:[UIColor clearColor]];
   
    
    
    UITextField *searchTextField = [searchBar valueForKey:@"_searchField"];
   // searchTextField.borderStyle=UITextBorderStyleBezel;
    searchTextField.backgroundColor = [UIColor whiteColor];


//     searchTextField.layer.borderWidth = 1 ;
//     searchTextField.layer.borderColor = [UIColor whiteColor].CGColor ;
//     searchTextField.layer.cornerRadius = 18 ;
//     searchTextField.clipsToBounds = YES ;
    
   
    
    //ViewBorderRadius(searchTextField, 15.0f, 5, [UIColor whiteColor]);
    //[searchBar setImage:[UIImage imageNamed:@"sort_magnifier"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    

    
    [searchTextField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];

    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    //修改标题和标题颜色
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setBackgroundColor:[UIColor clearColor]];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [titleView addSubview:searchBar];
    
    self.searchBar = searchBar;
    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = titleView;
    
    [self addRightBarButtonTitleItem:@"取消"];
  //  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(presentVCFirstBackClick:)];
}

- (void)rightItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)presentVCFirstBackClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/** 点击取消 */
- (void)cancelDidClick
{
    //[self.searchBar resignFirstResponder];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}


- (void)pushToSearchResultWithSearchStr:(NSString *)str
{
    self.searchBar.text = str;
    LLSearchResultViewController *searchResultVC = [[LLSearchResultViewController alloc] init];
    searchResultVC.searchStr = str;
    searchResultVC.hotArray = self.hotArray;
    searchResultVC.historyArray = self.historyArray;
    //[self.navigationController pushViewController:searchResultVC animated:YES];
    [self setHistoryArrWithStr:str];
    KPostNotification(@"reloadHistory", nil);
}

- (void)setHistoryArrWithStr:(NSString *)str
{
    for (int i = 0; i < self.historyArray.count; i++) {
        if ([_historyArray[i] isEqualToString:str]) {
            [_historyArray removeObjectAtIndex:i];
            break;
        }
    }
    [_historyArray insertObject:str atIndex:0];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
}


#pragma mark - UISearchBarDelegate -


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self setHistoryArrWithStr:searchBar.text];

    _searchSuggestVC.view.hidden = NO;
    [self.view bringSubviewToFront:_searchSuggestVC.view];
    [self.searchBar resignFirstResponder];
    [_searchSuggestVC searchTestChangeWithTest:searchBar.text];

   
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
  
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text == nil || [searchBar.text length] <= 0) {
        _searchSuggestVC.view.hidden = YES;
        [self.view bringSubviewToFront:_searchView];
    } else {
        //[self setHistoryArrWithStr:searchBar.text];
        _searchSuggestVC.view.hidden = NO;
        [self.view bringSubviewToFront:_searchSuggestVC.view];
        //[self.searchBar resignFirstResponder];
        [_searchSuggestVC searchTestChangeWithTest:searchBar.text];
        
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
