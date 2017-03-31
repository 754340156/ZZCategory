//
//  UIButton+Extension.h
//  ZZCategory
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ActionBlock)(void);
@interface UIButton (Extension)
#pragma mark - UIButton扩大点击范围
/**
 *  扩大 UIButton 的点击范围
 *  控制上下左右的延长范围
 *
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
#pragma mark - 处理暴力点击
/**  设置点击时间间隔 */
@property (nonatomic, assign) NSTimeInterval timeInterval;
#pragma mark - 按钮上倒计时
/**
 *  显示倒计时，倒计时过程中不能点击
 *
 *  @param timeout    时长
 *  @param tittle     标题
 *  @param waitTittle 倒计时显示的标题
 */
- (void)startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle;
#pragma mark - 按钮上显示菊花
/**
 *  在按钮上显示一个菊花对象
 */
- (void) showIndicator;
/**
 *  隐藏菊花对象
 */
- (void) hideIndicator;
#pragma mark - block
@property (readonly) NSMutableDictionary *event;

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;
#pragma mark - init
/**  title font  */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font Target:(id)target Action:(SEL)action;
/**  title font backGroundColor */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font BackGroundColor:(UIColor *)backGroundColor Target:(id)target Action:(SEL)action;
/**  title font backGroundColor titleColor */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font BackGroundColor:(UIColor *)backGroundColor TitleColor:(UIColor *)titleColor Target:(id)target Action:(SEL)action;
/**  title font titleColor */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font TitleColor:(UIColor *)titleColor Target:(id)target Action:(SEL)action;
/**  title font selectedTitle */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle Target:(id)target Action:(SEL)action;
/**  title font selectedTitle backGroundColor */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle BackGroundColor:(UIColor *)backGroundColor Target:(id)target Action:(SEL)action;
/**  title font selectedTitle backGroundColor titleColor */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle BackGroundColor:(UIColor *)backGroundColor TitleColor:(UIColor *)titleColor SelectedTitleColor:(UIColor *)selectedTitleColor Target:(id)target Action:(SEL)action;
/**  title font selectedTitle  titleColor selectedTitleColor */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle TitleColor:(UIColor *)titleColor SelectedTitleColor:(UIColor *)selectedTitleColor Target:(id)target Action:(SEL)action;
/**  title font titleColor backGroundColor disableBackGroundColor */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font TitleColor:(UIColor *)titleColor BackGroundColor:(UIColor *)backGroundColor DisableBackGroundColor:(UIColor *)disableBackGroundColor Target:(id)target Action:(SEL)action;
/**  image */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Image:(UIImage *)image Target:(id)target Action:(SEL)action;
/**  image selectedImage */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Image:(UIImage *)image SelectedImage:(UIImage *)selectedImage Target:(id)target Action:(SEL)action;

/**  title font image */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font Image:(UIImage *)image Target:(id)target Action:(SEL)action;
/**  title font backGroundColor image */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font BackGroundColor:(UIColor *)backGroundColor Image:(UIImage *)image Target:(id)target Action:(SEL)action;
/**  title font backGroundColor titleColor image */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font BackGroundColor:(UIColor *)backGroundColor TitleColor:(UIColor *)titleColor Image:(UIImage *)image Target:(id)target Action:(SEL)action;
/**  title font titleColor image */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font TitleColor:(UIColor *)titleColor Image:(UIImage *)image Target:(id)target Action:(SEL)action;
/**  title font selectedTitle image */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle Image:(UIImage *)image Target:(id)target Action:(SEL)action;
/**  title font selectedTitle backGroundColor image */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle BackGroundColor:(UIColor *)backGroundColor Image:(UIImage *)image Target:(id)target Action:(SEL)action;
/**  title font selectedTitle backGroundColor titleColor selectedTitleColor image */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle BackGroundColor:(UIColor *)backGroundColor TitleColor:(UIColor *)titleColor SelectedTitleColor:(UIColor *)selectedTitleColor Image:(UIImage *)image Target:(id)target Action:(SEL)action;
/**  title font selectedTitle  titleColor selectedTitleColor image */
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle TitleColor:(UIColor *)titleColor SelectedTitleColor:(UIColor *)selectedTitleColor Image:(UIImage *)image Target:(id)target Action:(SEL)action;


@end
