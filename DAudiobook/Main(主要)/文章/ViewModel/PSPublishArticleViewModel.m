//
//  PSPublishArticleViewModel.m
//  PrisonService
//
//  Created by kky on 2019/9/18.
//  Copyright © 2019年 calvin. All rights reserved.
//

#import "PSPublishArticleViewModel.h"
#import "PSJSONTool.h"
#import "NSString+emoji.h" 
@interface PSPublishArticleViewModel ()

@end

@implementation PSPublishArticleViewModel
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

//查找笔名
//{"msg":"获取笔名成功","code":200,"data":{"familyId":null,"disabledReason":null,"accountName":null,"isEnabled":1,"id":4,"pseudonym":"吴小可爱"}}
- (void)findPenNameCompleted:(RequestDataCompleted)completedCallback
                      failed:(RequestDataFailed)failedCallback{
    NSString*urlString=[NSString stringWithFormat:@"%@%@",ServerUrl,URL_Article_findPolicePenName];
    NSString *token = NSStringFormat(@"Bearer %@",help_userManager.oathInfo.access_token);
    [PPNetworkHelper setValue:token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:urlString parameters:nil success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 200) {
            PSPublicArticleModel *model = [PSPublicArticleModel modelWithJSON:responseObject[@"data"]];
            self.model = model;
            completedCallback(responseObject);
        }
        
    } failure:^(NSError *error) {
        if (failedCallback) {
            failedCallback(error);
        }
    }];
}

//发布文章
#define boundary @"11"
- (void)publishArticleCompleted:(RequestDataCompleted)completedCallback
                         failed:(RequestDataFailed)failedCallback {
    
    NSString*urlString=[NSString stringWithFormat:@"%@%@",ServerUrl,URL_Article_publishPoliceArticle];
    NSString *articleid = self.id?self.id:@"";
    
    NSDictionary *parameters = @{@"id":articleid,@"title":self.title,@"content":self.content,@"articleType":self.articleType,@"penName":self.penName};
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableString *bodyContent = [NSMutableString string];
    for(NSString *key in parameters.allKeys){
        id value = [parameters objectForKey:key];
             [bodyContent appendFormat:@"--%@\r\n",boundary];
             [bodyContent appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
             [bodyContent appendFormat:@"%@\r\n",value];
        }
    [bodyContent appendFormat:@"--%@--\r\n",boundary];
    NSData *bodyData=[bodyContent dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request  = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request addValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%zd",bodyData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    
    NSString *token = NSStringFormat(@"Bearer %@",help_userManager.oathInfo.access_token);
    [request addValue:token forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"请求的长度%@",[NSString stringWithFormat:@"%zd",bodyData.length]);
    __autoreleasing NSError *error=nil;
    __autoreleasing NSURLResponse *response=nil;
    NSLog(@"输出Bdoy中的内容>>\n%@",[[NSString alloc]initWithData:bodyData encoding:NSUTF8StringEncoding]);
    NSData *reciveData= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(error){
                 NSLog(@"出现异常%@",error);
                if (failedCallback) {
                    failedCallback(error);
                }
            }else{
                NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
                if(httpResponse.statusCode==200){
                    NSLog(@"服务器成功响应!>>%@",[[NSString alloc]initWithData:reciveData encoding:NSUTF8StringEncoding]);
                    NSString *dataString = [[NSString alloc]initWithData:reciveData encoding:NSUTF8StringEncoding];
                    NSDictionary *dataDic = [PSJSONTool dictionaryWithJsonString:dataString];
                    NSInteger code = [[dataDic objectForKey:@"code"] integerValue];
                    //        {"msg":"存在敏感字","code":1586,"data":{"words":["测试","刘德华"]}}
                    if (code==1586) {
                        NSDictionary *responseDic =[dataDic objectForKey:@"data"];
                        self.words =  [responseDic valueForKey:@"words"];
                        NSLog(@"%@",_words);
                    }
                    if (completedCallback) {
                        completedCallback(dataDic);
                    }
                
                }else{
                    NSLog(@"服务器返回失败>>%@",[[NSString alloc]initWithData:reciveData encoding:NSUTF8StringEncoding]);
                    if (failedCallback) {
                        failedCallback(error);
                    }
                 }
            
        }

    
    /*
    self.publishFamilyArticleRequest = [PSPublishFamilyArticleRequest new];
    self.publishFamilyArticleRequest.id = self.type==PSPublishArticle?@"":self.id;
    self.publishFamilyArticleRequest.title = self.title;
    self.publishFamilyArticleRequest.content = self.content;
    self.publishFamilyArticleRequest.articleType = self.articleType; //文章类型(1为互动文章，2为连载小说)
    self.publishFamilyArticleRequest.penName = self.penName;
    [self.publishFamilyArticleRequest send:^(PSRequest *request, PSResponse *response) {
//        {"msg":"存在敏感字","code":1586,"data":{"words":["测试","刘德华"]}}
        if (response.code==1586) {
            NSString *dataString = [response description];
            NSDictionary *responseDic = [PSJSONTool dictionaryWithJsonString:dataString];
            NSDictionary *dic = [responseDic valueForKey:@"data"];
            self.words =  [dic valueForKey:@"words"];
            NSLog(@"%@",_words);
        }
        if (completedCallback) {
            completedCallback(response);
        }
    } errorCallback:^(PSRequest *request, NSError *error) {
        if (failedCallback) {
            failedCallback(error);
        }
    }];
     */
    
}

- (void)checkDataWithCallback:(CheckDataCallback)callback {
    if (self.penName.length<=0&&self.title.length<=0) {
        callback(NO,@"请输入作者笔名/标题");
        return;
    }
    if (self.penName.length<=0)
    {
        callback(NO,@"请输入作者笔名");
    } else if (self.penName.length>6&&self.editPenName)
    {
        callback(NO,@"作者笔名不能超过6个字");
    } else if (self.title.length<=0)
    {
        callback(NO,@"请输入文章标题");
    } else if (self.title.length>20)
    {
        callback(NO,@"文章标题不能超过20个字");
    } else if (self.content.length<100)
    {
        callback(NO,@"文章内容字数限制为100-20000");
    } else if (self.content.length>20000)
    {
        callback(NO,@"文章内容字数限制为100-20000");
    } else if ([NSString hasEmoji:self.content]||[NSString stringContainsEmoji:self.content])
    {
        callback(NO,@"文章内容不能包含表情符号");
    }else if ([NSString hasEmoji:self.title]||[NSString stringContainsEmoji:self.title])
    {
        callback(NO,@"文章标题不能包含表情符号");
    }else if ([NSString hasEmoji:self.penName]||[NSString stringContainsEmoji:self.penName])
    {
        callback(NO,@"笔名不能包含表情符号");
    }
    else {
        callback(YES,nil);
    }
    
}

#pragma mark - 获取这个字符串中的所有xxx的所在的index
- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:3];
    
    if (findText == nil && [findText isEqualToString:@""])
    {
        
        return nil;
        
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0)
    {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++)
        {
            
            if (0 == i)
            {//去掉这个xxx
                
                location = rang.location + rang.length;
                
                length = text.length - rang.location - rang.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            else
            {
                
                location = rang1.location + rang1.length;
                
                length = text.length - rang1.location - rang1.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            
            //在一个range范围内查找另一个字符串的range
            
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0)
            {
                
                break;
                
            }
            else//添加符合条件的location进数组
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            
        }
        
        return arrayRanges;
        
    }
    
    return nil;
    
}


