//
//  DAccountViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//
#define StatusHeight  [[UIApplication sharedApplication] statusBarFrame].size.height
#define Iphone6ScaleWidth SCREEN_WIDTH/375.0

#import "UIImage+WLCompress.h"
#import "LLActionSheetView.h"
#import "DAccountViewController.h"
#import "YYAnimatedImageView.h"
#import "MineTableViewCell.h"
#import "PSAuthorizationTool.h"
#import "DPenNameViewController.h"
@interface DAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) YYAnimatedImageView *headImgView; //头像
@property(nonatomic, strong) NSArray *dataSource;
@property (nonatomic , strong) UITableView *accountTableView;
@property (nonatomic , strong) NSDictionary *penName ;
@property (nonatomic , strong) NSString *pseudinym ;
@end

@implementation DAccountViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self getArticeData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"账号信息";
   
   // [self addBackItem];
    [self renderContents];
   
    // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:NO];
}


-(void)getArticeData{
    NSString *url = NSStringFormat(@"%@%@",ServerUrl,URL_Police_updateArticle);
    NSString*token=[NSString stringWithFormat:@"Bearer %@",help_userManager.oathInfo.access_token];
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setValue:token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
        NSString*code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            self.pseudinym=responseObject[@"data"][@"pseudonym"];
            [self intData];
        }
        else{
           // [PSTipsView showTips:@"获取账号信息失败!"];
        }
    } failure:^(NSError *error) {
        // [PSTipsView showTips:@"获取账号信息失败!"];
    }];
}


- (void)intData{
    _dataSource=[NSArray new];
    NSString *nickName = help_userManager.curUserInfo.nickname?help_userManager.curUserInfo.nickname:@"";
    NSDictionary *name = @{@"titleText":@"真实姓名",@"title_icon":@"姓名icon",@"detailText":ValidStr(help_userManager.lawUserInfo.realName)?help_userManager.lawUserInfo.realName:@"无",@"arrow_icon":@"进入"};
    
    
    NSString*sexSting=help_userManager.lawUserInfo.sex;
    NSDictionary *sex = @{@"titleText":@"性别",@"title_icon":@"性别icon",@"detailText":ValidStr(sexSting)?sexSting:@"无",@"arrow_icon":@"进入"};
    
    
    _penName=[NSDictionary new];
    if (ValidStr(help_userManager.lawUserInfo.pseudonym)) {
        NSString *penNameSting  = help_userManager.lawUserInfo.pseudonym;
        _penName= @{@"titleText":@"笔名",@"title_icon":@"作者icon",@"detailText":ValidStr(self.pseudinym)?self.pseudinym:penNameSting,@"arrow_icon":@"进入"};
    } else {
        _penName= @{@"titleText":@"笔名",@"title_icon":@"作者icon",@"detailText":ValidStr(self.pseudinym)?self.pseudinym:@"请设置笔名",@"arrow_icon":@"进入"};
        
    }
    
    
    
    NSString*addressString=[NSString stringWithFormat:@"%@%@",help_userManager.lawUserInfo.pName,help_userManager.lawUserInfo.cName];
    NSDictionary *address= @{@"titleText":@"所在地区",@"title_icon":@"所在地区icon",@"detailText":ValidStr(help_userManager.lawUserInfo.pName)?addressString:@"无",@"arrow_icon":@"进入"};
    
    NSString *jailString= help_userManager.lawUserInfo.jailName?help_userManager.lawUserInfo.jailName:@"";
    NSDictionary *jailName= @{@"titleText":@"监狱名称",@"title_icon":@"监狱名称icon",@"detailText":jailString,@"arrow_icon":@"进入"};
    

    _dataSource = @[name,sex,_penName,address,jailName];
    
    [self.accountTableView reloadData];
}


- (void)renderContents {
    [self.view addSubview:self.headImgView];
    
    UIView *bgview = [[UIView alloc] init];
    bgview.frame = CGRectMake(16,176,SCREEN_WIDTH-32,302);
    bgview.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    bgview.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:41/255.0 blue:108/255.0 alpha:0.18].CGColor;
    bgview.layer.shadowOffset = CGSizeMake(0,4);
    bgview.layer.shadowOpacity = 1;
    bgview.layer.shadowRadius = 12;
    bgview.layer.cornerRadius = 4;
    [self.view addSubview:bgview];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        //        make.size.mas_equalTo(CGSizeMake(44, CGRectGetHeight(navBar.frame)));
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(StatusHeight);
    }];
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = AppBaseTextFont1;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    NSString*userCenterAccount=@"账号信息";
    titleLabel.text = userCenterAccount;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backButton.mas_top);
        make.bottom.mas_equalTo(backButton.mas_bottom);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(150);
    }];
    
    self.accountTableView=[[UITableView alloc]init];
    self.accountTableView.frame =CGRectMake(0,0,SCREEN_WIDTH-32,302);
    //CGRectMake(0,_headImgView.bottom+50, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - kTabBarHeight-_headImgView.bottom-50);
    [self.accountTableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    self.accountTableView.mj_header.hidden = YES;
    self.accountTableView.mj_footer.hidden = YES;
    self.accountTableView.delegate = self;
    self.accountTableView.dataSource = self;
    [bgview addSubview:self.accountTableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell" forIndexPath:indexPath];
    cell.cellData = _dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
           
        }
            break;
        case 2:
        {
            if (ValidStr(self.pseudinym)) {

            } else {
                [self modifyPenName];
            }
        }
            break;
        case 3:
        {
           
        }
            break;
            
        default:
            break;
    }
}

