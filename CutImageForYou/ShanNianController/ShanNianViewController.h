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
    XiaYiPaiClickActionShanChu =100, //删除
    XiaYiPaiClickActionRiLi,//日历
    XiaYiPaiClickActionShouCang, //收藏
    XiaYiPaiClickActionBianJi,//编辑
    XiaYiPaiClickActionBaoCun//保存
};

typedef NS_ENUM(NSUInteger, ShangYiPaiClickActionTag) {
    ShangYiPaiClickActionDaiban =1000, //待办
    ShangYiPaiClickActionDaiFaXiaoXi,//发消息
    ShangYiPaiClickActionJiShi, //记事
    ShangYiPaiClickActionLiaoTian,//聊天
    ShangYiPaiClickActionLingGan//灵感
};

@interface ShanNianViewController : UIViewController
@property(nonatomic, assign) BOOL isBeginOfSpeech;//Whether or not SDK has invoke the delegate methods of beginOfSpeech.
@property(nonatomic, strong) NSMutableArray *volumArray;//用来装声音大小的数组，现在应该没用了
@property(nonatomic, strong) UIImageView *bgImageView;//锤子桌面截图，加载情怀模式时用
@property(nonatomic, strong) UITextView *speakTextView;//弹出的显示识别文字的视图
@property(nonatomic, strong) UIView *webFatherView;//弹出的webView的父视图
@property(nonatomic, strong) UIView *speakView;//弹出的识别文字视图的父视图
@property(nonatomic, strong) UIView *shangViewLineView;//弹出视图分割线
@property(nonatomic, strong) NSData *pcmData;//用于存储录音文件的二进制
@property(nonatomic, copy) NSString *nowColor;//当前弹出视图的颜色标记
@property(nonatomic, assign) BOOL isCanceled;//语音识别是否结束
@property(nonatomic, strong) UILabel *sloginLabel;//签名Label



@end
