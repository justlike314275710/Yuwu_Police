//
//  DModiyPhoneViewcontroller.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/19.
//  Copyright © 2019年 liujiliu. All rights reserved.
//
#define KNormalBBtnHeight 44.0f
#import "DModiyPhoneViewcontroller.h"
#import "LoginLogic.h"
#import "RMTimer.h"
#import "DModiyNewPhoneViewController.h"
@interface DModiyPhoneViewcontroller ()<UITextFieldDelegate>
@property(nonatomic,strong)  UIScrollView *scrollview;
@property (nonatomic,strong) UILabel *msglab;
@property (nonatomic,strong) UILabel *phonelab;
@property (nonatomic,strong) UILabel *codelab;
@property (nonatomic,strong) UITextField *phoneField;
@property (nonatomic,strong) UITextField *codeField;
@property (nonatomic,strong) UIButton *nextStep;
@property (nonatomic,strong) UIButton *getCodeBtn;
@property(nonatomic,assign)  NSInteger seconds;
@property(nonatomic,retain) LoginLogic *logic;//逻辑层


@end
@implementation DModiyPhoneViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换手机号码";
    [self addBackItem];
    _logic = [LoginLogic new];
    [self renderContents];
}


- (void)renderContents {
    [self.view addSubview:self.scrollview];
    [self.scrollview addSubview:self.msglab];
    _msglab.frame = CGRectMake(16,5,SCREEN_WIDTH-32,45);
    NSString *phone = curUser.username;

    _msglab.text = NSStringFormat(@"＊更换手机号，下次登录可使用新手机号登录。当前手机号:%@",phone);
    
    UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0,_msglab.bottom+5, self.scrollview.width, 1)];
    line0.backgroundColor =  [UIColor clearColor]; //CLineColor;
    [self.scrollview addSubview:line0];
    
    UIView *BgView = [UIView new];
    BgView.backgroundColor = [UIColor whiteColor];
    BgView.frame=CGRectMake(0,line0.bottom,SCREEN_WIDTH,44);
    [self.scrollview addSubview:BgView];
  
    UILabel *k_codeLabel = [[UILabel alloc] init];
    k_codeLabel.frame = CGRectMake(15,11/*55-44*/,50,22);
    k_codeLabel.text = @"验证码:";
    k_codeLabel.font = FontOfSize(12);
    k_codeLabel.textColor = CFontColor1;
    [BgView addSubview:k_codeLabel];
    
    self.getCodeBtn.frame = CGRectMake(self.scrollview.frame.size.width-125,k_codeLabel.frame.origin.y,100,21);
    [BgView addSubview:self.getCodeBtn];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,44-44, self.scrollview.width, 1)];
    line1.backgroundColor =CLineColor;
    [BgView addSubview:line1];
    
    self.codeField.frame = CGRectMake(k_codeLabel.right,k_codeLabel.frame.origin.y,self.scrollview.width-k_codeLabel.right-_getCodeBtn.width, 21);
    [BgView addSubview: self.codeField];
    self.codeField.delegate=self;
//    [self.codeField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        if (x.length>0) {
//            self.nextStep.enabled = YES;
//            [self.nextStep setBackgroundImage:IMAGE_NAMED(@"提交按钮底框") forState:UIControlStateNormal];
//        } else {
//            self.nextStep.enabled = NO;
//            [self.nextStep setBackgroundImage:IMAGE_NAMED(@"n提交按钮底框") forState:UIControlStateNormal];
//        }
//    }];
    
    UIView *v_line = [[UIView alloc] initWithFrame:CGRectMake(self.codeField.right-10, k_codeLabel.frame.origin.y+3, 1,15)];
    v_line.backgroundColor = CFontColor3;
    [BgView addSubview:v_line];
    

    [_getCodeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0,BgView.bottom, self.scrollview.width, 1)];
    line2.backgroundColor = CLineColor;
    [self.scrollview addSubview:line2];
    
    [self.scrollview addSubview:self.nextStep];
    _nextStep.frame = CGRectMake(15,186,self.scrollview.width-30,KNormalBBtnHeight);
//    [_nextStep addTapBlock:^(UIButton *btn) {
//        [self_weak_ UserAccoutLogin];
//    }];
    [_nextStep addTarget:self action:@selector(UserAccoutLogin) forControlEvents:UIControlEventTouchUpInside];
}