-(void)backViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置笔名
-(void)modifyPenName {
    DPenNameViewController*penNameViewController=[[DPenNameViewController alloc]init];
   [self.navigationController pushViewController:penNameViewController animated:YES];
    
   // [self presentViewController:penNameViewController animated:YES completion:nil];
}


-(YYAnimatedImageView *)headImgView{
    if (!_headImgView) {
        
        UIImageView*bgView=[[UIImageView alloc]initWithImage: ImageNamed(@"账户信息底")];
        bgView.contentMode=UIViewContentModeScaleAspectFill;
        [self.view addSubview:bgView];
        bgView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 228);
        
        _headImgView = [YYAnimatedImageView new];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headImgView.userInteractionEnabled = YES;
        [_headImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewClick)]];
        _headImgView.size=CGSizeMake(60, 60);
        _headImgView.center=bgView.center;
       // _headImgView.frame = CGRectMake((self.view.width-90*Iphone6ScaleWidth)/2,64, 100*Iphone6ScaleWidth, 100*Iphone6ScaleWidth);
        ViewRadius(_headImgView, 30);
        [bgView addSubview:_headImgView];
        [_headImgView setImageWithURL:[NSURL URLWithString:help_userManager.curUserInfo.avatar] placeholder:[UIImage imageNamed:@"作者头像"]];
        

    }
    return _headImgView;
}

#pragma mark - TouchEvent
-(void)headViewClick {
    [PSAuthorizationTool checkAndRedirectCameraAuthorizationWithBlock:^(BOOL result) {
        if (result) {
            LLActionSheetView *alert = [[LLActionSheetView alloc]initWithTitleArray:@[@"拍照",@"从相册中选取"] andShowCancel:YES];
            alert.ClickIndex = ^(NSInteger index) {
                if (index == 1){
                    [self openCamera];
                }else if (index == 2){
                    [self openAlbum];
                }
            };
            [alert show];
        }
    }];
}
//打开相册
-(void)openAlbum{
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.edgesForExtendedLayout = UIRectEdgeNone;
    controller.navigationBar.tintColor = [UIColor grayColor];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.navigationBar.translucent = NO;
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    controller.mediaTypes = mediaTypes;
    controller.delegate = self;
    [self presentViewController:controller
                       animated:YES
                     completion:^(void){
                         NSLog(@"Picker View Controller is presented");
                     }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

//拍照
-(void)openCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.navigationBar.tintColor = [UIColor grayColor];
    controller.edgesForExtendedLayout = UIRectEdgeNone;
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    controller.mediaTypes = mediaTypes;
    controller.delegate = self;
    [self presentViewController:controller
                       animated:YES
                     completion:^(void){
                         NSLog(@"Picker View Controller is presented");
                     }];
    
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self uploadImage:portraitImg];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UploadImage
#define boundary @"6o2knFse3p53ty9dmcQvWAIx1zInP11uCfbm"
- (void)uploadImage:(UIImage *)image {
    //1 创建请求
    //NSString*urlSting=[NSString stringWithFormat:@"%@/files?type=PUBLIC",EmallHostUrl];
    NSString*urlSting=[NSString stringWithFormat:@"%@%@",EmallHostUrl,URL_upload_avatar];
    NSURL *url = [NSURL URLWithString:urlSting];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //    request.HTTPMethod = @"post";
    request.HTTPMethod = @"put";
    request.allHTTPHeaderFields = @{
                                    @"Content-Type":[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary]
                                    };
    NSData *compressData = [image compressWithLengthLimit:500.0f * 1024.0f];
    request.HTTPBody = [self makeBody:@"file" fileName:@"fileName" data:compressData];
    //UIImageJPEGRepresentation(self.consultaionImage, 0.1)
    NSString*token=[NSString stringWithFormat:@"Bearer %@",help_userManager.oathInfo.access_token];
    
    [request addValue:token forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSInteger code =httpResponse.statusCode;
        NSLog(@"平台%ld",code);
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if (data) {
            if (code==201||code==204) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                //                self.consultaionId=result[@"id"];
                self.headImgView.image = image;
                help_userManager.avatarImage = image;
                [PSTipsView showTips:@"头像修改成功"];
                KPostNotification(KNotificationMineDataChange, nil);
            } else {
                [PSTipsView showTips:@"头像修改失败"];
            }
        }
        else{
            [PSTipsView showTips:@"头像修改失败"];
        }
    }];
}

- (NSData *)makeBody:(NSString *)fieldName fileName:(NSString *)fileName data:(NSData *)fileData{
    NSMutableData *data = [NSMutableData data];
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"--%@\r\n",boundary];
    [str appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",fieldName,fileName];
    [str appendString:@"Content-Type: image/jpeg\r\n\r\n"];
    [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:fileData];
    NSString *tail = [NSString stringWithFormat:@"\r\n--%@--",boundary];
    [data appendData:[tail dataUsingEncoding:NSUTF8StringEncoding]];
    return [data copy];
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
