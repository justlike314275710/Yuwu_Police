//
//  DForgetPWNextViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/18.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DForgetPWNextViewController.h"
#import "DPasswordLogic.h"

@interface DForgetPWNextViewController ()
@property (nonatomic , strong) UITextField *passwordTextfield;
@end

@implementation DForgetPWNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置密码";
    [self renderContents];
    [self addBackItem];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)renderContents{
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    CGFloat horizontalSpace = 15.0f;
    CGFloat topSpace = 5.0f;
    UILabel*tipsLabel=[UILabel new];
    [self.view addSubview:tipsLabel];
    tipsLabel.font=FontOfSize(12);
    tipsLabel.textColor=AppBaseTextColor1;
    tipsLabel.text=@"设置密码后，你可以通过手机号和密码登录狱务通。";
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topSpace);
        make.left.mas_equalTo(horizontalSpace);
        make.right.mas_equalTo(-horizontalSpace);
        make.height.mas_equalTo(20);
    }];
    
    UIView*bgView=[UIView new];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipsLabel.mas_bottom).offset(horizontalSpace);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    
    self.passwordTextfield=[UITextField new];
    [bgView addSubview:self.passwordTextfield];
    self.passwordTextfield.placeholder=@"8-16位，至少含数字/字母/字符2种组合";
    self.passwordTextfield.font=FontOfSize(12);
    [self.passwordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipsLabel.mas_bottom).offset(horizontalSpace);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
    }];
    self.passwordTextfield.secureTextEntry=YES;
    
    UIButton*showPasswordButton=[UIButton new];

    
    
    [showPasswordButton setImage:IMAGE_NAMED(@"显示密码icon") forState:UIControlStateSelected];
    [showPasswordButton setImage:IMAGE_NAMED(@"不显示密码icon") forState:UIControlStateNormal ];
    
    [showPasswordButton be_setEnlargeEdgeWithTop:5 right:15 bottom:5 left:15];
    [bgView addSubview:showPasswordButton];
    [showPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextfield.top).offset(horizontalSpace);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(16);
    }];
    [showPasswordButton addTarget:self action:@selector(showPassBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton*passwordButton=[UIButton new];
    ViewRadius(passwordButton, 22);
    [passwordButton setTitle:@"确定" forState:0];
    [passwordButton setTitleColor:[UIColor whiteColor] forState:0];
    passwordButton.titleLabel.font=FontOfSize(14);
    [passwordButton setBackgroundImage:[UIImage imageNamed:@"提交按钮底框"] forState:UIControlStateNormal];
    [self.view addSubview:passwordButton];
    [passwordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextfield.mas_bottom).offset(horizontalSpace);
        make.left.mas_equalTo(horizontalSpace);
        make.right.mas_equalTo(-horizontalSpace);
        make.height.mas_equalTo(44);
    }];
    [passwordButton addTarget:self action:@selector(passwordButtonClicked) forControlEvents:UIControlEventTouchUpInside];

}

- (void)passwordButtonClicked {
    DPasswordLogic*logic=[[DPasswordLogic alloc]init];
    logic.phone_newPassword=self.passwordTextfield.text;
    logic.VerificationCode=self.VerificationCod;
    [logic checkNewPhoneDataWithCallback:^(BOOL successful, NSString *tips) {
        if (successful) {
            [logic requestByVerficationCodeCompleted:^(id data) {
                 [PSTipsView showTips:@"密码修改成功!"];
                 [self.navigationController popViewControllerAnimated:YES];
                 [self dismissViewControllerAnimated:NO completion:nil];
            } failed:^(NSError *error) {
                 [PSTipsView showTips:@"密码修改失败!"];
            }];
        } else {
            [PSTipsView showTips:tips];
        }
    }];
}



- (void)showPassBarButtonItemClicked:(UIButton *)sender{
    self.passwordTextfield.secureTextEntry=! self.passwordTextfield.secureTextEntry;
    sender.selected=!sender.selected;
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
