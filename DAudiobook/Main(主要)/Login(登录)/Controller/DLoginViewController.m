//
//  DLoginViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/16.
//  Copyright © 2019年 liujiliu. All rights reserved.
//
//NSString * const AFNetworkingOperationFailingURLResponseDataErrorKey = @"com.alamofire.serialization.response.error.data";
#define RELATIVE_HEIGHT_VALUE(value) SCREEN_HEIGHT * value / 667.0
#import "DLoginViewController.h"
#import "PSLoginMiddleView.h"
#import "PSLoginBackgroundView.h"
#import "PSLoginTopView.h"
#import "LoginLogic.h"
#import "RMTimer.h"

typedef NS_ENUM(NSInteger, PSLoginModeType) {
    PSLoginModeCode,
    PSLoginModePassword,
};

@interface DLoginViewController ()<UITextFieldDelegate>
@property (nonatomic ,assign) PSLoginModeType loginModeType;
@property (nonatomic, strong) PSLoginMiddleView *loginMiddleView;
@property (nonatomic, strong) YYLabel *protocolLabel;
@property (nonatomic , strong) UIButton *loginTypeButton ;
@property(nonatomic,assign) NSInteger seconds;
@property(nonatomic,strong) LoginLogic *logic;//逻辑层
@property (nonatomic ,strong) NSString *mode;
@end

@implementation DLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _logic = [LoginLogic new];
    //初始化登录模式(验证码登录)
    self.loginModeType=PSLoginModeCode;
    self.mode=@"sms_verification_code";
    [self renderContents];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:self.loginMiddleView.phoneTextField];
}
- (void)textFieldDidChange:(NSNotification *)notification{
    UITextField *textField = (UITextField *)notification.object;
    if (textField == self.loginMiddleView.phoneTextField) {
        NSUInteger wordLen = textField.text.length;
        if (wordLen > 0) {
            [self.loginMiddleView.loginButton setBackgroundImage:[UIImage imageNamed:@"提交按钮底框"] forState:UIControlStateNormal];
        }
    }
}



- (void)renderContents {
   
    PSLoginBackgroundView *backgroundView = [PSLoginBackgroundView new];
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
  
    
    self.loginMiddleView = [PSLoginMiddleView new];
    [self.view addSubview:self.loginMiddleView];
    [self.loginMiddleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(160);
        make.centerY.mas_equalTo(self.view).offset(10);
    }];
    self.loginMiddleView.phoneTextField.delegate=self;
    self.loginMiddleView.phoneTextField.text=[kUserDefaults objectForKey:@"D_phone"]?[kUserDefaults objectForKey:@"D_phone"]:@"";

 
    [self.loginMiddleView.codeButton addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginMiddleView.loginButton addTarget:self action:@selector(LoginAction) forControlEvents:UIControlEventTouchUpInside];
    self.protocolLabel = [YYLabel new];
    self.protocolLabel.textAlignment=NSTextAlignmentCenter;
    NSString*usageProtocol=@"我已阅读并同意《狱务通软件使用协议》";
    [self.protocolLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        @strongify(self)
        NSString *tapString = [text plainTextForRange:range];
        NSString *protocolString = usageProtocol;
        if (tapString) {
            if ([protocolString containsString:tapString]) {
                [self openProtocol];
            }else{
                [self updateProtocolStatus];
            }
        }
    }];
    [self.view addSubview:self.protocolLabel];
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-15);
        make.size.mas_equalTo(CGSizeMake(240, 30));
    }];
    [self updateProtocolText];
    
    
    
    
    self.loginTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginTypeButton addTarget:self action:@selector(loginTypeChange) forControlEvents:UIControlEventTouchUpInside];
    [self.loginTypeButton setTitleColor:AppBaseTextColor3 forState:UIControlStateNormal];
    self.loginTypeButton.titleLabel.font = AppFont(13);
    self.loginTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.loginTypeButton setTitle:@"使用密码登录" forState:UIControlStateNormal];
    [self.view addSubview:self.loginTypeButton];
    [self.loginTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginMiddleView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(180, 40));
        make.right.mas_equalTo(self.loginMiddleView.mas_right);
    }];
    PSLoginTopView *topView = [PSLoginTopView new];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.loginMiddleView.mas_top).offset(-RELATIVE_HEIGHT_VALUE(60));
        make.height.mas_equalTo(86);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//MARK:获取验证码
- (void)getCode {

    self.loginMiddleView.codeButton.enabled = NO;
    _logic.phoneNumber = self.loginMiddleView.phoneTextField.text;
    [_logic checkDataWithPhoneCallback:^(BOOL successful, NSString *tips) {
        if (successful) {
            [self.logic getVerificationCodeData:^(id data) {
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
                    self.loginMiddleView.codeButton.enabled=YES;
                });
                
            }];
        } else {
            self.loginMiddleView.codeButton.enabled = YES;
            [PSTipsView showTips:tips];
        }
    }];
}

