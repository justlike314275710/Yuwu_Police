//
//  DTitleTableViewCell.h
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/28.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPButton.h"
@interface DTitleTableViewCell : UITableViewCell
@property (nonatomic , strong) UILabel *titleLable;
@property (nonatomic , strong) UIButton *hotButton;
@property (nonatomic , strong) UIButton *dataButton;
@property (nonatomic , strong) UILabel *nameLable;



- (void)configResultDoubleViewCellWithFirstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle;

@end