#pragma mark ------ 上传头像 POST /file/uploadHead
- (void)uploadHeadImage:(UIImage *)image usrId:(NSString *)usrId onSuccess:(void (^)(NSDictionary *dict))onSuccess onFailure:(void(^)(NSError *error))onFailure {
    
    //BaseWebAddr：服务器地址
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",ServerUrl,URL_Article_publishPoliceArticle];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //在此声明一个字符串常量,代替下面的 BOUNDARY 字符串
    //   NSString * const POST_BOUNDS = @"----iOSKitFormBoundarycIO0B6mmsXU6koBg";
    
    NSData *imageData;
    NSString *imageFormat;
    if (UIImagePNGRepresentation(image) != nil) {
        imageFormat = @"Content-Type: image/png \r\n";
        imageData = UIImagePNGRepresentation(image);
        
    }else{
        imageFormat = @"Content-Type: image/jpeg \r\n";
        imageData = UIImageJPEGRepresentation(image, 1.0);
        
    }
    
    NSMutableURLRequest *request  = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    //设置请求实体
    NSMutableData *body = [NSMutableData data];
    ///文件参数
    [body appendData:[self getDataWithString:@"--BOUNDARY\r\n" ]];
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",@"upload",usrId];
    [body appendData:[self getDataWithString:disposition ]];
    [body appendData:[self getDataWithString:imageFormat]];
    [body appendData:[self getDataWithString:@"\r\n"]];
    [body appendData:imageData];
    [body appendData:[self getDataWithString:@"\r\n"]];
    
    //普通参数
    [body appendData:[self getDataWithString:@"--BOUNDARY\r\n" ]];
    //上传参数需要key
    NSString *dispositions = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",@"uid"];
    [body appendData:[self getDataWithString:dispositions ]];
    [body appendData:[self getDataWithString:@"\r\n"]];
    [body appendData:[self getDataWithString:usrId]];
    [body appendData:[self getDataWithString:@"\r\n"]];
    
    //参数结束
    [body appendData:[self getDataWithString:@"--BOUNDARY--\r\n"]];
    request.HTTPBody = body;
    
    //设置请求体长度
    NSInteger length = [body length];
    [request setValue:[NSString stringWithFormat:@"%ld",length] forHTTPHeaderField:@"Content-Length"];
    //设置 POST请求文件上传
    [request setValue:@"multipart/form-data; boundary=BOUNDARY" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession alloc]  dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSJSONSerialization *object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dict = (NSDictionary *)object;
        NSLog(@"=====%@",[dict objectForKey:@"success"]);
    }];
    //开始任务
    [dataTask resume];
    
}

-(NSData *)getDataWithString:(NSString *)string{
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
    
}





@end
