//
//  PSDetailArticleViewController.m
//  PrisonService
//
//  Created by kky on 2019/9/16.
//  Copyright © 2019年 calvin. All rights reserved.
//

#import "PSDetailArticleViewController.h"
#import "PSArticleDetailViewModel.h"
#import "PSPublishArticleViewController.h"
#import "PSPublishArticleViewModel.h"
#import "UIButton+BEEnLargeEdge.h"
//#import "PSAccountViewModel.h"


@interface PSDetailArticleViewController ()
@property(nonatomic,strong)UILabel *topTipLab;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UIImageView *timeImageView;
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)UITextView *contentTextView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIButton *likeBtn; //点赞
@property(nonatomic,strong)UILabel *likeLab; //点赞
@property(nonatomic,strong)UIButton *hotBtn; //热度
@property(nonatomic,strong)UILabel *hotLab;  //热度
@property(nonatomic,strong)UIButton *collectBtn; //收藏
@property(nonatomic,strong)UILabel *collectLab;  //收藏
@property(nonatomic,strong)UIImageView *endIconImageView;
@property(nonatomic,strong)UIScrollView *scrollview;


@end

@implementation PSDetailArticleViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"";
    self.view.backgroundColor=[UIColor whiteColor];
    [self addBackItem];
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - PrivateMethods
-(void)setupUI{
    
    [self.view addSubview:self.topTipLab];
    [self.topTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(kTopHeight);
        make.height.mas_equalTo(42);
    }];
    
    [self.view addSubview:self.scrollview];
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topTipLab.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    [self.scrollview addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(50);
    }];
    //20+50+20+44+30
    [self.scrollview addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLab.mas_left);
        make.height.width.mas_equalTo(44);
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(20);
    }];
    
    [self.scrollview addSubview:self.nameLab];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImageView.mas_right).offset(15);
        make.top.mas_equalTo(_headImageView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(200);
    }];
    
    [self.scrollview addSubview:self.timeImageView];
    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImageView.mas_right).offset(15);
        make.top.mas_equalTo(_nameLab.mas_bottom).offset(11);
        make.width.height.mas_equalTo(10);
    }];
    
    [self.scrollview addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_timeImageView.mas_right).offset(10);
        make.top.mas_equalTo(_timeImageView);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(10);
    }];
    
    [self.scrollview addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLab.mas_bottom).offset(30);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(100);
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.bottomView addSubview:self.likeBtn];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.width.mas_equalTo(20);
        make.left.mas_equalTo(25);
    }];
    
    [self.bottomView addSubview:self.likeLab];
    [self.likeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(35);
        make.left.mas_equalTo(_likeBtn.mas_right).offset(10);
    }];
    
    [self.bottomView addSubview:self.hotBtn];
    [self.hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.width.mas_equalTo(20);
        make.centerX.mas_equalTo(_bottomView.mas_centerX).offset(-45);
    }];
    
    [self.bottomView addSubview:self.hotLab];
    [self.hotLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
        make.left.mas_equalTo(_hotBtn.mas_right).offset(10);
    }];
    
    [self.bottomView addSubview:self.collectBtn];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.width.mas_equalTo(20);
        make.centerX.mas_equalTo(_bottomView.mas_centerX).offset(80);
    }];
    
    [self.bottomView addSubview:self.collectLab];
    [self.collectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
        make.left.mas_equalTo(_collectBtn.mas_right).offset(10);
    }];
    
}


