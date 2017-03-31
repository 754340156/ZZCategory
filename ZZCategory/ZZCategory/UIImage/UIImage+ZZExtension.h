//
//  UIImage+ZZExtension.h
//  ZZCategory
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 *  水印方向
 */
typedef enum {
    
    //左上
    ImageWaterDirectTopLeft=0,
    
    //右上
    ImageWaterDirectTopRight,
    
    //左下
    ImageWaterDirectBottomLeft,
    
    //右下
    ImageWaterDirectBottomRight,
    
    //正中
    ImageWaterDirectCenter
    
}ImageWaterDirect;
@interface UIImage (ZZExtension)
/**
 *  修正图片方向
 *
 *  @return 修改后的图片
 */
- (UIImage *)fixOrientation;

/**
 *  获取图片指定位置的颜色
 *
 *  @param point 位置
 *
 *  @return 颜色
 */
- (UIColor *)colorAtPoint:(CGPoint )point;
/**
 *  返回指定颜色生成的图片
 *
 *  @param color 颜色
 *  @param size  尺寸
 *
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

/**
 *  获取指定尺寸（50*50）的图片
 *
 *  @param color 图片颜色
 *  @param name  文本,居中显示
 *
 */
+ (UIImage *)imageWithColor:(UIColor *)color text:(NSString *)name;

/**
 *  转成黑白图像
 *
 *  @param sourceImage 原图
 *
 *  @return 黑白图像
 */
+ (UIImage*)covertToGrayImageFromImage:(UIImage*)sourceImage;
/**
 *  生成一张高斯模糊的图片
 *
 *  @param image 原图
 *  @param blur  模糊程度 (0~1)
 *
 *  @return 高斯模糊图片
 */
+ (UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur;
#pragma mark - 圆形裁剪
/**  可以设置圆角的大小 */
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
/**
 *  生成圆角的图片
 *
 *  @param originImage 原始图片
 *  @param borderColor 边框原色
 *  @param borderWidth 边框宽度
 *
 *  @return 圆形图片
 */
+ (UIImage *)circleImage:(UIImage *)originImage borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
/**
 *  图片直接剪切为圆形
 *
 *  @return 剪切后的圆形图片
 */
- (UIImage *)roundImage;
#pragma mark - 截图
/*
 *  直接截屏
 */
+ (UIImage *)cutScreen;
/**
 *  从给定UIView中截图：UIView转UIImage
 */
+ (UIImage *)cutFromView:(UIView *)view;
/**
 *  从给定UIImage和指定Frame截图：
 */
- (UIImage *)cutWithFrame:(CGRect)frame;
#pragma mark - 水印
/**
 *  文字水印
 *
 *  @param text      文字
 *  @param direction 文字方向
 *  @param fontColor 文字颜色
 *  @param fontPoint 字体
 *  @param marginXY   对齐点
 *
 */
- (UIImage *)waterWithText:(NSString *)text
                 direction:(ImageWaterDirect)direction
                 fontColor:(UIColor *)fontColor
                 fontPoint:(CGFloat)fontPoint
                  marginXY:(CGPoint)marginXY;
/**
 *  图片水印
 *
 *  @param waterImage 图片水印
 *  @param direction  方向
 *  @param waterSize  水印大小
 *  @param marginXY   对齐点
 *
 */
- (UIImage *)waterWithWaterImage:(UIImage *)waterImage
                       direction:(ImageWaterDirect)direction
                       waterSize:(CGSize)waterSize
                        marginXY:(CGPoint)marginXY;
#pragma mark - 图片透明度
// tint只对里面的图案作更改颜色操作
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
//设置图片透明度
- (UIImage *)imageWithAlpha:(CGFloat)alpha;
- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;
#pragma mark - 图片压缩
/**
 图片压缩的逻辑:
 一:图片尺寸压缩 主要分为以下几种情况 一般参照像素为1280
 a.图片宽高均≤1280px时，图片尺寸保持不变;
 b.宽或高均＞1280px时 ——图片宽高比≤2，则将图片宽或者高取大的等比压缩至1280px; ——但是图片宽高比＞2时，则宽或者高取小的等比压缩至1280px;
 c.宽高一个＞1280px，另一个＜1280px，--图片宽高比＞2时，则宽高尺寸不变;--但是图片宽高比≤2时,则将图片宽或者高取大的等比压缩至1280px.
 
 二:图片质量压缩
 一般图片质量都压缩在90%就可以了
 */
+ (NSData *)imageCompressForSize:(UIImage *)sourceImage targetPx:(NSInteger)targetPx;
@end
