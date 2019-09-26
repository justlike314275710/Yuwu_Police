//
//  DWriteSucessViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DWriteSucessViewController.h"

@interface DWriteSucessViewController ()

@end

@implementation DWriteSucessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.title=@"意见反馈";
     [self p_setUI];
    [self addRightBarButtonTitleItem:@"关闭"];
    // Do any additional setup after loading the view.
}
- (void)rightItemClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)p_setUI {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-156)/2,60+44, 156, 138)];
    imageV.image = [UIImage imageNamed:@"writeFeedscuess"];
    [self.view addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((self.view.width-200)/2,imageV.bottom+30,200,25);
    label.numberOfLines = 0;
    NSString *title = @"反馈成功";
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:19];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =AppColor(38, 76, 144);
    [self.view addSubview:label];
    
    UILabel *msgLab = [[UILabel alloc] init];
    msgLab.frame = CGRectMake((self.view.width-250)/2,label.bottom+5,250,60);
    msgLab.numberOfLines = 0;
    NSString *msg = @"您的反馈我们会认真查看，并尽快修复及完善 感谢您对狱务通一如既往的支持。";
    msgLab.text = msg;
    msgLab.font = FontOfSize(12);
    msgLab.textAlignment = NSTextAlignmentCenter;
    msgLab.textColor = AppColor(102, 102, 102);
    [self.view addSubview:msgLab];
}




- (void)didReceiveMemoryWarning {
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
