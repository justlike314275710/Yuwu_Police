//
//  DMenuModel.h
//  DAudiobook
//
//  Created by DUCHENGWEN on 2019/4/22.
//  Copyright © 2019 liujiliu. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
//Collection Article Opinion Password Phone number version logout
typedef NS_ENUM(NSUInteger, DMenuBusinessType) {
    KCollectionType=0,
    KArticleType=1,
    KOpinionType=2,
    KPasswordType=3,
    KPhonenumberType=4,
    KStorageType=5,
    KLogoutType=6,
    KVersionType=7, 
};


@interface DMenuModel : DBaseModel

/** 标题*/
@property (strong, nonatomic) NSString *title;
/** 图片*/
@property (strong, nonatomic) NSString *pictureImage;
/** 类型*/
@property (assign, nonatomic) DMenuBusinessType menuType;


/** 菜单界面列表 */
+(NSMutableArray*)getMenuModeldataArry;


@end

NS_ASSUME_NONNULL_END
