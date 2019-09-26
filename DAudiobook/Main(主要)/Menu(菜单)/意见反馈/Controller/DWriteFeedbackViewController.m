//
//  DWriteFeedbackViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/20.
//  Copyright © 2019年 liujiliu. All rights reserved.
//
#define     IS_IPHONEX              ([UIScreen mainScreen].bounds.size.width == 375.0f && [UIScreen mainScreen].bounds.size.height == 812.0f)

#import "DWriteFeedbackViewController.h"
#import "UITextView+Placeholder.h"
#import "FeedbackCell.h"
#import "FeedloadImgView.h"
#import "DFeedBackLogic.h"
#import "NSString+emoji.h"
#import "FeedbackTypeModel.h"
#import "DWriteSucessViewController.h"

@interface DWriteFeedbackViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextView  *contentTextView;
@property (nonatomic, strong) UILabel *countLab; //字数
@property (nonatomic, assign) NSInteger selecldIndex;
@property (nonatomic, strong) NSMutableArray *imageUrls;
@property (nonatomic, assign) BOOL feedbackSucess;
@property (nonatomic , strong) DFeedBackLogic *logic;
@end

@implementation DWriteFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"意见反馈";
    [self addBackItem];
    _logic=[[DFeedBackLogic alloc]init];
    _logic.writefeedType=PSWritefeedBack;
    self.selecldIndex = 0;
    self.feedbackSucess = NO; //默认没有反馈
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self renderContents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitContent {
    if (self.imageUrls.count>0) {
        NSString *imageUrl = @"";
        for (NSString *url in self.imageUrls) {
            imageUrl = [NSString stringWithFormat:@"%@;%@",imageUrl,url];
        }
        if ([imageUrl hasPrefix:@";"]) {
            imageUrl = [imageUrl substringFromIndex:1];
        }
        _logic.imageUrls = imageUrl;
        NSLog(@"%@",imageUrl);
    } else {
        _logic.imageUrls = @"";
    }
   
    [_logic checkDataWithCallback:^(BOOL successful, NSString *tips) {
        if (successful) {
            [self sendFeedback];
        }else{
            [PSTipsView showTips:tips];
        }
    }];
}


- (void)sendFeedback {
    NSInteger reason=self.selecldIndex+1;
    _logic.type=NSStringFormat(@"%ld",(long)reason);
    [_logic sendFeedbackCompleted:^(id data) {
        if (data[@"code"]) {
             self.feedbackSucess = YES; //反馈成功
            [self.navigationController pushViewController:[[DWriteSucessViewController alloc]init] animated:YES];
        } else {
            [PSTipsView showTips:@"提交失败!"];
        }
    } failed:^(NSError *error) {
        [PSTipsView showTips:@"服务器异常!"];
    }];
    
}




- (void)renderContents {
    [self.view addSubview:self.scrollview];
    self.view.backgroundColor = AppBaseBackgroundColor2;
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(15,15 ,SCREEN_WIDTH-30,210)];
    oneView.backgroundColor = [UIColor clearColor];
    oneView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    oneView.layer.shadowOffset = CGSizeMake(0,3);
    oneView.layer.shadowOpacity = 1;
    oneView.layer.shadowRadius = 4;
    [self.scrollview addSubview:oneView];
    [oneView addSubview:self.tableview];
    
    
    UIView *secondeView = [[UIView alloc] initWithFrame:CGRectMake(15,oneView.bottom+18,self.scrollview.width-30, 170)];
    secondeView.backgroundColor = [UIColor whiteColor];
    secondeView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    secondeView.layer.shadowOffset = CGSizeMake(0,3);
    secondeView.layer.shadowOpacity = 1;
    secondeView.layer.shadowRadius = 4;
    
    
    UIView*secondeLineView=[[UIView alloc]initWithFrame:CGRectMake(0, 8+8, 5, 15)];
    secondeLineView.backgroundColor=AppColor(255, 162, 71);
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(18,8,secondeView.width-48, 30)];
    NSString *titleStr = @"请补充详细问题和意见";
    titleLab.text = titleStr;
    titleLab.numberOfLines = 0;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.textColor =[UIColor blackColor];
    titleLab.font = FontOfSize(14);
    [secondeView addSubview:titleLab];
    [secondeView addSubview:secondeLineView];
  
    self.contentTextView = [[UITextView alloc] init];
     NSString *less_msg = @"  请输入不少于10个字的描述";
    self.contentTextView.placeholder = less_msg;
    self.contentTextView.delegate = self;
    [self.contentTextView setBackgroundColor:AppColor(235, 235, 235)];
    self.contentTextView.frame = CGRectMake(15,titleLab.bottom+8,secondeView.width-30, 110);
    [secondeView addSubview:self.contentTextView];
    
