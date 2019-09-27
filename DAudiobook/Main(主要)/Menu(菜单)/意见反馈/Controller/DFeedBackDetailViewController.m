//
//  DFeedBackDetailViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/27.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DFeedBackDetailViewController.h"
#import "DFeedbackListLogic.h"
@interface DFeedBackDetailViewController ()
@property(nonatomic, strong)UIView *firstView;
@property(nonatomic, strong)UIView *secondView;
@property(nonatomic, strong)UILabel *titleLab;
@property(nonatomic, strong)UILabel *dateLabl;
@property(nonatomic, strong)UILabel *detailLab;
@property(nonatomic, strong)UILabel *feedbackLab;
@property(nonatomic, strong)UIScrollView *scrollview;
@end

@implementation DFeedBackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self renderContents];
    [self refreshData];
    // Do any additional setup after loading the view.
}

-(void)refreshData{
    DFeedbackListLogic*logic=[[DFeedbackListLogic alloc]init];
   
}


- (void)renderContents {
    [self.view addSubview:self.scrollview];
    [self.scrollview addSubview:self.firstView];
    [self.firstView addSubview:self.titleLab];
    [self.firstView addSubview:self.dateLabl];
    [self.firstView addSubview:self.detailLab];
    [self.scrollview addSubview:self.secondView];
    [self.secondView addSubview:self.feedbackLab];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Setting&&Getting
- (UIScrollView *)scrollview {
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        _scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _scrollview;
}

-(UIView *)firstView {
    if (!_firstView) {
        _firstView = [[UIView alloc] init];
        _firstView.frame = CGRectMake(0,20,SCREEN_WIDTH,500);
        _firstView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _firstView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        _firstView.layer.shadowOffset = CGSizeMake(0,3);
        _firstView.layer.shadowOpacity = 1;
        _firstView.layer.shadowRadius = 4;
    }
    return _firstView;
}
-(UIView *)secondView {
    if (!_secondView) {
        _secondView = [[UIView alloc] init];
        _secondView.frame = CGRectMake(0,self.firstView.bottom+15,SCREEN_WIDTH,110);
        _secondView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _secondView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        _secondView.layer.shadowOffset = CGSizeMake(0,3);
        _secondView.layer.shadowOpacity = 1;
        _secondView.layer.shadowRadius = 4;
    }
    return _secondView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15,0, 300, 35)];
        _titleLab.text = @"功能异常：功能故障或不可使用";
        _titleLab.textColor = UIColorFromRGB(0, 0, 0);
        _titleLab.font = FontOfSize(14);
        _titleLab.numberOfLines = 0;
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

- (UILabel *)dateLabl {
    if (!_dateLabl) {
        _dateLabl = [[UILabel alloc] initWithFrame:CGRectMake(15,self.titleLab.bottom,300,20)];
        _dateLabl.text = @"2018-11-12 09:30:22";
        _dateLabl.textColor = UIColorFromRGB(153,153,153);
        _dateLabl.font = FontOfSize(10);
        _dateLabl.numberOfLines = 0;
        _dateLabl.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLabl;
}

- (UILabel *)detailLab {
    if (!_detailLab) {
        _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(15,self.dateLabl.bottom+5,SCREEN_WIDTH-30, 35)];
        _detailLab.text = @"为什么我申请了好几次，总是申请不成功？我的信息没有填写 错误，到底是哪里出了问题？";
        _detailLab.textColor = UIColorFromRGB(102,102,102);
        _detailLab.font = FontOfSize(12);
        _detailLab.numberOfLines = 0;
        _detailLab.textAlignment = NSTextAlignmentLeft;
    }
    return _detailLab;
}

- (UILabel *)feedbackLab {
    if (!_feedbackLab) {
        _feedbackLab = [[UILabel alloc] initWithFrame:CGRectMake(15,8,SCREEN_WIDTH-30, 35)];
        _feedbackLab.text = @"反馈回复";
        _feedbackLab.textColor = UIColorFromRGB(51,51,51);
        _feedbackLab.font = FontOfSize(12);
        _feedbackLab.numberOfLines = 0;
        _feedbackLab.textAlignment = NSTextAlignmentLeft;
    }
    return _feedbackLab;
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
