//
//  DForgetPWViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/18.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DForgetPWViewController.h"
#import "RMTimer.h"
#import "LoginLogic.h"
#import "DPasswordLogic.h"
#import "DForgetPWNextViewController.h"
@interface DForgetPWViewController ()
@property (nonatomic , strong) UIButton *codeButton;
@property (nonatomic , strong) UITextField*codeTextField;
@property (nonatomic, assign) NSInteger seconds;
@end

@implementation DForgetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"获取验证码";
    [self renderContents];
    [self addBackItem];
}

-(void)renderContents{
    self.view.backgroundColor=[UIColor colorWithRed:249/255.0 green:248/255.0 blue:254/255.0 alpha:1.0];
    CGFloat horizontalSpace = 15.0f;
    CGFloat topSpace = 64.0f+9.0f;
    NSString*phone=[kUserDefaults objectForKey:@"phone"];
    UILabel*tipsLable=[UILabel new];
    tipsLable.text=[NSString stringWithFormat:@"短信验证码已发送至手机上，手机号为:%@",phone];
    tipsLable.font=FontOfSize(12);
    tipsLable.textColor=AppBaseTextColor1;
    [self.view addSubview:tipsLable];
    [tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topSpace);
        make.left.mas_equalTo(horizontalSpace);
        make.right.mas_equalTo(-horizontalSpace);
        make.height.mas_equalTo(20);
    }];
    
    UIView*bgView=[UIView new];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipsLable.mas_bottom).offset(horizontalSpace);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    UILabel*codeLable=[UILabel new];
    codeLable.text=@"验证码";
    codeLable.font=FontOfSize(12);
    codeLable.textColor=[UIColor blackColor];
    [bgView addSubview:codeLable];
    [codeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_top).offset(horizontalSpace);
        make.left.mas_equalTo(horizontalSpace);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(14);
    }];
    
    
    _codeTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _codeTextField.font = AppBaseTextFont2;
    _codeTextField.textColor = AppBaseTextColor1;
    _codeTextField.textAlignment = NSTextAlignmentLeft;
    _codeTextField.placeholder = @"请输入验证码";
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:_codeTextField];
    [_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(codeLable.mas_right);
        make.right.mas_equalTo(-horizontalSpace);
        make.top.mas_equalTo(bgView.mas_top).offset(horizontalSpace);
        make.height.mas_equalTo(14);
    }];
    
    
    _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeButton.titleLabel.font = AppBaseTextFont2;
    [_codeButton setTitleColor:AppBaseTextColor3 forState:UIControlStateNormal];
    [_codeButton setTitleColor:AppBaseTextColor2 forState:UIControlStateDisabled];
    [_codeButton setTitle:@"|获取验证码" forState:UIControlStateNormal];
    [bgView addSubview:_codeButton];
    [_codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_top).offset(horizontalSpace);
        make.right.mas_equalTo(self.codeTextField.mas_right);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(80);
    }];
    [_codeButton addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
   
    
    UIButton*nextTipButton=[UIButton new];
    [nextTipButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextTipButton setTitleColor:[UIColor whiteColor] forState:0];
    ViewRadius(nextTipButton, 4);
    [nextTipButton setBackgroundColor:AppBaseTextColor3];
    nextTipButton.titleLabel.font=FontOfSize(14);
    [self.view addSubview:nextTipButton];
    [nextTipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).offset(horizontalSpace);
        make.right.mas_equalTo(-horizontalSpace);
        make.left.mas_equalTo(horizontalSpace);
        make.height.mas_equalTo(44);
    }];

    [nextTipButton addTarget:self action:@selector(nextTipItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)nextTipItemClicked{
    DPasswordLogic*logic=[[DPasswordLogic alloc]init];
    logic.VerificationCode=_codeTextField.text;
    if (_codeTextField.text.length==0) {
        [PSTipsView showTips:@"请输入验证码!"];
        return;
    }
    [logic requestCodeVerificationCompleted:^(id data) {
        DForgetPWNextViewController*vc= [[DForgetPWNextViewController alloc]init];
        vc.VerificationCod=self.codeTextField.text;
        [self.navigationController pushViewController:vc animated:YES];
    } failed:^(NSError *error) {
        [PSTipsView showTips:@"验证码输入错误!"];
    }];
}



//MARK:获取验证码
- (void)getCode {
    LoginLogic*logic=[[LoginLogic alloc]init];
    self.codeButton.enabled = NO;
     NSString*phone=[kUserDefaults objectForKey:@"phone"];
    logic.phoneNumber = phone;
    [logic checkDataWithPhoneCallback:^(BOOL successful, NSString *tips) {
        if (successful) {
            [logic getVerificationCodeData:^(id data) {
                [PSTipsView showTips:@"已发送"];
                self.seconds=60;
                [self startTimer];
                
            } failed:^(NSError *error) {
                NSString *message = @"";
                
                NSData*data=
                error.userInfo
                [AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (data) {
                    id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    message = body[@"message"];
                } else {
                    message = @"无法连接到服务器！";
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [PSTipsView showTips:message];
                    self.codeButton.enabled=YES;
                });
                
            }];
        } else {
            self.codeButton.enabled = YES;
            [PSTipsView showTips:tips];
        }
    }];
}


//开启定时器
- (void)startTimer {
    RMTimer *sharedTimer = [RMTimer sharedTimer];
    [sharedTimer resumeTimerWithDuration:self.seconds interval:1 handleBlock:^(NSInteger currentTime) {
        self.codeButton.enabled = NO;
        [self.codeButton setTitle:[NSString stringWithFormat:@"重发(%ld)",(long)currentTime] forState:UIControlStateDisabled];
        [self.codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    } timeOutBlock:^{
        self.codeButton.enabled = YES;
    }];
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
