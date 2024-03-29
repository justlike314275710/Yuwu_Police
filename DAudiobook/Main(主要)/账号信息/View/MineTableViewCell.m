//
//  MineTableViewCell.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/6/12.
//  Copyright © 2017年 徐阳. All rights reserved.
//
#define KNormalSpace 12.0f

#import "MineTableViewCell.h"

@interface MineTableViewCell()

@property (nonatomic, strong) UIImageView *titleIcon;//标题图标
@property (nonatomic, strong) UILabel *titleLbl;//标题
@property (nonatomic, strong) UILabel *detaileLbl;//内容
@property (nonatomic, strong) UIImageView *arrowIcon;//右箭头图标
@property (nonatomic, strong) UIView *reddot;//小红点

@end

@implementation MineTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setCellData:(NSDictionary *)cellData{
    _cellData = cellData;
    if (cellData) {
        if (cellData[@"title_icon"]) {
            [self.titleIcon setImage:IMAGE_NAMED(cellData[@"title_icon"])];
            [_titleIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(KNormalSpace);
                make.centerY.mas_equalTo(self);
                make.width.height.mas_equalTo(17);
            }];
        }else{
            [self.titleIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(0);
                make.width.height.mas_equalTo(0);
            }];
        }
        NSInteger xleng = 0;
        if (cellData[@"titleText"]) {
            self.titleLbl.text = cellData[@"titleText"];
            CGSize titleSize = [self.titleLbl.text sizeWithFont:FontOfSize(15) constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
            xleng = titleSize.width;
        }
        
        if (cellData[@"detailText"]) {
            self.detaileLbl.text = cellData[@"detailText"];
            [_detaileLbl mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.titleLbl.mas_right).offset(10);
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(self.arrowIcon.mas_left).offset(- 10);
            }];
        }else{
            [_detaileLbl mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.titleLbl.mas_right).offset(0);
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(self.arrowIcon.mas_left).offset(0);
            }];
        }
        if ([cellData[@"reddot"] isEqualToString:@"0"]||!cellData[@"reddot"]) {
            [self.reddot mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.titleLbl.mas_right).offset(5);
                make.centerY.mas_equalTo(self);
                make.size.mas_equalTo(0);
            }];
            
        } else {
            [self.reddot mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(KNormalSpace+17+xleng+20);
                make.centerY.mas_equalTo(self);
                make.size.mas_equalTo(8);
            }];
        }
        
        if (cellData[@"arrow_icon"]) {
            [self.arrowIcon setImage:IMAGE_NAMED(@"开")];
            [_arrowIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-KNormalSpace);
                make.top.mas_equalTo(KNormalSpace);
                make.width.height.mas_equalTo(10);
                make.centerY.mas_equalTo(self);
            }];
            
        }else{
            [_arrowIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(KNormalSpace);
                make.width.height.mas_equalTo(0);
                make.centerY.mas_equalTo(self);
            }];
        }
    }
}

-(UIImageView *)titleIcon{
    if (!_titleIcon) {
        _titleIcon = [UIImageView new];
        [self addSubview:_titleIcon];
        [_titleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KNormalSpace);
            make.centerY.mas_equalTo(self);
            make.width.height.mas_equalTo(0);
        }];
    }
    return _titleIcon;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.font = FontOfSize(14) ;
        _titleLbl.textColor = [UIColor blackColor];
        [self addSubview:_titleLbl];
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleIcon.mas_right).offset(10);
            make.centerY.mas_equalTo(self);
        }];
    }
    return _titleLbl;
}

-(UILabel *)detaileLbl{
    if (!_detaileLbl) {
        _detaileLbl = [UILabel new];
        _detaileLbl.font =FontOfSize(13);
        _detaileLbl.textColor = AppColor(51, 51, 51);
        _detaileLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:_detaileLbl];
        
        [_detaileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLbl.mas_right).offset(10);
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self.arrowIcon.mas_left).offset(- 10);
        }];
    }
    return _detaileLbl;
}

- (UIView *)reddot {
    if (!_reddot) {
        _reddot = [UIView new];
        _reddot.layer.masksToBounds = YES;
        _reddot.backgroundColor = [UIColor redColor];
        _reddot.layer.cornerRadius =4 ;
        [self addSubview:_reddot];
        [_reddot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLbl.mas_right).offset(5);
            make.centerY.mas_equalTo(self);
            make.size.mas_equalTo(8);
        }];
        
    }
    return _reddot;
}

-(UIImageView *)arrowIcon{
    if (!_arrowIcon) {
        _arrowIcon = [UIImageView new];
        [self addSubview:_arrowIcon];
        
        [_arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-KNormalSpace);
            make.top.mas_equalTo(KNormalSpace);
            make.width.height.mas_equalTo(10);
            make.centerY.mas_equalTo(self);
        }];
    }
    return _arrowIcon;
}

@end
