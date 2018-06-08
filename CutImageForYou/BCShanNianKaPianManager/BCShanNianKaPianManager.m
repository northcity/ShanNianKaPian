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
#import "zlib.h"


#define myColor(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

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

+ (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

+ (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

+ (UIColor *)colorwithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(UIColor*)toUIColorByStr:(NSString*)colorStr{
    
    
    
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    
    
    // Separate into r, g, b substrings
    
    NSRange range;
    
    range.location = 0;
    
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    
    unsigned int r, g, b;
    
    
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    
    
    return [UIColor colorWithRed:((float) r / 255.0f)
            
                           green:((float) g / 255.0f)
            
                            blue:((float) b / 255.0f)
            
                           alpha:1.0f];
    
}

+(NSString*)toStrByUIColor:(UIColor*)color{
    
    CGFloat r, g, b, a;
    
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
    
    return [NSString stringWithFormat:@"%06x", rgb];
    
}














// UIColor转#ffffff格式的字符串
+ (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alphaValue {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if (cString.length < 6)
        return [UIColor clearColor];
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if (cString.length != 6)
        return [UIColor clearColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    // 注意：myColor是自定义宏
    //#define myColor(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
    return myColor(r, g, b, alphaValue);
}

+ (UIColor *)yingSheFromCOlorString: (NSString *)colorString{
        NSUInteger colorStyle = [colorString integerValue];
    switch (colorStyle) {
        case BCShanNianKaPianManagerColorString1:
            return  PNCColor(164, 185, 255);
            break;
        case BCShanNianKaPianManagerColorString2:
            return  PNCColor(255, 120, 159);
            break;
        case BCShanNianKaPianManagerColorString3:
            return PNCColor(255, 172, 94);
            break;
        case BCShanNianKaPianManagerColorString4:
            return  PNCColor(109, 212, 92);
            break;
        case BCShanNianKaPianManagerColorString5:
            return   PNCColor(182, 118, 219);
            break;
        default:
            break;
    }
    return [UIColor whiteColor];
}








#pragma mark - 压缩数据
+ (NSData *)gzipData:(NSData *)pUncompressedData
{
    if (!pUncompressedData || [pUncompressedData length] == 0) {
        //NSLog(@"%s: Error: Can't compress an empty or nil NSData object",__func__);
        return nil;
    }
    
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc = Z_NULL;
    zlibStreamStruct.zfree = Z_NULL;
    zlibStreamStruct.opaque = Z_NULL;
    zlibStreamStruct.total_out = 0;
    zlibStreamStruct.next_in = (Bytef *)[pUncompressedData bytes];
    zlibStreamStruct.avail_in = (uint)[pUncompressedData length];
    
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
    if (initError != Z_OK) {
        NSString *errorMsg = nil;
        switch (initError) {
            case Z_STREAM_ERROR:
                errorMsg = @"Invalid parameter passed in to function.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Insufficient memory.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        return nil;
    }
    
    NSMutableData *compressedData = [NSMutableData dataWithLength:[pUncompressedData length] * 1.01 + 21];
    
    int deflateStatus;
    do {
        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        zlibStreamStruct.avail_out = (uint)([compressedData length] - zlibStreamStruct.total_out);
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
        
    } while (deflateStatus == Z_OK);
    
    if (deflateStatus != Z_STREAM_END)
    {
        NSString *errorMsg = nil;
        switch (deflateStatus) {
            case Z_ERRNO:
                errorMsg = @"Error occured while reading file.";
                break;
            case Z_STREAM_ERROR:
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                break;
            case Z_DATA_ERROR:
                errorMsg = @"The deflate data was invalid or incomplete.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Memory could not be allocated for processing.";
                break;
            case Z_BUF_ERROR:
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        //NSLog(@"%s:zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        deflateEnd(&zlibStreamStruct);
        return nil;
    }
    
    deflateEnd(&zlibStreamStruct);
    [compressedData setLength:zlibStreamStruct.total_out];
    //NSLog(@"%s: Compressed file from %zd B to %zd B", __func__, [pUncompressedData length], [compressedData length]);
    return [NSData dataWithData:compressedData];
}

#pragma mark - 解压数据
+ (NSData *)decompressData:(NSData *)compressedData {
    
    z_stream zStream;
    
    zStream.zalloc = Z_NULL;
    
    zStream.zfree = Z_NULL;
    
    zStream.opaque = Z_NULL;
    
    zStream.avail_in = 0;
    
    zStream.next_in = 0;
    
    int status = inflateInit2(&zStream, (15+32));
    
    
    if (status != Z_OK) {
        
        return nil;
        
    }
    
    Bytef *bytes = (Bytef *)[compressedData bytes];
    
    NSUInteger length = [compressedData length];
    
    
    
    NSUInteger halfLength = length/2;
    
    NSMutableData *uncompressedData = [NSMutableData dataWithLength:length+halfLength];
    
    
    
    zStream.next_in = bytes;
    
    zStream.avail_in = (unsigned int)length;
    
    zStream.avail_out = 0;
    
    
    
    NSInteger bytesProcessedAlready = zStream.total_out;
    
    while (zStream.avail_in != 0) {
        
        
        
        if (zStream.total_out - bytesProcessedAlready >= [uncompressedData length]) {
            
            [uncompressedData increaseLengthBy:halfLength];
            
        }
        
        
        
        zStream.next_out = (Bytef*)[uncompressedData mutableBytes] + zStream.total_out-bytesProcessedAlready;
        
        zStream.avail_out = (unsigned int)([uncompressedData length] - (zStream.total_out-bytesProcessedAlready));
        
        
        
        status = inflate(&zStream, Z_NO_FLUSH);
        
        
        
        if (status == Z_STREAM_END) {
            
            break;
            
        } else if (status != Z_OK) {
            
            return nil;
            
        }
        
    }
    
    
    
    status = inflateEnd(&zStream);
    
    if (status != Z_OK) {
        
        return nil;
        
    }
    
    
    
    [uncompressedData setLength: zStream.total_out-bytesProcessedAlready];  // Set real length
    
    
    return uncompressedData;
    
}





@end