-(void)UserAccoutLogin {
    self.logic.phoneNumber = help_userManager.curUserInfo.username;
    self.logic.messageCode = self.codeField.text;
    [_logic checkCodeDataWithCallback:^(BOOL successful, NSString *tips) {
        if (successful) {
            NSDictionary *params = @{@"username":help_userManager.curUserInfo.username,
                                     @"password":self.codeField.text,
                                     @"grant_type":@"password"
                                     };
            
            [self requestData:params];
        } else {
            [PSTipsView showTips:tips];
        }
    }];
   
}
//MARK:判断手机号是否正确
- (void)requestData:(NSDictionary*)params {
    NSString*url1=[NSString stringWithFormat:@"%@%@",EmallHostUrl,URL_post_sms_verification];
    NSDictionary*parameters=@{@"phoneNumber":params[@"username"],@"code":params[@"password"]};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:url1 parameters:parameters success:^(id responseObject) {
        DModiyNewPhoneViewController*modiyNewVC=[[DModiyNewPhoneViewController alloc]init];
        [self.navigationController pushViewController:modiyNewVC animated:YES];
    } failure:^(NSError *error) {
        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (data) {
            id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString*message=body[@"message"];
            [PSTipsView showTips:message?message:@"短信验证码不匹配"];
            
        }
    }];
}



//MARK:获取验证码
- (void)getCode {
    self.getCodeBtn.enabled = NO;
    _logic.phoneNumber = self.phoneField.text;
    [_logic checkDataWithPhoneCallback:^(BOOL successful, NSString *tips) {
        if (successful) {
            [self.logic getVerificationCodeData:^(id data) {
                [PSTipsView showTips:@"已发送"];
                self.seconds=60;
                [self startTimer];
                
            } failed:^(NSError *error) {
                NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (data) {
                    id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSString*message = body[@"message"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [PSTipsView showTips:message];
                        self.getCodeBtn.enabled=YES;
                    });
                }
            }];
            
        } else {
            self.getCodeBtn.enabled = YES;
            [PSTipsView showTips:tips];
        }
    }];
}

//开启定时器
- (void)startTimer {
    RMTimer *sharedTimer = [RMTimer sharedTimer];
    [sharedTimer resumeTimerWithDuration:self.seconds interval:1 handleBlock:^(NSInteger currentTime) {
        self.getCodeBtn.enabled = NO;
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重发(%ld)",currentTime] forState:UIControlStateDisabled];
        [self.getCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        
    } timeOutBlock:^{
        self.getCodeBtn.enabled = YES;
    }];
}




#pragma mark --- Setting&&Getting
- (UIScrollView *)scrollview {
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollview.backgroundColor = [UIColor colorWithHexString:@"F9F8FE"];
    }
    return _scrollview;
}
- (UITextField *)phoneField {
    if (!_phoneField) {
        _phoneField = [[UITextField alloc] init];
        _phoneField.placeholder = @"请输入旧的手机号码";
        _phoneField.textAlignment = NSTextAlignmentLeft;
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneField.text = help_userManager.curUserInfo.username;
        _phoneField.textColor = [UIColor colorWithHexString:@"999999"];
        _phoneField.font = [UIFont systemFontOfSize:12.0f];
    }
    return _phoneField;
}
- (UITextField *)codeField {
    if (!_codeField) {
        _codeField = [[UITextField alloc] init];
        _codeField.placeholder = @"请输入验证码";
        _codeField.textAlignment = NSTextAlignmentLeft;
        _codeField.textColor = [UIColor colorWithHexString:@"999999"];
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
        _codeField.font = [UIFont systemFontOfSize:12.0f];
    }
    return _codeField;
}
- (UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:CFontColor3 forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _getCodeBtn;
}
- (UIButton *)nextStep {
    if (!_nextStep) {
        _nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextStep setTitle:@"下一步" forState:UIControlStateNormal];
       // _nextStep.enabled = NO;
        [_nextStep setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _nextStep.titleLabel.font=FontOfSize(14);
//        [_nextStep setBackgroundImage:IMAGE_NAMED(@"n提交按钮底框") forState:UIControlStateNormal];
        [_nextStep setBackgroundColor:ImportantColor];
    }
    return _nextStep;
}
-(UILabel *)msglab {
    if (!_msglab) {
        _msglab = [UILabel new];
        _msglab.textAlignment = NSTextAlignmentLeft;
        _msglab.textColor = [UIColor colorWithHexString:@"264C90"];
        _msglab.font = [UIFont systemFontOfSize:12.0f];
        _msglab.numberOfLines = 2;
    }
    return _msglab;
}


@end