-(void)refreshUI{
    
    PSArticleDetailViewModel *viewModel =  (PSArticleDetailViewModel *)self.viewModel;
     _nameLab.text = viewModel.detailModel.penName;
     _titleLab.text = viewModel.detailModel.title;
     _timeLab.text = viewModel.detailModel.publishAt;
     _contentTextView.text = viewModel.detailModel.content;
    _likeLab.text = [NSString stringWithFormat:@"%@赞",viewModel.detailModel.praiseNum];
    viewModel.detailModel.clientNum = [NSString stringWithFormat:@"%d",[viewModel.detailModel.clientNum intValue]+1];
    _hotLab.text = [NSString stringWithFormat:@"%@热度",viewModel.detailModel.clientNum];
    BOOL isHideBottom = YES;
    if ([viewModel.detailModel.status isEqualToString:@"publish"]) { //已发布待审核
        _topTipLab.text = @"平台正在审核中";
        _topTipLab.hidden = NO;
        isHideBottom = YES;
    } else if ([viewModel.detailModel.status isEqualToString:@"pass"]) { //已通过
        _topTipLab.text = @"";
        _topTipLab.hidden = YES;
        [_topTipLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        isHideBottom = NO;
    } else if ([viewModel.detailModel.status isEqualToString:@"reject"]) { //未通过
        _topTipLab.hidden = NO;
        _topTipLab.text = [NSString stringWithFormat:@"发布未通过,%@",viewModel.detailModel.rejectReason];
        isHideBottom = YES;
//        [self createRightBarButtonItemWithTarget:self action:@selector(editAction) title:@"编辑"];
    } else if ([viewModel.detailModel.status isEqualToString:@"shelf"]) { //已下架
        _topTipLab.hidden = NO;
        _topTipLab.text = [NSString stringWithFormat:@"文章已下架,%@",viewModel.detailModel.shelfReason];
        isHideBottom = NO;
//        [self createRightBarButtonItemWithTarget:self action:@selector(editAction) title:@"编辑"];
    }
    [self setupUIViewHidden:isHideBottom];
    
    //用户头像
//    PSAccountViewModel *accountViewModel = [[PSAccountViewModel alloc] init];
//    [accountViewModel getAvatarImageUserName:viewModel.detailModel.username Completed:^(UIImage *image) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _headImageView.image = image;
//        });
//    } failed:^(NSError *error) {
//
//    }];
    
    
    
    if ([viewModel.detailModel.iscollect isEqualToString:@"0"]) {
        [_collectBtn setImage:IMAGE_NAMED(@"未收藏") forState:UIControlStateNormal];
        [_collectLab setText:@"点击收藏"];
        [_collectLab setTextColor:UIColorFromRGB(102, 102, 102)];
    } else {
        [_collectBtn setImage:IMAGE_NAMED(@"已收藏") forState:UIControlStateNormal];
        [_collectLab setText:@"已收藏"];
        [_collectLab setTextColor:UIColorFromRGB(0, 107, 255)];
    }
    if ([viewModel.detailModel.ispraise isEqualToString:@"0"]) {
        [_likeBtn setImage:IMAGE_NAMED(@"未点赞") forState:UIControlStateNormal];
        [_likeLab setTextColor:UIColorFromRGB(102,102,102)];
    } else {
        [_likeBtn setImage:IMAGE_NAMED(@"已赞icon") forState:UIControlStateNormal];
        [_likeLab setTextColor:UIColorFromRGB(237,63,92)];
    }
    
    if ([viewModel.detailModel.clientNum integerValue]>0) {
        [_hotBtn setImage:IMAGE_NAMED(@"热度icon") forState:UIControlStateNormal];
        [_hotLab setTextColor:UIColorFromRGB(255,134,0)];
    } else {
        [_hotBtn setImage:IMAGE_NAMED(@"热度") forState:UIControlStateNormal];
        [_hotLab setTextColor:UIColorFromRGB(102,102,102)];
    }
    CGFloat bottom = isHideBottom?0:-50;
    [self.scrollview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topTipLab.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(bottom);
    }];
    
    CGFloat height = [viewModel heightForString:_contentTextView.text andWidth:kScreenWidth-48];
    [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(164);
        make.left.mas_equalTo(24);
        make.width.mas_equalTo(kScreenWidth-48);
        make.height.mas_equalTo(height);
    }];
    
    [self.scrollview addSubview:self.endIconImageView];
    [self.endIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentTextView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(57);
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scrollview.contentSize = CGSizeMake(kScreenWidth-48,height+164+50);

    });
}

- (UIColor *)rightItemTitleColor {
   return  UIColorFromRGB(38,76,144);
}

- (void)editAction{
    PSArticleDetailViewModel *detailviewModel =  (PSArticleDetailViewModel *)self.viewModel;
    PSPublishArticleViewModel *viewModel = [[PSPublishArticleViewModel alloc] init];
    viewModel.id = detailviewModel.detailModel.id;
    viewModel.content = detailviewModel.detailModel.content;
    viewModel.title = detailviewModel.detailModel.title;
    viewModel.penName = detailviewModel.detailModel.penName;
    viewModel.type = PSEditArticle;
//    PSPublishArticleViewController *publishArticleVC = [[PSPublishArticleViewController alloc] initWithViewModel:viewModel];
    PSPublishArticleViewController *publishArticleVC = [[PSPublishArticleViewController alloc] init];
    publishArticleVC.viewModel = viewModel;
    
    PushVC(publishArticleVC);
}

