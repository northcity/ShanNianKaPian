//
//  ShanNianMuLuDetailViewController.h
//  CutImageForYou
//
//  Created by chenxi on 2018/6/8.
//  Copyright © 2018 chenxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZDataModel.h"
@interface ShanNianMuLuDetailViewController : UIViewController

@property(nonatomic, strong) LZDataModel *model;

@property(nonatomic,strong)UILabel *navTitleLabel;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *backBtn;

@property(nonatomic,strong)UIView *MbgView;
@property(nonatomic,strong)UIView *bgViews;
@property(nonatomic,strong)UIImageView *bgImageView;

@end
