//
//  ShanNianTableViewCell.h
//  CutImageForYou
//
//  Created by chenxi on 2018/5/24.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShanNianTableViewCell : UITableViewCell
@property(nonatomic,strong)UIView * label;

@property(nonatomic,strong)UIButton *playBtn;

@property(nonatomic,copy)dispatch_block_t cellPlayBlock;
@end