//    self.countLab.frame = CGRectMake(secondeView.width-75,secondeView.height-25, 60, 21);
//    [secondeView addSubview:self.countLab];
    
    UIView *thirdView = [[UIView alloc] initWithFrame:CGRectMake(15, secondeView.bottom+18,self.scrollview.width-30, 130)];
    thirdView.backgroundColor = [UIColor whiteColor];
    thirdView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    thirdView.layer.shadowOffset = CGSizeMake(0,3);
    thirdView.layer.shadowOpacity = 1;
    thirdView.layer.shadowRadius = 4;
    [self.scrollview addSubview:thirdView];
    
    
    
    UIView*thirdLineView=[[UIView alloc]initWithFrame:CGRectMake(0, 8+8, 5, 15)];
    thirdLineView.backgroundColor=AppColor(179, 65, 127);
    
    UILabel *thirdTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(18,8,secondeView.width-48, 30)];
    
    NSString *thirdTitleStr = @"请提供相关问题的截图或照片（最多4张）";
    thirdTitleLab.text = thirdTitleStr;
    thirdTitleLab.numberOfLines = 0;
    thirdTitleLab.textAlignment = NSTextAlignmentLeft;
    thirdTitleLab.textColor =[UIColor blackColor];
    thirdTitleLab.font = FontOfSize(14);
    [thirdView addSubview:thirdTitleLab];
    FeedloadImgView *loadImg = [[FeedloadImgView alloc] initWithFrame:CGRectMake(0,thirdTitleLab.bottom, thirdView.width,100) count:4];
    [thirdView addSubview:loadImg];
    [thirdView addSubview:thirdLineView];
    loadImg.feedloadResultBlock = ^(NSMutableArray *result) {
        self.imageUrls = result;
    };

    
    
    [self.scrollview addSubview:secondeView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame =
    IS_IPHONEX?CGRectMake(15,self.scrollview.bottom+13-44,self.view.width-30, 44)
    :CGRectMake(15,self.scrollview.bottom+13,self.view.width-30, 44);
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius= 4;
    NSString*submit= @"提交";
    [submitBtn setTitle:submit forState:UIControlStateNormal];
    submitBtn.backgroundColor =ImportantColor;
    [self.view addSubview:submitBtn];
    [submitBtn addTarget:self action:@selector(submitContent) forControlEvents:UIControlEventTouchUpInside];

}



#pragma mark - Delegate
#pragma mark  UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    _logic.content=textView.text;
    if ([NSString hasEmoji:textView.text]||[NSString stringContainsEmoji:textView.text]) {
        NSString *msg = @"不能输入表情!";
        [PSTipsView showTips:msg];
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView isFirstResponder]) {
        
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            NSString *msg =@"不能输入表情！";
            [PSTipsView showTips:msg];
            return NO;
        }
       
    }
    return YES;
}

#pragma mark UITableViewDelegate&&UITableViewDatalist
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _logic.reasons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedbackCell *cell = [[FeedbackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FeedbackCell"];
    
    NSString *title = _logic.reasons[indexPath.row];
    cell.titleLab.text = title;
    if (indexPath.row == _logic.reasons.count-1) cell.lineImg.hidden = YES;
    if (self.selecldIndex == indexPath.row) {
        //cell.seleImg.image = [UIImage imageNamed:@"writeFeedsel"];
        cell.bgView.backgroundColor=ImportantColor;
        cell.titleLab.textColor=[UIColor whiteColor];
    } else {
       // cell.seleImg.image = [UIImage imageNamed:@"writeFeednosel"];
        cell.bgView.backgroundColor=AppColor(235, 235, 235);
        cell.titleLab.textColor=AppColor(51, 51, 51);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selecldIndex = indexPath.row;
    [self.tableview reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [UIView new];
    headView.frame = CGRectMake(0, 0,tableView.width, 44);
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, (headView.height-30)/2,headView.width-20, 30)];
    NSString *titleStr =  @"（单选）请选择您想反馈的问题点";
    titleLab.text = titleStr;
    titleLab.font = FontOfSize(14);
    titleLab.numberOfLines = 0;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.textColor =[UIColor blackColor];

    UIView*bgview=[[UIView alloc]initWithFrame:CGRectMake(0, 15, 5, 15)];
    bgview.backgroundColor=AppColor(150, 204, 78);
    
    [headView addSubview:titleLab];
    [headView addSubview:bgview];
    return headView;
}

#pragma mark Setting&&Getting
- (UIScrollView *)scrollview {
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-138)];
        _scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _scrollview;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH-30,210)];
        [_tableview registerClass:[FeedbackCell class] forCellReuseIdentifier:@"FeedbackCell"];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled = NO;
    }
    return _tableview;
}

//- (UITextView *)contentTextView {
//    if (!_contentTextView) {
//        NSString *less_msg = @"  请输入不少于10个字的描述";
//        NSString *more_msg = @"  请输入不多于300个字的描述";
//        _contentTextView = [[UITextView alloc] init];
//       // _contentTextView.placeholder = less_msg;
//        _contentTextView.delegate = self;
//        [_contentTextView setBackgroundColor:AppColor(235, 235, 235)];
//
////        [_contentTextView.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
////            if (x.length>300) {
////                self->_contentTextView.text = [x substringToIndex:299];
////                [PSTipsView showTips:more_msg];
////            }
////            self.countLab.text = [NSString stringWithFormat:@"%lu/300",self->_contentTextView.text.length];
////        }];
//    }
//    return _contentTextView;
//}

- (UILabel *)countLab {
    if (!_countLab) {
        _countLab = [[UILabel alloc] init];
        //_countLab.text = @"0/300";
        _countLab.textColor =AppColor(153, 153, 153);
        _countLab.font = FontOfSize(11);
        _countLab.textAlignment = NSTextAlignmentRight;
    }
    return _countLab;
}

- (NSMutableArray *)imageUrls {
    if (!_imageUrls) {
        _imageUrls = [NSMutableArray array];
    }
    return _imageUrls;
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
