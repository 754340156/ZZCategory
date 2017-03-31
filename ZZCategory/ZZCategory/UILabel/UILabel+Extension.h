//
//  UILabel+Extension.h
//  ZZCategory
//
//  Created by zhaozhe on 16/12/6.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)
//计算字符串宽度(单行)
- (CGFloat)getWidth;

//计算字符串的高度(单行)
- (CGFloat)getHeight;

//计算文字绘制所需大小
- (CGSize)getSize;

//计算文字绘制所需大小
- (CGSize)getSizeWithWidth:(CGFloat)width;

//计算文字绘制所需高度
+ (CGFloat)getHeightWithFont:(UIFont *)font;

//计算文字绘制所需宽度
+ (CGFloat)getWidthWithFont:(UIFont *)font text:(NSString *)text;

//计算文字绘制所需宽度
- (CGFloat)getWidthWithText:(NSString *)text;

//根据字体,宽度绘制所需高度
+ (CGFloat)getHeightWithFont:(UIFont *)font Width:(CGFloat)width text:(NSString *)text;

+ (CGSize)getSizeFont:(UIFont *)font text:(NSString *)text;

+ (instancetype)label;

+ (instancetype)labelWithTitle:(NSString *)title;

// 已知区域重新调整
- (CGSize)contentSize;

// 不知区域，通过其设置区域
- (CGSize)textSizeIn:(CGSize)size;

//- (void)layoutInContent;
/**  设置中划线 */
- (void)setMidStrikethrough;
/**  设置下划线 */
- (void)setUnderlineWithRange:(NSRange)range;
@end
@interface InsetLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets contentInset;

@end
