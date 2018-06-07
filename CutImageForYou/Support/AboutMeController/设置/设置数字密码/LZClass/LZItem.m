//
//  LZItem.m
//  LZPasswordView
//
//  Created by Artron_LQQ on 2016/10/19.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZItem.h"



static CGFloat itemLineHeight = 1.0;

@implementation LZItem

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _style = LZItemStyleLine;
        self.bounds = CGRectMake(0, 0, itemCicleRadius, itemCicleRadius);
//        self.layer.cornerRadius = itemCicleRadius/2;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setStyle:(LZItemStyle)style {
    
    _style = style;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    switch (self.style) {
        case LZItemStyleLine:
            [self drawLine];
            break;
        case LZItemStyleCicle:
            [self drawCicle];
            break;
            
        default:
            break;
    }
}

- (void)drawCicle {
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];

//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 8, 8) cornerRadius:8];
//
//    UIColor *fillColor = [UIColor blackColor];
//    [fillColor set];
//    [path fill];
//    [path stroke];
    
//    UIColor *color = [UIColor redColor];
//    [color set]; //设置线条颜色
//
//    UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 10, 10)];
//
//    path.lineWidth = 5.0;
//    path.lineCapStyle = kCGLineCapRound; //线条拐角
//    path.lineJoinStyle = kCGLineJoinRound; //终点处理
//
//    [path stroke];
    

    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.name = @"Radius";
    CGFloat lineWidth =  10;
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = lineWidth;
    path.lineCapStyle = kCGLineCapButt;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - lineWidth)/2;
    
    CGFloat startAngle = -((float)M_PI)/7; //
    CGFloat endAngle = ((float)M_PI)-startAngle ;
    
    [[UIColor blackColor] set];
    
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    [path stroke];
    
    [path closePath];
    
}

- (void)drawLine {
    
    CGRect rect = CGRectMake((itemCicleRadius - itemLineWidth)/2.0, (itemCicleRadius - itemLineHeight)/2.0, itemLineWidth, itemLineHeight);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinBevel;
    
    UIColor *fileColor = [UIColor blackColor];
    [fileColor set];
    [path fill];
    
    [path stroke];
}

@end
