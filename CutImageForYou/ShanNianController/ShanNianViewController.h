//
//  ShanNianViewController.h
//  CutImageForYou
//
//  Created by chenxi on 2018/5/23.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "ViewController.h"

@interface ShanNianViewController : UIViewController
@property (nonatomic, assign) BOOL isCanceled;

@property(nonatomic,strong)NSMutableArray *volumArray;

@property(nonatomic,strong)UIView *speakView;
@property(nonatomic,strong)UITextView *speakTextView;

@property(nonnull,strong)UIView *webFatherView;
@property (nonatomic,assign) BOOL isBeginOfSpeech;//Whether or not SDK has invoke the delegate methods of beginOfSpeech.

@end
