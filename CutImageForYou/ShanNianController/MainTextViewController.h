//
//  MainTextViewController.h
//  shijianjiaonang
//
//  Created by chenxi on 2018/3/12.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LZDataModel.h"

@interface MainTextViewController : UIViewController
@property(nonatomic,strong)UIView *MbgView;
@property(nonatomic,strong)UIView *bgViews;
@property(nonatomic,strong)UIImageView *bgImageView;

@property(nonatomic,strong)UILabel *navTitleLabel;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *doneBtn;

@property(nonatomic, strong)LZDataModel *model;

@end