-(void)LoginAction{
    self.logic.phoneNumber = self.loginMiddleView.phoneTextField.text;
    self.logic.messageCode = self.loginMiddleView.codeTextField.text;
    self.logic.loginModel=self.mode;
    [_logic checkDataWithCallback:^(BOOL successful, NSString *tips) {
        if (successful) {
            [kUserDefaults setObject:self.loginMiddleView.phoneTextField.text forKey:@"D_phone"];
            NSDictionary*parmeters=@{
            @"phoneNumber":self.loginMiddleView.phoneTextField.text,
            @"verificationCode":self.loginMiddleView.codeTextField.text,
            @"name":self.loginMiddleView.phoneTextField.text,//姓名是手机号码
            @"group":@"CUSTOMER"
            };
            [kUserDefaults setObject:self.loginMiddleView.phoneTextField.text forKey:@"phone"];
            help_userManager.loginMode=self.mode;
            [help_userManager requestEcomRegister:parmeters];
        } else {
            [PSTipsView showTips:tips];
        }
    }];
}
-(void)loginTypeChange{
    self.loginMiddleView.codeTextField.text=@"";
    if (self.loginModeType==PSLoginModePassword) {
        self.loginModeType=PSLoginModeCode;
        self.mode=@"sms_verification_code";
        self.loginMiddleView.codeButton.hidden=NO;
        self.loginMiddleView.codeTextField.placeholder=@"请输入验证码";
        self.loginMiddleView.codeLable.text=@"验证码";
        self.loginMiddleView.codeTextField.secureTextEntry=NO;
        [self.loginTypeButton setTitle:@"使用密码登录" forState:0];
    }
    else if (self.loginModeType==PSLoginModeCode){
        self.loginModeType=PSLoginModePassword;
        self.mode=@"account_password";
        self.loginMiddleView.codeButton.hidden=YES;
        self.loginMiddleView.codeTextField.placeholder=@"请输入密码";
        self.loginMiddleView.codeTextField.secureTextEntry=YES;
        self.loginMiddleView.codeLable.text=@"密码";
        [self.loginTypeButton setTitle:@"使用验证码登录" forState:0];
    }
    else{
        
    }
    
}
//开启定时器
- (void)startTimer {
    RMTimer *sharedTimer = [RMTimer sharedTimer];
    [sharedTimer resumeTimerWithDuration:self.seconds interval:1 handleBlock:^(NSInteger currentTime) {
        self.loginMiddleView.codeButton.enabled = NO;
        [self.loginMiddleView.codeButton setTitle:[NSString stringWithFormat:@"重发(%ld)",(long)currentTime] forState:UIControlStateDisabled];
        [self.loginMiddleView.codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    } timeOutBlock:^{
        self.loginMiddleView.codeButton.enabled = YES;
        [self.loginMiddleView.codeButton setTitle:[NSString stringWithFormat:@"%@",@"获取验证码"] forState:UIControlStateNormal];
        
        
    }];
}


#pragma mark -- 注册协议
- (void)openProtocol {
//    PSProtocolViewController *protocolViewController = [[PSProtocolViewController alloc] init];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:protocolViewController animated:YES completion:nil];
}



- (void)updateProtocolStatus {
    self.logic.agreeProtocol = !self.logic.agreeProtocol;
    [self updateProtocolText];
}


- (void)updateProtocolText {
    NSString*read_agree=@"我已阅读并同意";
    NSString*usageProtocol=@"《狱务通软件使用协议》";
    NSMutableAttributedString *protocolText = [NSMutableAttributedString new];
    UIFont *textFont = FontOfSize(12);
    [protocolText appendAttributedString:[[NSAttributedString alloc] initWithString:read_agree attributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:AppBaseTextColor2}]];
    [protocolText appendAttributedString:[[NSAttributedString  alloc] initWithString: usageProtocol attributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:AppBaseTextColor2}]];
    [protocolText appendAttributedString:[[NSAttributedString  alloc] initWithString:@" " attributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:AppBaseTextColor2}]];
    UIImage *statusImage = self.logic.agreeProtocol?[UIImage imageNamed:@"同意勾选icon"] : [UIImage imageNamed:@"未勾选"] ;
    [protocolText insertAttributedString:[NSAttributedString attachmentStringWithContent:statusImage contentMode:UIViewContentModeCenter attachmentSize:statusImage.size alignToFont:textFont alignment:YYTextVerticalAlignmentCenter] atIndex:0];
    protocolText.alignment = NSTextAlignmentRight ;
    self.protocolLabel.attributedText = protocolText;
    self.protocolLabel.numberOfLines=0;
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
