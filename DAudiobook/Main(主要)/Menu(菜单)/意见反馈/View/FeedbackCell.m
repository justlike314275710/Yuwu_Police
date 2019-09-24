//
//  FeedbackCell.m
//  PrisonService
//
//  Created by kky on 2018/12/18.
//  Copyright © 2018年 calvin. All rights reserved.
//

#import "FeedbackCell.h"

@implementation FeedbackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self renderContents];
    }
    return self;
}

- (void)renderContents {
    
//    _seleImg = [[UIImageView alloc] initWithFrame:CGRectMake(20,(self.contentView.height-14)/2, 14, 14)];
//    _seleImg.image = [UIImage imageNamed:@"writeFeednosel"];
//    [self.contentView addSubview:_seleImg];
    
    self.bgView=[UIView new];
    [self.contentView addSubview:self.bgView];
    self.bgView.backgroundColor=AppColor(235, 235, 235);
    self.bgView.frame=CGRectMake(15, 15, SCREEN_WIDTH-60, 30);
    ViewRadius(self.bgView, 15.0f);
    
    //(self.contentView.height-30)/2
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH-60, 30)];
    _titleLab.font = FontOfSize(12);
    _titleLab.numberOfLines = 0;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.textColor =[UIColor grayColor];
    [self.bgView addSubview:_titleLab];
    
//    _lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, self.contentView.height-3,SCREEN_WIDTH-50,2)];
//    _lineImg.image = [UIImage imageNamed:@"lineicon"];
//    [self.contentView addSubview:_lineImg];

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