- (void)setupUIViewHidden:(BOOL)Hidden{
    self.bottomView.hidden = Hidden;
}

-(void)setupData{
    [[PSLoadingView sharedInstance] show];
    [self.viewModel loadArticleDetailCompleted:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupUI];
            [self refreshUI];
            [[PSLoadingView sharedInstance] dismiss];
        });
    } failed:^(NSError *error) {
        [[PSLoadingView sharedInstance] dismiss];
        
    }];
}
#pragma mark - TouchEvent
//返回刷新热度
- (IBAction)actionOfLeftItem:(id)sender {
    PSArticleDetailViewModel *viewModel =  (PSArticleDetailViewModel *)self.viewModel;
//    [super actionOfLeftItem:sender];
    if (self.hotChangeBlock) {
        self.hotChangeBlock(viewModel.detailModel.clientNum);
    }
}
//收藏
-(void)clickCollectAction:(UIButton *)sender{
    
    PSArticleDetailViewModel *viewModel = (PSArticleDetailViewModel *)self.viewModel;
    if ([viewModel.detailModel.status isEqualToString:@"shelf"]) {
        [PSTipsView showTips:@"已下架文章不支持收藏"];
        return;
    }
    //收藏
    if ([viewModel.detailModel.iscollect isEqualToString:@"0"]) {
        [self collectAction];
    } else { //取消收藏
        [self cancelCollectAction];
    }
}

-(void)clickPraiseAction:(UIButton *)sender{
    PSArticleDetailViewModel *viewModel =  (PSArticleDetailViewModel *)self.viewModel;
    //点赞
    if ([viewModel.detailModel.ispraise isEqualToString:@"0"]) {
        [self praiseAction];
    } else { //取消点赞
        [self cancelPraiseAction];
    }
}

//收藏
-(void)collectAction{
    [self.viewModel collectArticleCompleted:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *msg = data[@"msg"];
            [PSTipsView showTips:msg];
            NSInteger code = [data[@"code"] integerValue];
            if (code == 200){
                [self setupData];
                //刷新收藏列表
//                KPostNotification(KNotificationRefreshCollectArticle, nil);
            }
        });
    } failed:^(NSError *error) {
        [PSTipsView showTips:@"收藏失败"];
    }];
}
//取消收藏
-(void)cancelCollectAction{
    
    [self.viewModel cancelCollectArticleCompleted:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *msg = data[@"msg"];
            NSInteger code = [data[@"code"] integerValue];
            [PSTipsView showTips:msg];
            if (code == 200){
                [self setupData];
                //刷新收藏列表
//                KPostNotification(KNotificationRefreshCollectArticle, nil);
            }
        });
    } failed:^(NSError *error) {
        [PSTipsView showTips:@"取消收藏失败"];
    }];
}

//点赞
-(void)praiseAction{
    PSArticleDetailViewModel *viewModel =  (PSArticleDetailViewModel *)self.viewModel;
    [viewModel praiseArticleCompleted:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *msg = data[@"msg"];
            NSInteger code = [data[@"code"] integerValue];
            [PSTipsView showTips:msg];
            if (code == 200){
                [self setupData];
                //刷新列表
                if (self.praiseBlock) self.praiseBlock(YES, viewModel.id, YES);
            }
        });
    } failed:^(NSError *error) {
        [PSTipsView showTips:@"点赞失败"];
    }];
}
//取消点赞
-(void)cancelPraiseAction{
    PSArticleDetailViewModel *viewModel =  (PSArticleDetailViewModel *)self.viewModel;
    [viewModel deletePraiseArticleCompleted:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *msg = data[@"msg"];
            NSInteger code = data[@"code"];
            [PSTipsView showTips:msg];
            if (code == 200){
                [self setupData];
                //刷新列表
                if (self.praiseBlock) self.praiseBlock(NO, viewModel.id, YES);
            }
        });
    } failed:^(NSError *error) {
        [PSTipsView showTips:@"取消点赞失败"];
    }];
}
//取消收藏
-(void)cancleCollectAction:(UIButton *)sender{
    
    PSArticleDetailViewModel *viewModel =  (PSArticleDetailViewModel *)self.viewModel;
    [viewModel collectArticleCompleted:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *msg = data[@"msg"];
            NSInteger code = [data[@"code"] integerValue];
            [PSTipsView showTips:msg];
            if (code == 200){
                [self setupData];
            }
        });
    } failed:^(NSError *error) {
        [PSTipsView showTips:@"收藏失败"];
    }];
}

