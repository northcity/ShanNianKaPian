//
//  ShanNianTableViewCell.m
//  CutImageForYou
//
//  Created by chenxi on 2018/5/24.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "ShanNianTableViewCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define DEF_UICOLORFROMRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation ShanNianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label = [[UIView alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 50)];
    _label.backgroundColor = [UIColor whiteColor];
    _label.layer.cornerRadius= 6;
    _label.layer.shadowColor=[UIColor grayColor].CGColor;
    _label.layer.shadowOffset=CGSizeMake(0, 4);
    _label.layer.shadowOpacity=0.4f;
    _label.layer.shadowRadius=12;
    [self.contentView addSubview:_label];
    _label.alpha = 0.8;
    self.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:13.f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

