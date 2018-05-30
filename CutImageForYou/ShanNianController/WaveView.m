//
//  WaveView.m
//  testWave1
//
//  Created by mac on 2017/9/11.
//  Copyright © 2017年 com.chinaums. All rights reserved.
//

#import "WaveView.h"
@interface WaveView ()
{
    //屏幕的总宽度
    CGFloat totalWidth;
    //波浪的宽度
    CGFloat waveWidth;
    //波浪的高度
    CGFloat waveHeight;
    //位移的频率，因为在2PI的时候会是一个周期，所以这样算看起来在动
    CGFloat phase;
    CGFloat phaseShift;
    //浪的最大振幅
    CGFloat maxWaveHeight;
    //波浪的数量
    CGFloat numberOfWaves;
    //振幅
    CGFloat amplitude;
    //密度
    CGFloat density;
    //view的中间
    CGFloat waveMid;

    //频率 控制在屏幕上波有几个
    CGFloat frequency;
    //一开始的振幅
    CGFloat idleAmplitude;
    
    //保存layer的数组
    NSMutableArray *layers;
    //保存paths的数组
    NSMutableArray * paths;
    
    
}

@property (nonatomic,strong)CADisplayLink *displayLink;


@end



@implementation WaveView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        layers = [[NSMutableArray alloc]init];
        paths = [[NSMutableArray alloc]init];
        phase = 0;
        phaseShift = -0.125f;
        waveWidth = self.frame.size.width;
        waveHeight = self.frame.size.height;
        waveMid = waveWidth/2;
        maxWaveHeight = waveHeight-4;
        idleAmplitude = 0.01f;
        //密度 就是x每次加多少
        density = 1;
        //振幅的初始值为1.0
        amplitude = 1.0;
        frequency = 1.2f;
        phase = 0.0;
        //波浪的数量
        numberOfWaves = 3;
        self.waveColor = PNCColorWithHexA(0x54bcfa, 1);
        self.waveColor2 = PNCColorWithHexA(0x4d91fd, 1);
        [self setUp];
        
    }
    return self;
}

-(void)setUp
{
    for (int i=0; i<numberOfWaves; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.shadowColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 1;
        shapeLayer.lineCap = kCALineCapButt; //线条拐角
        shapeLayer.lineJoin = kCALineJoinRound; //终点处理
        if (i==0) {
            shapeLayer.lineWidth = 1.5;
        }else{
            shapeLayer.lineWidth = 0.5;
        }
        CGFloat progress = 1.0f - (CGFloat)i / numberOfWaves;
        CGFloat multiplier = MIN(1.0, (progress / 3.0f * 2.0f) + (1.0f / 3.0f));
        
        UIColor *color = [self.waveColor colorWithAlphaComponent:(i == 0 ? 1.0 : 0.3 * i)];
        UIColor *color2 = [self.waveColor2 colorWithAlphaComponent:(i == 0 ? 1.0 : 0.3 * i)];
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;//color.CGColor;
        
        //设置渐变颜色
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        // 设置渐变的方向
        gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
        gradientLayer.endPoint = CGPointMake(1.0f, 0.0f);
        gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)color.CGColor,(__bridge id)color2.CGColor,(__bridge id)[UIColor whiteColor].CGColor];
//        gradientLayer.locations = @[[NSNumber numberWithInt:0.2],[NSNumber numberWithInt:0.8],[NSNumber numberWithInt:1]];
        // 这个是使得颜色像素均匀变化（仅有一个选择）
        gradientLayer.type = kCAGradientLayerAxial;
        [self.layer addSublayer:gradientLayer];
        gradientLayer.mask = shapeLayer;
        
        [layers addObject:shapeLayer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [paths addObject:path];
        
    }
    
}

-(void)setTargetWaveHeight:(CGFloat)targetWaveHeight
{
    _targetWaveHeight = targetWaveHeight;
    
}


- (void)Animating {
    self.displayLink.paused = false;
    self.hidden=NO;
    self.alpha = 1;
}

- (void)stopAnimating {
    [UIView animateWithDuration:1 animations:^{
        _targetWaveHeight = 0;
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self disPlayWave];
        self.hidden = YES;
        self.displayLink.paused = YES;
    }];
  
}

-(CADisplayLink *)displayLink
{
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(disPlayWave)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}


-(void)disPlayWave
{
    // 移动
    phase += phaseShift;
    UIGraphicsBeginImageContext(self.frame.size);
    phase += phaseShift;
    amplitude = fmax(_targetWaveHeight, idleAmplitude);
    for(int i=0;i<numberOfWaves;i++)
    {
        UIBezierPath *path = [paths objectAtIndex:i];
        [path removeAllPoints];
        //一开始要让线分开
        CGFloat progress = 1.0f - (CGFloat)i*0.6/numberOfWaves;
        CGFloat normalAmplitude = (1.5 * progress - 0.5)*amplitude;
        
        CGFloat x = 0;
        while (x<waveWidth+density) {
            
            CGFloat scaling = -pow(x / waveMid  - 1, 4) + 1;
            //将曲线函数翻转(加负号)后上移1(+1)即可得到最终弹性曲线
            CGFloat y = scaling * maxWaveHeight * normalAmplitude * sinf( 3*M_PI *(x / waveWidth) * frequency + phase +(1+0.25*i)*M_PI) + (waveHeight * 0.5) ;//(1+0.25*i)*M_PI
            if (x==0) {
                [path moveToPoint:CGPointMake(x, y)];
            }else{
                [path addLineToPoint:CGPointMake(x+i, y)];
            }
            x += density;
            
        }
        CAShapeLayer *layer = layers[i];
        layer.path = path.CGPath;
        
//        if (i==0) {
//            layer.fillColor = [UIColor redColor].CGColor;
//        }
    }
    
    UIGraphicsEndImageContext();
    
}



-(void)dealloc
{
    [self.displayLink invalidate];
}

@end
