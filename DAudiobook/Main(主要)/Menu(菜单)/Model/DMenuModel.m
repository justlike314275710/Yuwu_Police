//
//  DMenuModel.m
//  DAudiobook
//
//  Created by DUCHENGWEN on 2019/4/22.
//  Copyright © 2019 liujiliu. All rights reserved.
//

#import "DMenuModel.h"

@implementation DMenuModel

+(NSMutableArray*)getMenuModeldataArry{
    NSMutableArray*dataArry=[NSMutableArray array];
    

    DMenuModel*arraymodelA      =[DMenuModel new];
    arraymodelA.title           =@"我的收藏";
    arraymodelA.pictureImage    =@"我的收藏icon";
    arraymodelA.menuType        =KCollectionType;
    [dataArry addObject:arraymodelA];
    
    DMenuModel*arraymodelB      =[DMenuModel new];
    arraymodelB.title           =@"我的文章";
    arraymodelB.pictureImage    =@"我的文章";
    arraymodelB.menuType        =KArticleType;
    [dataArry addObject:arraymodelB];
    
    DMenuModel*arraymodelC      =[DMenuModel new];
    arraymodelC.title           =@"意见反馈";
    arraymodelC.pictureImage    =@"意见反馈icon";
    arraymodelC.menuType        =KOpinionType;
    [dataArry addObject:arraymodelC];
    
    DMenuModel*arraymodelD      =[DMenuModel new];
    arraymodelD.title           =@"重置密码";
    arraymodelD.pictureImage    =@"重置密码";
    arraymodelD.menuType        =KPasswordType;
    [dataArry addObject:arraymodelD];
    
    DMenuModel*arraymodelE      =[DMenuModel new];
    arraymodelE.title           =@"更改手机号码";
    arraymodelE.pictureImage    =@"手机号码";
    arraymodelE.menuType        =KPhonenumberType;
    [dataArry addObject:arraymodelE];
    
    DMenuModel*arraymodelF      =[DMenuModel new];
    arraymodelF.title           =@"版本更新";
    arraymodelF.pictureImage    =@"版本更新";
    arraymodelF.menuType        =KVersionType;
    [dataArry addObject:arraymodelF];
    
    DMenuModel*arraymodelG      =[DMenuModel new];
    arraymodelG.title           =@"退出登录";
    arraymodelG.pictureImage    =@"退出icon";
    arraymodelG.menuType        =KLogoutType;
    [dataArry addObject:arraymodelG];
    
     return dataArry;
    
}




@end
