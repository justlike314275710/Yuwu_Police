//
//  DMessageTableViewCell.h
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMessageTableViewCell : UITableViewCell
@property (nonatomic, strong, readonly) UIImageView*iconView;
@property (nonatomic, strong, readonly) UILabel *titleLable;
@property (nonatomic, strong, readonly) UILabel *dataLable;
@property (nonatomic, strong, readonly) UILabel *detailLable;
@property (nonatomic , strong) NSString *isNoticed;
@end
