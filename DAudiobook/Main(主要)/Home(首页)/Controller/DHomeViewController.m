//
//  DHomeViewController.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/9.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DHomeViewController.h"
#import "DRadioListCell.h"
#import "DRadioModel.h"
#import "DAlbumViewController.h"
#import "DMessageViewController.h"

@interface DHotNovelViewController() {
    
}
@property (nonatomic,strong) UIButton *publishBtn;

@end

#pragma mark - 热门小说
@implementation DHotNovelViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self GDTadvertising];
    [self SearchBar];
    
    [self setupUI];
    
    [self initializeRefresh];
    
    [self onHeaderRefreshing];
    
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)rightBarItemPress{
    DMessageViewController*vc=[[DMessageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma - PrivateMethods
-(void)setupUI{
    [self.view addSubview:self.publishBtn];
}

#pragma - TouchEvent
//MARK:发布
-(void)publishAction:(UIButton *)sender{
    
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

#pragma mark - 共享方法
//数据处理
-(void)dataProcessingIsRemove:(BOOL)isRemove input:(id)input{
    if (isRemove) {
        [self.listArray removeAllObjects];
    }
    [self.listArray addObjectsFromArray:[DRadioModel mj_objectArrayWithKeyValuesArray:input]];
    [self.tableView  reloadData];
    
}
//获取参数
-(NSMutableDictionary *)getJSON{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[self.pageModel pageOutput]];
    [dic setObject:@"1" forKey:@"type"];
    return dic;
}
//获取URL
-(NSString *)getURL{
    return HotNovelUrl;
}
//获取title
-(NSString *)getMenuTitle{
    return @"热门";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DRadioListCell *cell = [DRadioListCell cellWithTableView:tableView];
    DRadioModel *model = self.listArray[indexPath.row];
    [cell setData:model];
    return cell;
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


