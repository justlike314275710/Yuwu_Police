//
//  DResetPasswordViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/18.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DResetPasswordViewController.h"
#import "UIButton+BEEnLargeEdge.h"
#import "DPasswordLogic.h"
#import "DForgetPWViewController.h"
@interface DResetPasswordViewController ()
@property (nonatomic , strong) UITextField *oldPasswordTextfield;
@property (nonatomic , strong) UITextField *novaPasswordTextfield;
@property (nonatomic , strong) UITextField *confirmPasswordTextfield;
@end

@implementation DResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"重置密码";
    [self renderContents];
    [self addBackItem];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)renderContents{
    self.view.backgroundColor=[UIColor colorWithRed:249/255.0 green:248/255.0 blue:254/255.0 alpha:1.0];
    CGFloat topSpace=64.0f+9.0;
    //DT_IS_IPHONEX_XS?64.0f+44.0f:44.0f;
    CGFloat horizontalSpace=15.0f;
    CGFloat defultTag = 999;
    
    
    UIView*bgView=[UIView new];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topSpace);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(132);
    }];
    bgView.userInteractionEnabled=YES;
    
    UILabel*oldLable=[UILabel new];
    [bgView addSubview:oldLable];
    oldLable.text=@"旧密码";
    oldLable.font=FontOfSize(12);
    oldLable.textColor=[UIColor blackColor];
    [oldLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(horizontalSpace);
        make.left.mas_equalTo(horizontalSpace);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(14);
    }];
    
    self.oldPasswordTextfield=[UITextField new];
    [bgView addSubview:self.oldPasswordTextfield];
    self.oldPasswordTextfield.placeholder=@"若包含字母,请注意区别大小写";
    self.oldPasswordTextfield.font=FontOfSize(12);
    [self.oldPasswordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(horizontalSpace);
        make.left.mas_equalTo(oldLable.mas_right).offset(horizontalSpace);
        make.right.mas_equalTo(-horizontalSpace);
        make.height.mas_equalTo(14);
    }];
    self.oldPasswordTextfield.secureTextEntry=YES;
    
    UIButton*oldShowPasswordButton=[UIButton new];
    [oldShowPasswordButton setImage:IMAGE_NAMED(@"显示密码icon") forState:UIControlStateSelected];
    [oldShowPasswordButton setImage:IMAGE_NAMED(@"不显示密码icon") forState: UIControlStateNormal];
    [oldShowPasswordButton be_setEnlargeEdgeWithTop:5 right:15 bottom:5 left:15];
    [bgView addSubview:oldShowPasswordButton];
    [oldShowPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.oldPasswordTextfield.top).offset(horizontalSpace);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(16);
    }];
    oldShowPasswordButton.tag=0+defultTag;
    [oldShowPasswordButton addTarget:self action:@selector(IsShowPasswordItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView*line_one=[UIView new];
    line_one.backgroundColor=AppBaseLineColor;
    [bgView addSubview:line_one];
    [line_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.oldPasswordTextfield.mas_bottom).offset(horizontalSpace);
        make.right.mas_equalTo(-horizontalSpace);
        make.left.mas_equalTo(horizontalSpace);
        make.height.mas_equalTo(1);
    }];
    
    
    
    UILabel*newLable=[UILabel new];
    [bgView addSubview:newLable];
    newLable.text=@"新密码";
    newLable.font=FontOfSize(12);
    newLable.textColor=[UIColor blackColor];
    [newLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_one.mas_bottom).offset(horizontalSpace);
        make.left.mas_equalTo(horizontalSpace);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(14);
    }];
    
    self.novaPasswordTextfield=[UITextField new];
    [bgView addSubview:self.novaPasswordTextfield];
    self.novaPasswordTextfield.placeholder=@"8-16位，至少含数字/字母/字符2种组合";
    self.novaPasswordTextfield.font=FontOfSize(12);
    [self.novaPasswordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_one.mas_bottom).offset(horizontalSpace);
        make.left.mas_equalTo(oldLable.mas_right).offset(horizontalSpace);
        make.right.mas_equalTo(-horizontalSpace);
        make.height.mas_equalTo(14);
    }];
    self.novaPasswordTextfield.secureTextEntry=YES;
    
    UIButton*newShowPasswordButton=[UIButton new];
    [newShowPasswordButton setImage:IMAGE_NAMED(@"显示密码icon") forState:UIControlStateSelected];
    [newShowPasswordButton setImage:IMAGE_NAMED(@"不显示密码icon") forState:UIControlStateNormal];
    [newShowPasswordButton be_setEnlargeEdgeWithTop:5 right:15 bottom:5 left:15];
    
    [bgView addSubview:newShowPasswordButton];
    [newShowPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_one.mas_top).offset(horizontalSpace);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(16);
    }];
    newShowPasswordButton.tag=1+defultTag;
    [newShowPasswordButton addTarget:self action:@selector(IsShowPasswordItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIView*line_two=[UIView new];
    line_two.backgroundColor=AppBaseLineColor;
    [bgView addSubview:line_two];
    [line_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.novaPasswordTextfield.mas_bottom).offset(horizontalSpace);
        make.right.mas_equalTo(-horizontalSpace);
        make.left.mas_equalTo(horizontalSpace);
        make.height.mas_equalTo(1);
    }];
    
    
    
    UILabel*confirmLable=[UILabel new];
    [bgView addSubview:confirmLable];
    confirmLable.text=@"确定密码";
    confirmLable.font=FontOfSize(12);
    confirmLable.textColor=[UIColor blackColor];
    [confirmLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_two.mas_bottom).offset(horizontalSpace);
        make.left.mas_equalTo(horizontalSpace);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(14);
    }];
    
    self.confirmPasswordTextfield=[UITextField new];
    [bgView addSubview:self.confirmPasswordTextfield];
    self.confirmPasswordTextfield.placeholder=@"8-16位，至少含数字/字母/字符2种组合";
    self.confirmPasswordTextfield.font=FontOfSize(12);
    [self.confirmPasswordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_two.mas_bottom).offset(horizontalSpace);
        make.left.mas_equalTo(confirmLable.mas_right).offset(5);
        make.right.mas_equalTo(-horizontalSpace);
        make.height.mas_equalTo(14);
    }];
    self.confirmPasswordTextfield.secureTextEntry=YES;
    
    UIButton*confirmShowPasswordButton=[UIButton new];
    [confirmShowPasswordButton setImage:IMAGE_NAMED(@"显示密码icon") forState:UIControlStateSelected];
    [confirmShowPasswordButton setImage:IMAGE_NAMED(@"不显示密码icon") forState:UIControlStateNormal ];
    [confirmShowPasswordButton be_setEnlargeEdgeWithTop:5 right:15 bottom:5 left:15];
    [bgView addSubview:confirmShowPasswordButton];
    [confirmShowPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_two.mas_top).offset(horizontalSpace);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(16);
    }];
    confirmShowPasswordButton.tag=2+defultTag;
    [confirmShowPasswordButton addTarget:self action:@selector(IsShowPasswordItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton*forgetPasswordButton=[UIButton new];
    [forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPasswordButton setTitleColor:AppBaseTextColor3 forState:0];
    forgetPasswordButton.titleLabel.font=FontOfSize(12);
    [self.view addSubview:forgetPasswordButton];
    [forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).offset(horizontalSpace);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(60);
    }];
    [forgetPasswordButton addTarget:self action:@selector(forgetPasswordItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton*passwordButton=[UIButton new];
    ViewRadius(passwordButton, 4);
    [passwordButton setTitle:@"完成" forState:0];
    [passwordButton setTitleColor:[UIColor whiteColor] forState:0];
    passwordButton.titleLabel.font=FontOfSize(14);
    passwordButton.backgroundColor=ImportantColor;
    [self.view addSubview:passwordButton];
    [passwordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(forgetPasswordButton.mas_bottom)
        .offset(15);
        make.left.mas_equalTo(horizontalSpace);
        make.right.mas_equalTo(-horizontalSpace);
        make.height.mas_equalTo(44);
    }];
    [passwordButton addTarget:self action:@selector(completeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void) IsShowPasswordItemClicked:(UIButton *)sender{
    if (sender.tag==999) {
        self.oldPasswordTextfield.secureTextEntry=!
        self.oldPasswordTextfield.secureTextEntry;
        sender.selected=!sender.selected;
        return;
    }
    if (sender.tag==1000) {
        self.novaPasswordTextfield.secureTextEntry=!
        self.novaPasswordTextfield.secureTextEntry;
        sender.selected=!sender.selected;
        return;
    }
    if (sender.tag==1001) {
        self.confirmPasswordTextfield.secureTextEntry=!
        self.confirmPasswordTextfield.secureTextEntry;
        sender.selected=!sender.selected;
        return;
    }
}

-(void)forgetPasswordItemClicked{
    [self.navigationController pushViewController:[[DForgetPWViewController alloc]init] animated:YES];
    //[self presentViewController:[[DForgetPWViewController alloc]init] animated:YES completion:nil];
    
}

-(void)completeButtonClick{
    DPasswordLogic*logic=[[DPasswordLogic alloc]init];
    logic.phone_oldpassword=self.oldPasswordTextfield.text;
    logic.phone_newPassword=self.novaPasswordTextfield.text;
    logic.determine_password=self.confirmPasswordTextfield.text;
    [logic checkDataWithCallback:^(BOOL successful, NSString *tips) {
        if (successful) {
            [logic requestResetPasswordCompleted:^(id data) {
                 [PSTipsView showTips:@"重置密码成功!"];
                [self dismissViewControllerAnimated:YES completion:nil];
            } failed:^(NSError *error) {
                if ([logic.errorMsg isEqualToString:@"账号密码不匹配"]) {
                    [PSTipsView showTips:@"旧密码输入错误!"];
                } else {
                    [PSTipsView showTips:logic.errorMsg?logic.errorMsg :@"重置密码失败!"];
                }
            }];
        }
        else{
             [PSTipsView showTips:tips];
        }
    }];
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
