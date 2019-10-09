//
//  PSLoginMiddleView.m
//  PrisonService
//
//  Created by calvin on 2018/4/9.
//  Copyright © 2018年 calvin. All rights reserved.
//
#define RELATIVE_WIDTH_VALUE(value) SCREEN_WIDTH * value / 375.0
#import "PSLoginMiddleView.h"

@interface PSLoginMiddleView ()

@end

@implementation PSLoginMiddleView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        CGFloat sidePadding = RELATIVE_WIDTH_VALUE(15);

        _phoneTextField = [[PSUnderlineTextField alloc] initWithFrame:CGRectZero];
        _phoneTextField.font = AppBaseTextFont2;
        _phoneTextField.borderStyle = UITextBorderStyleNone;
        _phoneTextField.textColor = AppBaseTextColor1;
        _phoneTextField.textAlignment = NSTextAlignmentCenter;
         NSString*please_enter_phone_number=@"请输入手机号码";;
        _phoneTextField.placeholder =please_enter_phone_number;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
//        if ([LXFileManager readUserDataForKey:@"phoneNumber"]) {
//            _phoneTextField.text = [LXFileManager readUserDataForKey:@"phoneNumber"];
//        }
        [self addSubview:_phoneTextField];
        [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sidePadding);
            make.right.mas_equalTo(-sidePadding);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        
        UILabel*phoneLable=[UILabel new];
        NSString*phonenumber=@"手机号";
        phoneLable.text=phonenumber;
        phoneLable.font= AppFont(13);
        [self addSubview:phoneLable];
        [phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneTextField.mas_top);
            make.left.mas_equalTo(self.phoneTextField.mas_left);
            make.bottom.mas_equalTo(self.phoneTextField.mas_bottom);
            make.width.mas_equalTo(70);
        }];
        phoneLable.numberOfLines=0;
 
        _codeTextField = [[PSUnderlineTextField alloc] initWithFrame:CGRectZero];
        _codeTextField.font = AppFont(13);
        _codeTextField.borderStyle = UITextBorderStyleNone;
        _codeTextField.textColor = UIColorHex(0x666666);
        _codeTextField.textAlignment = NSTextAlignmentCenter;
        NSString*please_enter_verify_code=@"请输入验证码";
        _codeTextField.placeholder = please_enter_verify_code;
        _codeTextField.keyboardType =UIKeyboardTypeASCIICapable;
        [self addSubview:_codeTextField];
        [_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sidePadding);
            make.right.mas_equalTo(-sidePadding);
            make.top.mas_equalTo(self.phoneTextField.mas_bottom);
            //make.bottom.mas_equalTo(0);
            make.height.equalTo(self.phoneTextField);
        }];

        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeButton.titleLabel.font = FontOfSize(12);
        [_codeButton setTitleColor:AppBaseTextColor3 forState:UIControlStateNormal];
        [_codeButton setTitleColor:AppBaseTextColor2 forState:UIControlStateDisabled];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self addSubview:_codeButton];
        [_codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.codeTextField.mas_top);
            make.right.mas_equalTo(self.codeTextField.mas_right);
            make.bottom.mas_equalTo(self.codeTextField.mas_bottom);
            make.width.mas_equalTo(70);
        }];
        
        NSString*verifycode=@"验证码";
       self.codeLable=[UILabel new];
       self.codeLable.text=verifycode;
       self.codeLable.font= AppBaseTextFont2;
        [self addSubview:self.codeLable];
        [self.codeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.codeTextField.mas_top);
            make.left.mas_equalTo(self.codeTextField.mas_left);
            make.bottom.mas_equalTo(self.codeTextField.mas_bottom);
            make.width.mas_equalTo(70);
        }];
        self.codeLable.numberOfLines=0;
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.titleLabel.font = AppBaseTextFont1;
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSString*login=@"登录";
        [_loginButton setTitle:login forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"提交按钮底框"] forState:UIControlStateNormal];
        //[_loginButton setBackgroundColor:AppBaseTextColor3];
        [self addSubview:_loginButton];
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.codeTextField.mas_bottom).offset(70);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 44));
        }];
    }
    return self;
}


@end
