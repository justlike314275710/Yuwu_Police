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
    CGFloat sidePadding = 5;
    CGFloat verticalPadding = 10;
    
    _iconView=[[UIImageView alloc]initWithImage:ImageNamed(@"互动平台列表icon")];
    [self addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sidePadding);
        make.top.mas_equalTo(verticalPadding);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(34);
    }];
    
    _titleLable=[UILabel new];
    _titleLable.text=@"文章审核";
    _titleLable.textColor=AppColor(51, 51, 51);
    _titleLable.font=FontOfSize(14);
    [self addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_iconView.mas_right).mas_offset(5);
        make.top.mas_equalTo(verticalPadding);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(70);
    }];
    
    _dataLable=[UILabel new];
    _dataLable.text=@"3月13日 19:30";
    _dataLable.font=FontOfSize(10);
    _dataLable.textColor=AppColor(153, 153, 153);
    [self addSubview:_dataLable];
    [_dataLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-5);
        make.top.mas_equalTo(verticalPadding);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(70);
    }];
    
    
    _detailLable=[UILabel new];
    _detailLable.text=@"您于2019-07-12 19:12提交的认证已通过审核。";
    _detailLable.font=FontOfSize(11);
    [self addSubview:_detailLable];
    [_detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(5);
        make.top.mas_equalTo(self.titleLable.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(SCREEN_WIDTH-34-3*15);
    }];
    
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
