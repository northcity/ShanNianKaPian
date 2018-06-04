//
//  BCShanNianKaPianManager.m
//  CutImageForYou
//
//  Created by chenxi on 2018/6/4.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "BCShanNianKaPianManager.h"
#import <StoreKit/StoreKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>
@implementation BCShanNianKaPianManager

//振动马达手感好
+ (void)maDaKaiShiZhenDong{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        if (@available(iOS 10.0, *)) {
            UIImpactFeedbackGenerator*impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
            [impactLight impactOccurred];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (@available(iOS 10.0, *)) {
                UIImpactFeedbackGenerator*impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleMedium];
                [impactLight impactOccurred];
            }
        });
    }else{
        AudioServicesPlaySystemSound(1519);
    }
}

+ (void)maDaQingZhenDong{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        if (@available(iOS 10.0, *)) {
            UIImpactFeedbackGenerator*impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
            [impactLight impactOccurred];
        }
    }else{
        AudioServicesPlaySystemSound(1519);
    }
}

+ (void)maDaZhongJianZhenDong{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        if (@available(iOS 10.0, *)) {
            UIImpactFeedbackGenerator*impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleMedium];
            [impactLight impactOccurred];
        }
    }else{
        AudioServicesPlaySystemSound(1519);
    }
}

+ (void)maDaZhongZhenDong{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        if (@available(iOS 10.0, *)) {
            UIImpactFeedbackGenerator*impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleHeavy];
            [impactLight impactOccurred];
        }
    }else{
        AudioServicesPlaySystemSound(1519);
    }
}


@end
