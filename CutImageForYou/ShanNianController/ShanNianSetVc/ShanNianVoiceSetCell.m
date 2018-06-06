//
//  ShanNianSetTableViewCell.m
//  CutImageForYou
//
//  Created by chenxi on 2018/6/6.
//  Copyright © 2018 chenxi. All rights reserved.
//

#import "ShanNianVoiceSetCell.h"

@implementation ShanNianVoiceSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label = [[UIView alloc]initWithFrame:CGRectMake(15, 5, ScreenWidth-30, 50)];
    _label.backgroundColor = [UIColor whiteColor];
    _label.layer.cornerRadius= 6;
    _label.layer.shadowColor=[UIColor grayColor].CGColor;
    _label.layer.shadowOffset=CGSizeMake(0, 4);
    _label.layer.shadowOpacity=0.4f;
    _label.layer.shadowRadius=12;
    [self.contentView addSubview:_label];
    _label.alpha = 0.8;
    self.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:13.f];
    [self createSubViews];
        [self updateSubViewsFrame];
    
}

- (void)createSubViews{
    //    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //    self.monthLabel.textColor = PNCColorWithHex(0x222222);
    //    self.monthLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    //    self.monthLabel.textAlignment = NSTextAlignmentLeft;
    //
    self.selectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ng_bps_fuceng_duigou"]];
//    self.selectedImageView.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(40), 10, 20, 20);
        self.selectedImageView.hidden = YES;
//    self.selectedImageView.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:self.monthLabel];
    [self.label addSubview:self.selectedImageView];
}

// Layout布局
- (void)updateSubViewsFrame {
    
        [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(kAUTOWIDTH(10));
            make.width.mas_offset(40);
            make.height.mas_offset(21);
        }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(kAUTOWIDTH(-22));
        make.width.mas_offset(20);
        make.height.mas_offset(20);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
        if (selected) {
            self.selectedImageView.hidden = NO;
            self.contentView.backgroundColor = PNCColorWithHex(0xF9FAFF);
    //        self.monthLabel.textColor = PNCColorWithHex(0x4586ff);
    
        }else{
            self.selectedImageView.hidden = YES;
    //        self.monthLabel.textColor = PNCColorWithHex(0x222222);
            self.contentView.backgroundColor = PNCColorWithHex(0xFFFFFF);
    
        }
    // Configure the view for the selected state
}



@end

