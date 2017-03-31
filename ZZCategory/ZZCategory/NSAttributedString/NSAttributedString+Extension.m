
//
//  NSAttributedString+Extension.m
//  ZZCategory
//
//  Created by zhaozhe on 16/12/6.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import "NSAttributedString+Extension.h"

@implementation NSAttributedString (Extension)
//简写属性字符串 自定义文字颜色
+ (NSAttributedString *)attributedStringWithString:(NSString *)string color:(UIColor *)color
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = color;
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    return attributedStr;
}

//简写属性字符串 自定义文字颜色和字体
+ (NSAttributedString *)attributedStringWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = color;
    attrs[NSFontAttributeName] = font;
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    return attributedStr;
}

/**  分段设置字体颜色 */
+ (NSAttributedString *)attributedStringWithString:(NSString *)string ConfigurationArray:(NSArray<NSDictionary<NSString *,UIColor *> *>*)configurationArray
{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:string];
    
    [configurationArray enumerateObjectsUsingBlock:^(NSDictionary<NSString *,UIColor *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [[hintString string]rangeOfString:obj.allKeys[0]];
        [hintString addAttribute:NSForegroundColorAttributeName value:obj.allValues[0] range:range];
    }];
    return hintString;
}
/**  设置字体大小 */
+ (NSAttributedString *)attributedStringWithString:(NSString *)string FontArray:(NSArray<NSDictionary<NSString *,UIFont *> *>*)fontArray
{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:string];
    
    [fontArray enumerateObjectsUsingBlock:^(NSDictionary<NSString *,UIColor *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [[hintString string]rangeOfString:obj.allKeys[0]];
        [hintString addAttribute:NSFontAttributeName value:obj.allValues[0] range:range];
    }];
    return hintString;
}
@end
