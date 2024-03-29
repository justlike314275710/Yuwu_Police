//
//  UserManager.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/22.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "IMManager.h"
#import "OauthInfo.h"
#import "LawUserInfo.h"

typedef NS_ENUM(NSInteger, UserLoginType){
    kUserLoginTypeUnKnow = 0,//未知
    kUserLoginTypeWeChat,//微信登录
    kUserLoginTypeQQ,///QQ登录
    kUserLoginTypePwd,///账号登录
};
//用户身份
typedef NS_ENUM(NSInteger, UserCertificationStatus){
    PENDING_CERTIFIED = 0,//待认证 普通用户
    PENDING_APPROVAL,//待审核
    APPROVAL_FAILURE,//审核失败
    CERTIFIED,//已认证
};

typedef void (^loginBlock)(BOOL success, NSString * des);

typedef void(^RequestDataCompleted)(id data);
typedef void(^RequestDataFailed)(NSError *error);
typedef void(^RequestDataTaskCompleted)(id data);
typedef void(^CheckDataCallback)(BOOL successful, NSString *tips);
typedef void(^Complete)(void);


#define isLogin [UserManager sharedUserManager].isLogined
#define curUser [UserManager sharedUserManager].curUserInfo
#define help_userManager [UserManager sharedUserManager]
/**
 包含用户相关服务
 */
@interface UserManager : NSObject
//单例
SINGLETON_FOR_HEADER(UserManager)

///<当前用户信息
@property (nonatomic, strong) UserInfo *curUserInfo;
@property (nonatomic, assign) UserLoginType loginType;
///<当前认证信息Token 信息
@property (nonatomic, strong) OauthInfo *oathInfo;
@property (nonatomic, assign) BOOL isLogined;
@property (nonatomic, assign) UserCertificationStatus userStatus;
///<律师用户的信息
@property (nonatomic, strong) LawUserInfo *lawUserInfo;
@property (nonatomic, strong) UIImage *avatarImage; //及时修改的头像
@property (nonatomic, copy) NSString *myLifePraise; //我的朋友圈是否有人点赞评论

@property (nonatomic , strong) NSString *loginMode;//登录模式


#pragma mark - ——————— 注册账号判断账号状态   ————————
-(BOOL)requestPhoneEcomRegister:(NSDictionary *)parmeters;
-(BOOL)requestUsernameEcomRegister:(NSDictionary *)parmeters;

#pragma mark - ——————— 登录相关 ————————

-(void)JudgeIdentityCallback:(loginBlock)callback;
#pragma mark - ——————— 刷新token ————————
- (void)refreshOuathToken;
/**
 三方登录

 @param loginType 登录方式
 @param completion 回调
 */
//-(void)login:(UserLoginType )loginType completion:(loginBlock)completion;

/**
手动登录到服务器
 @param params 登录方式
 @param completion 回调
@param refresh 是否刷新token
 */
-(void)loginToServer:(NSDictionary *)params
             refresh:(BOOL)refresh
          completion:(loginBlock)completion;

/**
 带参登录

 @param loginType 登录方式
 @param params 参数，手机和账号登录需要
 @param completion 回调
 */
-(void)login:(UserLoginType )loginType params:(NSDictionary *)params completion:(loginBlock)completion;

/**
 自动登录

 @param completion 回调
 */
-(void)autoLoginToServer:(loginBlock)completion;

/**
 退出登录

 @param completion 回调
 */
- (void)logout:(loginBlock)completion;

/**
 加载缓存用户数据

 @return 是否成功
 */
-(BOOL)loadUserInfo;

/**
 加载公共服务数据
 @return 是否成功
 */
-(BOOL)loadUserOuathInfo;

/**
保存用户信息
 */
-(void)saveUserInfo;

-(void)saveLawUserInfo;
-(BOOL)loadLawUserInfo;

-(void)saveUserState;
-(BOOL)loadUserState;





@end
