//
//  ShanNianViewController.h
//  CutImageForYou
//
//  Created by chenxi on 2018/5/23.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "ViewController.h"
#import "IFlyMSC/IFlyMSC.h"

@class PopupView;
@class IFlyDataUploader;
@class IFlySpeechRecognizer;
@class IFlyPcmRecorder;

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

@property(nonatomic,strong)UIView *shangViewLineView;
@property(nonatomic,strong)NSData *pcmData;

@end
