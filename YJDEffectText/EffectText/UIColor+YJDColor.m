//
//  UIColor+YJDColor.m
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import "UIColor+YJDColor.h"

@implementation UIColor (YJDColor)

+ (UIColor *)yjd_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor *)yjd_colorWithHex:(NSInteger)hexValue
{
    return [UIColor yjd_colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)yjd_whiteColorWithAlpha:(CGFloat)alphaValue
{
    return [UIColor yjd_colorWithHex:0xffffff alpha:alphaValue];
}

+ (UIColor *)yjd_blackColorWithAlpha:(CGFloat)alphaValue
{
    return [UIColor yjd_colorWithHex:0x000000 alpha:alphaValue];
}

+ (UIColor *)yjd_colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b
{
    return [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1];
}

+ (UIColor *)yjd_colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a
{
    return [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a];
}

+ (UIColor *)yjd_colorWithHexString:(NSString *)hexString {
    if([hexString hasPrefix:@"#"]){
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setScanLocation:1]; // bypass '#' character
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    }else{
        return nil;
    }
}


@end
