//
//  UIView+Extension.h
//  ZZCategory
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import <UIKit/UIKit.h>
//线的默认颜色
#define kLine_Color_Default [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1.0]

@interface UIView (Extension)
#pragma mark - frame
/**
 *  快速设置控件的位置
 */
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat X;
@property (nonatomic, assign) CGFloat Y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
/**
 *  快速根据xib创建View
 */
+ (instancetype)viewFromXib;

/**
 *  判断self和view是否重叠
 */
- (BOOL)intersectsWithView:(UIView *)view;
#pragma mark - subview

@property (nonatomic, strong) UIImageView *errorView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIView *toastView;


- (void)showLoadingView;    //展示加载视图
- (void)dismissLoadingView; //让加载视图消失


- (void)showErrorViewWithImage:(UIImage *)image;  //展示错误视图
- (void)dismissErrorView;   //让错误视图消失


- (void)showToastMsg:(NSString *)msg offset:(CGFloat)offset;   //展示吐丝
- (void)showToastMsg:(NSString *)msg time:(CGFloat)time offset:(CGFloat)offset;
- (void)showToastMsg:(NSString *)msg offset:(CGFloat)offset completion:(void(^)())completion;
- (void)showToastMsg:(NSString *)msg time:(CGFloat)time offset:(CGFloat)offset completion:(void(^)())completion;
- (void)dismissToast;   //让吐丝消息


//插入毛玻璃视图 在视图底部
- (void)showEffectViewWithStyle:(UIBlurEffectStyle)style
                          alpha:(CGFloat)alpha;
//移除毛玻璃视图
- (void)dismissEffectView;


//布局方式
typedef NS_ENUM(NSInteger, LineLayoutStyle)
{
    LineLayoutStyleInside = 0,  //内侧
    LineLayoutStyleMiddle,      //中间
    LineLayoutStyleOutside      //外侧
};

- (void)addTopLine;
- (void)addTopLineWithColor:(UIColor *)color;
- (void)addTopLineWithHeight:(CGFloat)height;
- (void)addTopLineWithColor:(UIColor *)color height:(CGFloat)height;
- (void)addTopLineWithStyle:(LineLayoutStyle)style;
- (void)addTopLineWithColor:(UIColor *)color style:(LineLayoutStyle)style;
- (void)addTopLineWithHeight:(CGFloat)height style:(LineLayoutStyle)style;
- (void)addTopLineWithColor:(UIColor *)color height:(CGFloat)height style:(LineLayoutStyle)style;


- (void)addLeftLine;
- (void)addLeftLineWithColor:(UIColor *)color;
- (void)addLeftLineWithWidth:(CGFloat)width;
- (void)addLeftLineWithColor:(UIColor *)color width:(CGFloat)width;
- (void)addLeftLineWithStyle:(LineLayoutStyle)style;
- (void)addLeftLineWithColor:(UIColor *)color style:(LineLayoutStyle)style;
- (void)addLeftLineWithWidth:(CGFloat)width style:(LineLayoutStyle)style;
- (void)addLeftLineWithColor:(UIColor *)color width:(CGFloat)width style:(LineLayoutStyle)style;
- (void)addLeftLineWithColor:(UIColor *)color width:(CGFloat)width margin:(CGFloat)margin style:(LineLayoutStyle)style;


- (void)addBottomLine;
- (void)addBottomLineWithColor:(UIColor *)color;
- (void)addBottomLineWithHeight:(CGFloat)height;
- (void)addBottomLineWithColor:(UIColor *)color height:(CGFloat)height;
- (void)addBottomLineWithStyle:(LineLayoutStyle)style;
- (void)addBottomLineWithColor:(UIColor *)color style:(LineLayoutStyle)style;
- (void)addBottomLineWithHeight:(CGFloat)height style:(LineLayoutStyle)style;
- (void)addBottomLineWithColor:(UIColor *)color height:(CGFloat)height style:(LineLayoutStyle)style;


- (void)addRightLine;
- (void)addRightLineWithColor:(UIColor *)color;
- (void)addRightLineWithWidth:(CGFloat)width;
- (void)addRightLineWithColor:(UIColor *)color width:(CGFloat)width;
- (void)addRightLineWithStyle:(LineLayoutStyle)style;
- (void)addRightLineWithColor:(UIColor *)color style:(LineLayoutStyle)style;
- (void)addRightLineWithWidth:(CGFloat)width style:(LineLayoutStyle)style;
- (void)addRightLineWithColor:(UIColor *)color width:(CGFloat)width style:(LineLayoutStyle)style;
#pragma mark - shadow
- (void)setShadow;

- (void)setShadowWithColor:(UIColor *)shadowColor;

- (void)setShadowWithOffset:(CGSize)size;

- (void)setShadowWithColor:(UIColor *)shadowColor offset:(CGSize)size;
/**  投影效果（京东购物车底部工具条的效果） */
- (void)setProjection;
#pragma mark - Corner
- (void)setCornerWithRadius:(CGFloat)radius;

- (void)setCornerWithRadius:(CGFloat)radius BorderColor:(UIColor *)borderColor BorderWidth:(CGFloat)borderWidth;
- (void)setCornerWithRadius:(CGFloat)radius RoundingCorners:(UIRectCorner)roundingCorners;

/**  高性能设置圆角 */
- (void)setCornerViewHighPerformanceWithRadius:(CGFloat)radius;
#pragma mark - GestureRecognizer
- (void)addTapGestureRecognizerWithTarget:(id)target Action:(SEL)action;
@end
