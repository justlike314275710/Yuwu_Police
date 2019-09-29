//
//  DTitleTableViewCell.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/28.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DTitleTableViewCell.h"

@implementation DTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *bgview = [[UIView alloc] init];
        bgview.frame = CGRectMake(15,0,SCREEN_WIDTH-30,64);
        bgview.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        bgview.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:41/255.0 blue:108/255.0 alpha:0.18].CGColor;
        bgview.layer.shadowOffset = CGSizeMake(0,4);
        bgview.layer.shadowOpacity = 1;
        bgview.layer.shadowRadius = 12;
        bgview.layer.cornerRadius = 4;
        [self addSubview:bgview];
        
        [bgview addSubview:self.titleLable];
        [bgview addSubview:self.dataButton];
        [bgview addSubview:self.hotButton];
        [bgview addSubview:self.nameLable];
    }
    return self;
    
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//
//
//    }
//    return self;
}

//CGRectGetMaxY(_rightImage.frame)+10
- (UILabel *)titleLable{
    if (!_titleLable) {
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5 + 10, SCREEN_WIDTH-40, 20)];
      
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.text=@"今夜的月光超载太重照着我一夜哄不成梦每根";
        _titleLable.textColor=[UIColor blackColor];
    }
    return _titleLable;
}


- (UIButton *)dataButton{
    if (!_dataButton) {
        self.dataButton =[[UIButton alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(_titleLable.frame)+10, 110, 10)];
        [_dataButton setImage:ImageNamed(@"时间") forState: UIControlStateNormal];
        [_dataButton setTitle:@"  2019-07-10 11:11:11" forState:UIControlStateNormal];
        _dataButton.titleLabel.font=FontOfSize(8);
        [_dataButton setTitleColor:AppColor(153, 153, 153) forState:UIControlStateNormal];
    }
    return _dataButton;
}

- (UIButton *)hotButton{
    if (!_hotButton) {
        self.hotButton =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_dataButton.frame)+15, CGRectGetMaxY(_titleLable.frame)+10, 50, 10)];
        
        [_hotButton setImage:ImageNamed(@"未赞") forState: UIControlStateNormal];
        [_hotButton setTitle:@"  1.6w" forState:UIControlStateNormal];
        _hotButton.titleLabel.font=FontOfSize(8);
        [_hotButton setTitleColor:AppColor(153, 153, 153) forState:UIControlStateNormal];
    }
    return _hotButton;
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_hotButton.frame)+15, CGRectGetMaxY(_titleLable.frame)+10, 100, 10)];
        _nameLable.text=@"吴彦祖";
        _nameLable.textColor=AppColor(151, 151, 151);
        _nameLable.textAlignment=NSTextAlignmentLeft;
        _nameLable.font=FontOfSize(8);
    }
    return _nameLable;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
