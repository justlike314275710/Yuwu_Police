


//搜索界面
#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"]

#define KColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define KWidth (KScreenWidth > 375 ? 576/3 : 345/2)
#define kSpace (KScreenWidth - KWidth * 2) / 3

/*------------------------------数据验证------------------------------*/
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])


/*------------------------------图片------------------------------*/

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define ImageNamed(name) [UIImage imageNamed:name]
#define iString(x)    [NSString stringWithFormat:@"%ld",(long)x]

/*! 警告框-一个按钮【VC】 */
#define D_SHOW_ALERT(title, msg)  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title  message:msg preferredStyle:UIAlertControllerStyleAlert];\
[alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {\
BALog(@"你点击了确定按钮！");\
}]];\
[self presentViewController:alert animated:YES completion:nil];\

/*! 警告框-一个按钮【View】 */
#define D_AlertAtView(msg) [[[UIAlertView alloc] initWithTitle:@"温馨提示：" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];

#define DT_IS_IPHONEX_XS   (SCREEN_HEIGHT == 812.f)  //是否是iPhoneX、iPhoneXS


//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}


/*------------------------------广点通广告------------------------------*/
#define GDTAppkey        @"1106404029"
#define GDTPlacementIdK  @"8080427741178048"
#define GDTPlacementIdD  @"3000724761475652"
#define GDTPlacementIdC  @"1050221701477683"
#define GDTPlacementIdY  @"2080325741575674"

/*------------------Appkey------------------------*/
//友盟
#define UmengAppkey @"584503b645297d6e0e0004c6"
#define WXAppkey    @"wx53ed0e60138aa498"
#define QQAppkey    @"1105893514"
#define WBAppkey    @"3733899087"
#define WXAppSecret @"f86c46b2a02872e740bba901f3ef3a92"
#define QQAppSecret @"OnXqfRncSSAEmnIK"
#define WBAppSecret @"f6b748e2857904dcaa15bd17266a4180"
//后端云
#define BmobAppkey  @"4d49f76cc69abd8fc8f97ebef70a3120"
//腾讯bug收集和数据分析
#define BuglyAppID  @"c2783c0059"

//网易云信
#define kIMAppKey @"87dae6933488de4bab789054a3a5c720"
#define kIMAppSecret @"c34bd403b29a"
#define kIMPushCerName @""
#define RefreshToken @"RefreshToken" //刷新token

#pragma mark - ——————— 拼接字符串 ————————
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

#define AvaterImageWithUsername(username)  [NSString stringWithFormat:@"%@/users/by-username/avatar?username=%@",EmallHostUrl,username]

#pragma mark - ——————— 发送通知 ————————
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

#define kUserDefaults       [NSUserDefaults standardUserDefaults]

#define IMAGE_NAMED(name) [UIImage imageNamed:name]

/// PushVC
#define     PushVC(vc)                  {\
[vc setHidesBottomBarWhenPushed:YES];\
[self.navigationController pushViewController:vc animated:YES];\
}



// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)




#pragma mark - ——————— 用户相关 ————————

//被踢下线
#define KNotificationOnKick @"KNotificationOnKick"

//用户信息缓存 名称
#define KUserCacheName @"KUserCacheName"

//用户信息userName 账号名缓存
#define KUserName @"KUserName"


//用户model缓存
#define KUserModelCache @"KUserModelCache"
//用户类型名称(是否是律师)
#define KUserStateName @"KUserStateName"
#define KUserLawModel @"KUserLawModel"


//用户公共服务信息缓存
#define KOauthCacheName @"KOauthCacheName"

//用户公共服务信息Model缓存
#define KOauthModelCache @"KOauthModelCache"

//用户律师认证信息存储
#define KLawyerModelCache @"KLawyerModelCache"

#define AppScheme @"gkytHelpApp"

#define KNSKeyedArchiverRemoveAll @"KNSKeyedArchiverRemoveAll"

//登录状态改变通知
#define KNotificationLoginStateChange @"loginStateChange"

//自动登录成功
#define KNotificationAutoLoginSuccess @"KNotificationAutoLoginSuccess"

//修改资料
#define KNotificationModifyDataChange    @"KNotificationModifyDataChange"

//个人中心界面变化
#define KNotificationMineDataChange    @"KNotificationMineDataDataChange"
//刷新首页文章列表
#define KNotificationHomePageRefreshList    @"KNotificationHomePageRefreshList"
//刷新收藏文章列表
#define KNotificationCollectArtickeRefreshList    @"KNotificationCollectArtickeRefreshList"
//刷新我的文章列表
#define KNotificationRefreshMyArticle    @"KNotificationRefreshMyArticle"
//发文章权限
#define KNotificationArticleAuthor @"KNotificationArticleAuthor"
//红点刷新
#define KNotificationRedDotRefresh @"KNotificationRedDotRefresh"

//红点隐藏
#define KNotificationRedDothide @"KNotificationRedDothide"
//刷新文章详情通知
#define KNotificationRefreshArticleDetail @"KNotificationRefreshArticleDetail"

