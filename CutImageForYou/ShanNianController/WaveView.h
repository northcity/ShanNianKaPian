//
//  WaveView.h
//  testWave1
//
//  Created by mac on 2017/9/11.
//  Copyright © 2017年 com.chinaums. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveView : UIView

@property (nonatomic,assign)CGFloat targetWaveHeight;

@property (nonatomic,strong)NSArray *circleArray;

@property (nonatomic) UIColor * waveColor;

@property (nonatomic) UIColor * waveColor2;

- (void)Animating;

- (void)stopAnimating;

//-(void)start;
//
//-(void)pause;
//
//-(void)stop;

@end
