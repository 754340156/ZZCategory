//
//  UIColor+Extension.h
//  ZZCategory
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
#pragma mark - Gradient
/**
 *  生成渐变色
 *
 *  @param c1     头
 *  @param c2     尾
 *  @param height 范围
 *
 *  @return 渐变色
 */
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;
#pragma mark - hex
/**
 *  由16进制颜色格式生成UIColor
 *
 *  @param hex 16进制颜色0x00FF00
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHex:(UInt32)hex;
/**
 *  由16进制颜色格式生成UIColor
 *
 *  @param hex 16进制颜色0x00FF00
 *  @param alpha 透明
 *
 *  @return Color
 */
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
/**
 *  由16进制颜色字符串格式生成UIColor
 *
 *  @param hexString 16进制颜色#00FF00
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;
/**
 *  生成当前颜色的16进制字符串
 *
 *  @return 16进制字符串
 */
- (NSString *)HEXString;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue;
#pragma mark - Modify
/// 翻转颜色
- (UIColor *)invertedColor;
/// 半透明色
- (UIColor *)colorForTranslucency;
/**
 *  更改颜色亮度
 *
 *  @param lighten 亮度从0到1
 *
 */
- (UIColor *)lightenColor:(CGFloat)lighten;
/**
 *  更改颜色亮度
 *
 *  @param darken 亮度从0到1
 *
 */
- (UIColor *)darkenColor:(CGFloat)darken;
@end
