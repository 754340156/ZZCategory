//
//  NSAttributedString+Extension.h
//  ZZCategory
//
//  Created by zhaozhe on 16/12/6.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSAttributedString (Extension)
//简写属性字符串 自定义文字颜色
+ (NSAttributedString *)attributedStringWithString:(NSString *)string color:(UIColor *)color;

//简写属性字符串 自定义文字颜色和字体
+ (NSAttributedString *)attributedStringWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font;
/**  分段设置字体颜色 */
+ (NSAttributedString *)attributedStringWithString:(NSString *)string ConfigurationArray:(NSArray<NSDictionary<NSString *,UIColor *> *>*)configurationArray;
/**  设置字体大小 */
+ (NSAttributedString *)attributedStringWithString:(NSString *)string FontArray:(NSArray<NSDictionary<NSString *,UIFont *> *>*)fontArray;

@end
