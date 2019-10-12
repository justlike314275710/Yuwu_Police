//
//  DModiyNewPhoneViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/19.
//  Copyright © 2019年 liujiliu. All rights reserved.
//
#define KNormalBBtnHeight 44.0f
#import "DModiyNewPhoneViewController.h"
#import "LoginLogic.h"
#import "RMTimer.h"
@interface DModiyNewPhoneViewController ()
@property(nonatomic,strong)  UIScrollView *scrollview;
@property (nonatomic,strong) UILabel *phonelab;
@property (nonatomic,strong) UILabel *codelab;
@property (nonatomic,strong) UITextField *phoneField;
@property (nonatomic,strong) UITextField *codeField;
@property (nonatomic,strong) UIButton *nextStep;
@property (nonatomic,strong) UIButton *getCodeBtn;
@property (nonatomic,assign) NSInteger seconds;
@property (nonatomic,retain) LoginLogic *logic;//逻辑层

@end

@implementation DModiyNewPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.title=@"更换手机号码";
    _logic = [LoginLogic new];
      [self renderContents];
    // Do any additional setup after loading the view.
}

-(void)renderContents{
    [self.view addSubview:self.scrollview];
    
    UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0,5, self.scrollview.width, 1)];
    line0.backgroundColor = CLineColor;
    [self.scrollview addSubview:line0];
    
    UIView *BgView = [UIView new];
    BgView.backgroundColor = [UIColor whiteColor];
    BgView.frame=CGRectMake(0,line0.bottom,SCREEN_WIDTH,88);
    [self.scrollview addSubview:BgView];
    
    UILabel *k_phoneNumber = [[UILabel alloc] init];
    k_phoneNumber.frame = CGRectMake(15,11,50,22);
    k_phoneNumber.text = @"手机号:";
    k_phoneNumber.font = [UIFont systemFontOfSize:12.0f];
    k_phoneNumber.textColor = CFontColor1;
    [BgView addSubview:k_phoneNumber];
    [BgView addSubview:self.phoneField];
    self.phoneField.frame = CGRectMake(k_phoneNumber.right,k_phoneNumber.frame.origin.y, self.scrollview.width-k_phoneNumber.right-10-15, 21);
    UILabel *k_codeLabel = [[UILabel alloc] init];
    k_codeLabel.frame = CGRectMake(15,55,50,22);
    k_codeLabel.text = @"验证码:";
    k_codeLabel.font = [UIFont systemFontOfSize:12.0f];
    k_codeLabel.textColor = CFontColor1;
    [BgView addSubview:k_codeLabel];
    
    self.getCodeBtn.frame = CGRectMake(self.scrollview.width-125,k_codeLabel.frame.origin.y,100,21);
    [BgView addSubview:self.getCodeBtn];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,44, self.scrollview.width, 1)];
    line1.backgroundColor = CLineColor;
    [BgView addSubview:line1];
    
    self.codeField.frame = CGRectMake(k_codeLabel.right,k_codeLabel.frame.origin.y,self.scrollview.width-k_codeLabel.right-_getCodeBtn.width, 21);
    [BgView addSubview: self.codeField];
    
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
    
//    @weakify(self)
//    [_getCodeBtn addTapBlock:^(UIButton *btn) {
//        @strongify(self)
//        [self getCode];
//    }];
    
    [_getCodeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0,BgView.bottom, self.scrollview.width, 1)];
    line2.backgroundColor = CLineColor;
    [self.scrollview addSubview:line2];
    
    [self.scrollview addSubview:self.nextStep];
    _nextStep.frame = CGRectMake(15,160,self.scrollview.width-30,KNormalBBtnHeight);
   
    [_nextStep addTarget:self action:@selector(changePhoneNumberAction) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 狱警端修改手机号
-(void)police_PhoneNumberAction{
    NSString*url=NSStringFormat(@"%@%@",ServerUrl,URL_Police_updatePhone);
    NSDictionary*param=@{@"accountName":self.phoneField.text};
    NSString *access_token = help_userManager.oathInfo.access_token;
    NSString *token = NSStringFormat(@"Bearer %@",access_token);
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper setValue:token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:url parameters:param success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark -- 公共服务修改手机号
-(void)changePhoneNumberAction{
    
    if (self.phoneField.text.length<11) {
        [PSTipsView showTips:@"请输入正确的手机号码！"];
        return;
    }
    if (self.codeField.text.length<4) {
        [PSTipsView showTips:@"请输入正确的验证码！"];
        return;
    }
    UserInfo *user = help_userManager.curUserInfo;
    NSLog(@"%@",user);
    [[PSLoadingView sharedInstance]show];
    NSString*url=[NSString stringWithFormat:@"%@%@",EmallHostUrl,URL_modify_PhoneNumber];
    NSDictionary*parmeters=@{
                             @"phoneNumber":self.phoneField.text,
                             @"verificationCode":self.codeField.text
                             };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString*token=[NSString stringWithFormat:@"Bearer %@",help_userManager.oathInfo.access_token];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [manager PUT:url parameters:parmeters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        if (responses.statusCode==204) {
            [PSTipsView showTips:@"修改号码成功"];
            help_userManager.curUserInfo.username = self.phoneField.text;
            [help_userManager saveUserInfo];
            [[PSLoadingView sharedInstance]dismiss];
            //发送通知
           // KPostNotification(KNotificationModifyDataChange,nil);
           // KPostNotification(KNotificationMineDataChange, nil);
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:NO completion:nil];
            [self police_PhoneNumberAction];//修改狱警端手机号码
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[PSLoadingView sharedInstance]dismiss];
        NSLog(@"%@",error);
        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (ValidData(data)) {
            id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString*message=body[@"message"];
            [PSTipsView showTips:message];
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
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH , SCREEN_HEIGHT)];
        _scrollview.backgroundColor = [UIColor colorWithHexString:@"F9F8FE"];
    }
    return _scrollview;
}
- (UITextField *)phoneField {
    if (!_phoneField) {
        _phoneField = [[UITextField alloc] init];
        _phoneField.placeholder = @"请输入新的手机号码";
        _phoneField.textAlignment = NSTextAlignmentLeft;
        _phoneField.textColor = [UIColor colorWithHexString:@"999999"];
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneField.font = [UIFont systemFontOfSize:12.0f];
    }
    return _phoneField;
}
- (UITextField *)codeField {
    if (!_codeField) {
        _codeField = [[UITextField alloc] init];
        _codeField.placeholder = @"请输入验证码";
        _codeField.textAlignment = NSTextAlignmentLeft;
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
        _codeField.textColor = [UIColor colorWithHexString:@"999999"];
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
        [_nextStep setTitle:@"保存" forState:UIControlStateNormal];
        //_nextStep.enabled = NO;
        _nextStep.titleLabel.font=FontOfSize(14);
        [_nextStep setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_nextStep setBackgroundColor:ImportantColor];
    }
    return _nextStep;
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
