//
//  BCShanNianKaPianManager.h
//  CutImageForYou
//
//  Created by chenxi on 2018/6/4.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BCShanNianKaPianManagerColorString) {
    BCShanNianKaPianManagerColorString1 =52, //Cell按钮
    BCShanNianKaPianManagerColorString2,//添加银行卡
    BCShanNianKaPianManagerColorString3, //错误加载
    BCShanNianKaPianManagerColorString4,//进入详情按钮
    BCShanNianKaPianManagerColorString5//空页面按钮
};

@interface BCShanNianKaPianManager : NSObject
+ (void)maDaKaiShiZhenDong;
+ (void)maDaQingZhenDong;
+ (void)maDaZhongJianZhenDong;
+ (void)maDaZhongZhenDong;

+ (NSString *)convertDataToHexStr:(NSData *)data;
+ (NSData *)convertHexStrToData:(NSString *)str;
+ (UIColor *)colorwithHexString:(NSString *)color;
+(NSString*)toStrByUIColor:(UIColor*)color;
+(UIColor*)toUIColorByStr:(NSString*)colorStr;


+ (NSString *)hexStringFromColor:(UIColor *)color;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alphaValue;


+ (UIColor *)yingSheFromCOlorString: (NSString *)colorString;

+ (NSData *)gzipData:(NSData *)pUncompressedData;
+ (NSData *)decompressData:(NSData *)compressedData;
@end
