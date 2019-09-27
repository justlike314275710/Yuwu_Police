//
//  HAccountViewModel.h
//  DAudiobook
//
//  Created by kky on 2019/9/27.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "HpBaseLogic.h"
typedef void (^SucessImageBlock)(UIImage *image);
NS_ASSUME_NONNULL_BEGIN

@interface HAccountViewModel : HpBaseLogic

//上传头像
//- (void)uploadUserAvatarImageCompleted:(CheckDataCallback)callback;

//获取我的头像
-(void)getUserAvatarImageCompleted:(SucessImageBlock)completedCallback
                            failed:(RequestDataFailed)failedCallback;

//获取用户头像
-(void)getAvatarImageUserName:(NSString *)username Completed:(SucessImageBlock)completedCallback
                       failed:(RequestDataFailed)failedCallback;

@end

NS_ASSUME_NONNULL_END
