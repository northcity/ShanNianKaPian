//
//  ShanNianMuLuViewController.h
//  CutImageForYou
//
//  Created by chenxi on 2018/5/24.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaveView.h"
@interface ShanNianMuLuViewController : UIViewController

@property(nonatomic,assign)BOOL isPresnted;
@property (nonatomic,strong) WaveView *waveView;

@property(nonatomic,strong)UILabel *navTitleLabel;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *backBtn;


@end
