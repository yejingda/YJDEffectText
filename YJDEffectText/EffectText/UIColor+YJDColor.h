//
//  UIColor+YJDColor.h
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (YJDColor)


/**
 通过传入一个 16 进制整型的颜色值，和一个 CGFloat 的 alpha 值，返回一个 UIColor.
 
 @param hexValue    颜色值
 
 @param alphaValue  透明度值，从 0.0 到 1.0 的浮点数。
 
 @return            UIColor
 */
+ (UIColor *)yjd_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

/**
 通过传入一个 16 进制整型的颜色值，返回一个 UIColor. 透明度为 1.0
 
 @param hexValue   颜色值
 
 @return UIColor
 */
+ (UIColor *)yjd_colorWithHex:(NSInteger)hexValue;

/**
 通过传入一个 CGFloat 的 alpha 值，返回一个白色的带透明度的 UIColor.
 
 @param alphaValue 透明度值，从 0.0 到 1.0 的浮点数。
 
 @return UIColor
 */
+ (UIColor *)yjd_whiteColorWithAlpha:(CGFloat)alphaValue;

/**
 通过传入一个 CGFloat 的 alpha 值，返回一个黑色的带透明度的 UIColor.
 
 @param alphaValue 透明度值，从 0.0 到 1.0 的浮点数。
 
 @return UIColor
 */
+ (UIColor *)yjd_blackColorWithAlpha:(CGFloat)alphaValue;

/**
 通过传入一组 RGB 值，返回一个透明度为默认值 1.0 的 UIColor.
 
 @param r   红色值
 
 @param g   绿色值
 
 @param b   蓝色值
 
 @return UIColor
 */
+ (UIColor *)yjd_colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b;

/**
 通过传入一组 RGB 值，和一个透明度 alpha 值，返回一个带透明度的 UIColor.
 
 @param r   红色值
 
 @param g   绿色值
 
 @param b   蓝色值
 
 @param a   透明度值，从 0.0 到 1.0 的浮点数。
 
 @return UIColor
 */
+ (UIColor *)yjd_colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;

/**
 ** 通过传入 #ff55ff 这样的字符串，获取色值
 ** @param  hexString  字符串颜色
 ** @return 返回相应颜色或，nil
 **/
+ (UIColor *)yjd_colorWithHexString:(NSString *)hexString;


@end

NS_ASSUME_NONNULL_END
