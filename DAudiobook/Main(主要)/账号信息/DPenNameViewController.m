//
//  DPenNameViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/25.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DPenNameViewController.h"

@interface DPenNameViewController ()
@property (nonatomic , strong) UITextField *penTextField;
@end

@implementation DPenNameViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"作者笔名";
    [self addBackItem];
    [self renderContents];
   
    UIButton *btnTitle =[[UIButton alloc]initWithFrame:CGRectMake(-30, 10, 30, 14)];
    [btnTitle addTarget:self action:@selector(saveItemClick) forControlEvents:UIControlEventTouchUpInside];
    [btnTitle setTitle:@"保存" forState:UIControlStateNormal];
    btnTitle.titleLabel.font=FontOfSize(13);
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:btnTitle];
    // Do any additional setup after loading the view.
}


//- (void)viewDidDisappear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES];
//}



-(void)saveItemClick{
    [[PSLoadingView sharedInstance]show];
    NSDictionary*param=@{@"penName":self.penTextField.text};
    NSString*url=NSStringFormat(@"%@%@",ServerUrl,URL_Police_updatePenName);
    NSString *access_token = help_userManager.oathInfo.access_token;
    NSString *token = NSStringFormat(@"Bearer %@",access_token);
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper setValue:token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
         [[PSLoadingView sharedInstance]dismiss];
        [PSTipsView showTips:@"修改笔名成功"];
    } failure:^(NSError *error) {
         [[PSLoadingView sharedInstance]dismiss];
        [PSTipsView showTips:@"修改笔名失败"];
    }];
}

- (void)renderContents {
    UIView*bgview=[UIView new];
    bgview.frame=CGRectMake(5, 64+15, SCREEN_WIDTH-10, 44);
    bgview.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    bgview.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:41/255.0 blue:108/255.0 alpha:0.18].CGColor;
    bgview.layer.shadowOffset = CGSizeMake(0,4);
    bgview.layer.shadowOpacity = 1;
    bgview.layer.shadowRadius = 12;
    bgview.layer.cornerRadius = 4;
    [self.view addSubview:bgview];
    
    self.penTextField=[UITextField new];
    self.penTextField.placeholder=@"  请输入作者笔名，不能少于2个字";
    self.penTextField.frame=CGRectMake(5, 0, SCREEN_WIDTH-10, 44);
    [bgview addSubview:self.penTextField];
    self.penTextField.font=FontOfSize(14);
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