#pragma mark - Setting&&Getting
-(UILabel *)topTipLab{
    if (!_topTipLab) {
        _topTipLab = [UILabel new];
        _topTipLab.backgroundColor = UIColorFromRGB(255, 246, 233);
        [_topTipLab setText:@"平台正在审核中"];
        _topTipLab.numberOfLines = 0;
        _topTipLab.font = FontOfSize(11);
        [_topTipLab setTextColor:UIColorFromRGB(182,114,52)];
        _topTipLab.textAlignment = NSTextAlignmentCenter;
        _topTipLab.hidden = YES;
    }
    return _topTipLab;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        [_titleLab setText:@"平台正在审核中"];
        _titleLab.font = boldFontOfSize(20);
        [_titleLab setTextColor:UIColorFromRGB(51,51,51)];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}
-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.image = IMAGE_NAMED(@"作者头像");
        ViewRadius(_headImageView,22);
    }
    return _headImageView;
}
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [UILabel new];
        [_nameLab setText:@"吴青峰"];
        _nameLab.font = boldFontOfSize(14);
        [_nameLab setTextColor:UIColorFromRGB(51,51,51)];
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _nameLab.numberOfLines = 0;
    }
    return _nameLab;
}

-(UIImageView *)timeImageView{
    if (!_timeImageView) {
        _timeImageView = [UIImageView new];
        _timeImageView.image = IMAGE_NAMED(@"时间");
    }
    return _timeImageView;
}

-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        [_timeLab setText:@"2019-07-09 11:11:11"];
        _timeLab.font = FontOfSize(10);
        [_timeLab setTextColor:UIColorFromRGB(153,153,153)];
        _timeLab.textAlignment = NSTextAlignmentLeft;
        _timeLab.numberOfLines = 0;
    }
    return _timeLab;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [UITextView new];
        _contentTextView.text = @"那是在 被人们";
        _contentTextView.editable = NO;
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 20;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        _contentTextView.typingAttributes = attributes;
        _contentTextView.textContainerInset = UIEdgeInsetsZero;
        _contentTextView.textContainer.lineFragmentPadding = 0;
        _contentTextView.scrollEnabled = NO;
    }
    return _contentTextView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton*)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:IMAGE_NAMED(@"未点赞") forState:UIControlStateNormal];
        [_likeBtn addTarget:self action:@selector(clickPraiseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_likeBtn be_setEnlargeEdge:10];
    }
    return _likeBtn;
}

-(UILabel *)likeLab{
    if (!_likeLab) {
        _likeLab = [UILabel new];
        [_likeLab setText:@"0赞"];
        _likeLab.font = FontOfSize(12);
        [_likeLab setTextColor:UIColorFromRGB(102,102,102)];
        _likeLab.textAlignment = NSTextAlignmentLeft;
    }
    return _likeLab;
}

- (UIButton*)hotBtn {
    if (!_hotBtn) {
        _hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hotBtn setImage:IMAGE_NAMED(@"热度icon") forState:UIControlStateNormal];
        _hotBtn.enabled = NO;
    }
    return _hotBtn;
}

-(UILabel *)hotLab{
    if (!_hotLab) {
        _hotLab = [UILabel new];
        [_hotLab setText:@""];
        _hotLab.font = FontOfSize(12);
        [_hotLab setTextColor:UIColorFromRGB(102,102,102)];
        _hotLab.textAlignment = NSTextAlignmentLeft;
    }
    return _hotLab;
}

- (UIButton*)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setImage:IMAGE_NAMED(@"已收藏") forState:UIControlStateNormal];
        [_collectBtn addTarget:self action:@selector(clickCollectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_collectBtn be_setEnlargeEdge:10];
    }
    return _collectBtn;
}

-(UILabel *)collectLab{
    if (!_collectLab) {
        _collectLab = [UILabel new];
        [_collectLab setText:@"点击收藏"];
        _collectLab.font = FontOfSize(12);
        [_collectLab setTextColor:UIColorFromRGB(102,102,102)];
        _collectLab.textAlignment = NSTextAlignmentLeft;
    }
    return _collectLab;
}

-(UIScrollView *)scrollview {
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] init];
    }
    return _scrollview;
}
-(UIImageView *)endIconImageView {
    if (!_endIconImageView) {
        _endIconImageView = [UIImageView new];
        _endIconImageView.image = IMAGE_NAMED(@"end");
    }
    return _endIconImageView;
}





@end
