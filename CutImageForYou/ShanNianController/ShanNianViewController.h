//
//  ShanNianViewController.h
//  CutImageForYou
//
//  Created by chenxi on 2018/5/23.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSUInteger, XiaYiPaiClickActionTag) {
    XiaYiPaiClickActionShanChu =100, //Cell按钮
    XiaYiPaiClickActionRiLi,//添加银行卡
    XiaYiPaiClickActionShouCang, //错误加载
    XiaYiPaiClickActionBianJi,//进入详情按钮
    XiaYiPaiClickActionBaoCun//空页面按钮
};

@interface ShanNianViewController : UIViewController
@property (nonatomic, assign) BOOL isCanceled;
@property(nonatomic,strong)NSMutableArray *volumArray;
@property(nonatomic,strong)UIView *speakView;
@property(nonatomic,strong)UITextView *speakTextView;
@property(nonnull,strong)UIView *webFatherView;
@property (nonatomic,assign) BOOL isBeginOfSpeech;//Whether or not SDK has invoke the delegate methods of beginOfSpeech.

@end
