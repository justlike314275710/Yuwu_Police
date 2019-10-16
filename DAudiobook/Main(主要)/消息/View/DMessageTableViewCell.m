//
//  DMessageTableViewCell.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DMessageTableViewCell.h"

@implementation DMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self renderContents];
    }
    return self;
}

- (void)renderContents {
    CGFloat sidePadding = 15;
    CGFloat verticalPadding = 10;
   

    UIView *bgview = [[UIView alloc] init];
    [self addSubview:bgview];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-sidePadding);
        make.left.mas_equalTo(sidePadding);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
    }];
    bgview.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    bgview.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:41/255.0 blue:108/255.0 alpha:0.18].CGColor;
    bgview.layer.shadowOffset = CGSizeMake(0,4);
    bgview.layer.shadowOpacity = 1;
    bgview.layer.shadowRadius = 12;
    bgview.layer.cornerRadius = 4;

    
    
    _titleLable=[UILabel new];
    _titleLable.text=@"文章审核";
    _titleLable.textColor=AppColor(51, 51, 51);
    _titleLable.font=FontOfSize(14);
    [bgview addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sidePadding);
        make.top.mas_equalTo(verticalPadding);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(120);
    }];
    
    _dataLable=[UILabel new];
    _dataLable.text=@"3月13日 19:30";
    _dataLable.font=FontOfSize(10);
    _dataLable.textColor=AppColor(153, 153, 153);
    [bgview addSubview:_dataLable];
    [_dataLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-30);
        make.top.mas_equalTo(verticalPadding);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(120);
    }];
    _dataLable.textAlignment=NSTextAlignmentRight;
    
    
    _detailLable=[UILabel new];
    _detailLable.text=@"您于2019-07-12 19:12提交的认证已通过审核。";
    _detailLable.font=FontOfSize(11);
    _detailLable.textColor=AppColor(102, 102, 102);
    [bgview addSubview:_detailLable];
    [_detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sidePadding);
        make.right.mas_equalTo(self.mas_right).mas_offset(-30);
        make.top.mas_equalTo(self.titleLable.mas_bottom).offset(5);
        make.height.mas_equalTo(30);
    }];
    _detailLable.numberOfLines=0;
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
