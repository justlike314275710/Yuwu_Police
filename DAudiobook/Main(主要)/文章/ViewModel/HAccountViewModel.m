//
//  HAccountViewModel.m
//  DAudiobook
//
//  Created by kky on 2019/9/27.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "HAccountViewModel.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
@implementation HAccountViewModel
//获取用户头像
-(void)getUserAvatarImageCompleted:(SucessImageBlock)completedCallback
                            failed:(RequestDataFailed)failedCallback{

    NSString *access_token = help_userManager.oathInfo.access_token;
    NSString *token = NSStringFormat(@"Bearer %@",access_token);
     AFHTTPSessionManager  *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/png",@"image/jpeg",nil];
    
    NSString*urlSting=[NSString stringWithFormat:@"%@%@",EmallHostUrl,URL_get_userAvatar];
    
    [manager GET:urlSting parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *imageData = [responseObject mutableCopy];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image&&completedCallback) {
            completedCallback(image);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (data) {
            id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",body);
        }
        if (failedCallback) {
            failedCallback(error);
        }
    }];
}

//- (NSData *)makeBody:(NSString *)fieldName fileName:(NSString *)fileName data:(NSData *)fileData{
//    NSMutableData *data = [NSMutableData data];
//    NSMutableString *str = [NSMutableString string];
//    [str appendFormat:@"--%@\r\n",boundary];
//    [str appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",fieldName,fileName];
//    [str appendString:@"Content-Type: image/jpeg\r\n\r\n"];
//    [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
//    [data appendData:fileData];
//    NSString *tail = [NSString stringWithFormat:@"\r\n--%@--",boundary];
//    [data appendData:[tail dataUsingEncoding:NSUTF8StringEncoding]];
//    return [data copy];
//}

//获取用户头像
-(void)getAvatarImageUserName:(NSString *)username Completed:(SucessImageBlock)completedCallback
                       failed:(RequestDataFailed)failedCallback {
    
    NSString *access_token = help_userManager.oathInfo.access_token;
    NSString *token = NSStringFormat(@"Bearer %@",access_token);
    AFHTTPSessionManager  *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/png",@"image/jpeg",nil];
    
    NSString*urlSting=[NSString stringWithFormat:@"%@%@%@",EmallHostUrl,URL_get_Avatar,username];
    urlSting = [urlSting stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:urlSting parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *imageData = [responseObject mutableCopy];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image&&completedCallback) {
            completedCallback(image);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (data) {
            id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",body);
        }
        if (failedCallback) {
            failedCallback(error);
        }
    }];
    
}
@end
