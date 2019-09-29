//
//  DFeedBackDetailViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/27.
//  Copyright © 2019年 liujiliu. All rights reserved.
//
#import "NSString+Date.h"
#import "DFeedBackDetailViewController.h"
#import "DFeedbackListLogic.h"
#import "HUPhotoBrowser.h"
@interface DFeedBackDetailViewController ()
@property(nonatomic, strong)UIView *firstView;
@property(nonatomic, strong)UIView *secondView;
@property(nonatomic, strong)UILabel *titleLab;
@property(nonatomic, strong)UILabel *dateLabl;
@property(nonatomic, strong)UILabel *detailLab;
@property(nonatomic, strong)UILabel *feedbackLab;
@property(nonatomic, strong)UIScrollView *scrollview;

@property(nonatomic, strong)DFeedbackListLogic*logic;
@end

@implementation DFeedBackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _logic=[[DFeedbackListLogic alloc]init];
    [self renderContents];
    [self addBackItem];
    [self refreshData];
    self.title=@"意见详情";
    // Do any additional setup after loading the view.
}

-(void)refreshData{
    _logic.id=self.detailId;
    [[PSLoadingView sharedInstance]show];
    [_logic refreshFeedbackDetaik:^(id data) {
        [self p_freshUI];
        [[PSLoadingView sharedInstance]dismiss];
    } failed:^(NSError *error) {
        [[PSLoadingView sharedInstance]dismiss];
    }];
   
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


- (void)p_freshUI {
    

    FeedbackTypeModel *model = _logic.detailModel;
    //title
    NSString *title = model.desc.length>0?[NSString stringWithFormat:@"%@: %@",model.typeName,model.desc]:model.typeName;
    self.titleLab.text = title;
  self.detailLab.text = model.content;
   
    CGRect rect = [self.detailLab.text boundingRectWithSize:CGSizeMake(self.detailLab.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.detailLab.font} context:nil];
    int detailLab_H = rect.size.height>35?rect.size.height+10:35;
    self.detailLab.frame = CGRectMake(self.detailLab.frame.origin.x, self.detailLab.frame.origin.y,self.detailLab.width, detailLab_H);
    
    NSString*repalyTime=[model.createdAt timestampToDateDetailString];
    self.dateLabl.text = repalyTime;
    
    int firstView_h = self.titleLab.height + self.dateLabl.height + 5 +self.detailLab.height;
    
    NSMutableArray *imagesicon = [NSMutableArray array];
    NSArray *imageUrls = [NSArray array];
    int width = (SCREEN_WIDTH-40)/2;
    
    if (model.imageUrls.length > 0) {
        if ([model.imageUrls hasSuffix:@";"]) {
            model.imageUrls = [model.imageUrls substringToIndex:model.imageUrls.length-1];
        }
        imageUrls = [model.imageUrls componentsSeparatedByString:@";"];
        if (imageUrls.count<3) {
            firstView_h = firstView_h + (width+10)*1+10;
        } else {
            firstView_h = firstView_h + (width+10)*2+10;
        }
    } else {
        firstView_h = firstView_h+10;
    }
    self.firstView.frame = CGRectMake(self.firstView.frame.origin.x, self.firstView.frame.origin.y,self.firstView.width, firstView_h);
    for (int i = 0; i<imageUrls.count; i++) {
        int x = i%2;
        int y = i/2;
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15+x*(width+10),self.detailLab.bottom+5+(width+10)*y, width, width)];
        NSString *url = imageUrls[i];
        NSString*imageUrl=[NSString stringWithFormat:@"%@/files/%@",EmallHostUrl,url];
//        [imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:ImageNamed(@"意见反馈")];
        [imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (imageV.image) [imagesicon addObject:imageV.image];
        }];
        imageV.tag = i+100;
        imageV.userInteractionEnabled = YES;
        [imageV bk_whenTapped:^{
            [HUPhotoBrowser showFromImageView:imageV withImages:imagesicon atIndex:i];
        }];
        [self.firstView addSubview:imageV];
    }
    if (model.reply.length>0) {
        
        NSString *feedback = NSLocalizedString(@"Feedback reply", @"反馈回复");
        NSString *feedanswer = [NSString stringWithFormat:@"%@: %@",feedback,model.reply];
        self.feedbackLab.text = feedanswer;
        CGRect rect = [self.feedbackLab.text boundingRectWithSize:CGSizeMake(self.feedbackLab.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.feedbackLab.font} context:nil];
        int detailLab_H = rect.size.height>35?rect.size.height:35;
        self.feedbackLab.frame = CGRectMake(self.feedbackLab.frame.origin.x, self.feedbackLab.frame.origin.y,self.feedbackLab.width, detailLab_H);
        int sencond_h = self.feedbackLab.height+30>110?self.feedbackLab.height+30:110;
        self.secondView.frame = CGRectMake(0, self.firstView.bottom+15, self.secondView.width,sencond_h);
    } else {
        self.secondView.hidden = YES;
    }
    _scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, self.firstView.height+self.secondView.height+120);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Setting&&Getting
- (UIScrollView *)scrollview {
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT)];
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
