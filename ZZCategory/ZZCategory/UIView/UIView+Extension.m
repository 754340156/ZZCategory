
//
//  UIView+Extension.m
//  ZZCategory
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>
#import "UILabel+Extension.h"
#define kBackgroudAlpha_toastLabel 0.6

#define kBackGroudColor [UIColor colorWithWhite:0.0 alpha:kBackGroudAlpha]

#define kBackgroudAlpha_toastView  0.00

#define kBackgroudAlpha_dismiss_toastView  0.00


#define CornerRadius  5

#define kTime 1.0

#define kToastVertMargin 5.0f

#define kToastMaxMargin 20

#define kToastLabelInset 10.0f

//字体
#define kFont [UIFont boldSystemFontOfSize:16.0]


//线的默认高度
#define kLine_W_H_Default 1.0

//tag
#define kEffectView_Tag 5001    //毛玻璃tag

#define kTopLine_Tag    6001    //顶线tag
#define kLeftLine_Tag   6002    //左线tag
#define kBottomLine_Tag 6003    //底线tag
#define kRightLine_Tag  6004    //右线tag

static void *loadingViewKey = &loadingViewKey;
static void *errorViewKey   = &errorViewKey;
static void *toastViewKey   = &toastViewKey;

@implementation UIView (Extension)
- (BOOL)intersectsWithView:(UIView *)view
{
    //都先转换为相对于窗口的坐标，然后进行判断是否重合
    CGRect selfRect = [self convertRect:self.bounds toView:nil];
    CGRect viewRect = [view convertRect:view.bounds toView:nil];
    return CGRectIntersectsRect(selfRect, viewRect);
}

+ (instancetype)viewFromXib
{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerY
{
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)X
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)X
{
    CGRect frame = self.frame;
    frame.origin.x = X;
    self.frame = frame;
}

- (CGFloat)Y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)Y
{
    CGRect frame = self.frame;
    frame.origin.y = Y;
    self.frame = frame;
}
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.top + self.height;
}

- (void)setBottom:(CGFloat)bottom {
    self.top = bottom - self.height;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right {
    return self.left + self.width;
}

- (void)setRight:(CGFloat)right {
    self.left = right - self.width;
}
#pragma mark - subview

//加载视图的setter
- (void)setLoadingView:(UIActivityIndicatorView *)loadingView
{
    objc_setAssociatedObject(self, &loadingViewKey, loadingView, OBJC_ASSOCIATION_RETAIN);
}

//加载视图的getter
- (UIView *)loadingView
{
    return  objc_getAssociatedObject(self, &loadingViewKey);
}


//错误视图的setter
- (void)setErrorView:(UIImageView *)errorView
{
    objc_setAssociatedObject(self, &errorViewKey, errorView, OBJC_ASSOCIATION_RETAIN);
}

//错误视图的getter
- (UIImageView *)errorView
{
    return  objc_getAssociatedObject(self, &errorViewKey);
}


//吐丝视图的setter
- (void)setToastView:(UIView *)toastView
{
    objc_setAssociatedObject(self, &toastViewKey, toastView, OBJC_ASSOCIATION_RETAIN);
}

//吐丝视图的getter
- (UIView *)toastView
{
    return  objc_getAssociatedObject(self, &toastViewKey);
}

//展示加载视图
- (void)showLoadingView
{
    if (self.loadingView)
    {
        return;
    }
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:kBackgroudAlpha_toastView];
    if ([self isKindOfClass:[UIScrollView class]])
    {
        self.loadingView.frame = CGRectMake(0, 0, self.bounds.size.width - ((UIScrollView *)self).contentInset.left - ((UIScrollView *)self).contentInset.right, self.bounds.size.height - ((UIScrollView *)self).contentInset.top - ((UIScrollView *)self).contentInset.bottom);
    }
    
    [self addSubview:self.loadingView];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = CGPointMake(self.loadingView.bounds.size.width / 2.0, self.loadingView.bounds.size.height / 2.0);  //放在中心
    activityView.tag = 999;
    [self.loadingView addSubview:activityView];
    
    [activityView startAnimating];
    [self bringSubviewToFront:self.loadingView];
    
    if ([self isKindOfClass:[UIScrollView class]])
    {
        ((UIScrollView *)self).scrollEnabled = NO;
    }
}

//让加载视图消失
- (void)dismissLoadingView
{
    UIActivityIndicatorView *activityView = [self.loadingView viewWithTag:999];
    [activityView stopAnimating];
    
    [activityView removeFromSuperview];
    activityView = nil;
    
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    
    if ([self isKindOfClass:[UIScrollView class]])
    {
        ((UIScrollView *)self).scrollEnabled = YES;
    }
}

//展示错误视图
- (void)showErrorViewWithImage:(UIImage *)image
{
    if (!self.errorView)
    {
        self.errorView = [[UIImageView alloc] init];
        [self addSubview:self.errorView];
    }
    self.errorView.frame = self.bounds;
    self.errorView.image = image;
    [self bringSubviewToFront:self.errorView];
}

//让错误视图消失
- (void)dismissErrorView
{
    UIView *effectView = [self.errorView viewWithTag:1002];
    [effectView removeFromSuperview];
    
    [self.errorView removeFromSuperview];
    self.errorView = nil;
}

#pragma mark - 吐丝视图
- (void)showToastMsg:(NSString *)msg time:(CGFloat)time offset:(CGFloat)offset completion:(void(^)())completion
{
    [self dismissToast];
    
    InsetLabel *toastLabel;
    UIVisualEffectView *effectView;
    
    self.toastView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    if ([self isKindOfClass:[UIScrollView class]])
    {
        self.toastView.frame = CGRectMake(0, 0, self.bounds.size.width - ((UIScrollView *)self).contentInset.left - ((UIScrollView *)self).contentInset.right, self.bounds.size.height - ((UIScrollView *)self).contentInset.top - ((UIScrollView *)self).contentInset.bottom);
    }
    self.toastView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.toastView];
    
    //创建需要的毛玻璃类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //毛玻璃view 视图
    effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.tag = 1002;
    effectView.layer.cornerRadius = CornerRadius;
    effectView.layer.masksToBounds = YES;
    //添加到要有毛玻璃特效的控件中
    //effectView.frame = self.bounds;
    //设置模糊透明度
    //effectView.alpha = 1.0f;
    
    toastLabel = [[InsetLabel alloc] init];
    toastLabel.contentInset = UIEdgeInsetsMake(kToastVertMargin, kToastLabelInset, kToastVertMargin, kToastLabelInset);
    //toastLabel.backgroundColor = kBackGroudColor;
    toastLabel.layer.cornerRadius = CornerRadius;
    toastLabel.layer.masksToBounds = YES;
    toastLabel.tag = 1001;
    toastLabel.font = kFont;
    
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.numberOfLines = 0;
    toastLabel.textColor = [UIColor whiteColor];
    [self.toastView addSubview:effectView];
    [effectView addSubview:toastLabel];
    
    toastLabel.text = msg;
    
    //计算文字的宽度
    CGFloat width = [toastLabel getWidth] + 2 * kToastLabelInset;
    CGFloat maxWidth = self.bounds.size.width - 2 * kToastMaxMargin;
    BOOL isSingleLine = (width <= maxWidth);
    CGFloat labelWidth = isSingleLine ? width : maxWidth;
    CGRect tempFrame = toastLabel.frame;
    CGSize textSize = [toastLabel getSizeWithWidth:labelWidth - 2 * kToastLabelInset];
    tempFrame.size = CGSizeMake(labelWidth, textSize.height + 2 * kToastVertMargin);
    
    //toastLabel.frame = tempFrame;
    effectView.frame = tempFrame;
    toastLabel.frame = effectView.bounds;
    
    effectView.center = CGPointMake(self.toastView.bounds.size.width / 2.0, self.toastView.bounds.size.height / 2.0 + offset);
    //	//加阴影
    //	view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    //	view.layer.shadowOffset = CGSizeMake(0, 3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    //	view.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    //	view.layer.shadowRadius = 2;//阴影半径，默认3
    
    //    toastLabel.text = msg;
    //
    __weak __typeof(self)weakSelf = self;
    effectView.alpha = 0;
    effectView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:kBackgroudAlpha_toastLabel];
    
    [UIView animateWithDuration:0.3 animations:^{
        effectView.alpha = 0.99;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                effectView.alpha = 0;
            } completion:^(BOOL finished) {
                
                [weakSelf dismissToast];
                if (completion) {
                    completion();
                }
            }];
        });
    }];
    
    
    
    
    
    
    
    
//    CGAffineTransform effectTransform = effectView.transform;
//    effectView.transform = CGAffineTransformScale(effectTransform, 0.3, 0.3);
//    
//    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:16.0 options:0 animations:^{
//        
//        effectView.alpha = 0.99;
//        effectView.transform = effectTransform;
//        self.toastView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:kBackgroudAlpha_dismiss_toastView];
//        
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:time animations:^{
//            
//            effectView.alpha = 1;
//            
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.3 animations:^{
//                
//                effectView.transform = CGAffineTransformScale(effectTransform, 0.7, 0.7);
//                effectView.alpha = 0.8;
//                self.toastView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:kBackgroudAlpha_dismiss_toastView];
//                
//            } completion:^(BOOL finished) {
//                
//                [weakSelf dismissToast];
//                if (completion) {
//                    completion();
//                }
//            }];
//        }];
//    }];
    
    [self bringSubviewToFront:self.toastView];
}

- (void)showToastMsg:(NSString *)msg offset:(CGFloat)offset completion:(void(^)())completion
{
    [self showToastMsg:msg time:kTime offset:offset completion:completion];
}

//展示吐丝
- (void)showToastMsg:(NSString *)msg time:(CGFloat)time offset:(CGFloat)offset;
{
    [self showToastMsg:msg time:time offset:offset completion:nil];
}

- (void)showToastMsg:(NSString *)msg offset:(CGFloat)offset
{
    [self showToastMsg:msg time:kTime offset:offset];
}
//让吐丝消息
- (void)dismissToast
{
    [self.toastView removeFromSuperview];
    self.toastView = nil;
}

//插入毛玻璃视图 在视图底部
- (void)showEffectViewWithStyle:(UIBlurEffectStyle)style
                          alpha:(CGFloat)alpha
{
    UIVisualEffectView *effectView;
    effectView = [self viewWithTag:kEffectView_Tag];
    if (!effectView)
    {
        //创建需要的毛玻璃特效类型
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:style];
        //毛玻璃view 视图
        effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.tag = kEffectView_Tag;
        //添加到要有毛玻璃特效的控件中
        effectView.frame = self.bounds;
        //设置模糊透明度
        effectView.alpha = alpha;
        [self insertSubview:effectView atIndex:0];
    }
}

//移除毛玻璃视图
- (void)dismissEffectView
{
    UIVisualEffectView *effectView = [self viewWithTag:kEffectView_Tag];
    [effectView removeFromSuperview];
    effectView = nil;
}


//默认：LineLayoutStyleInside
- (void)addTopLine
{
    [self addTopLineWithColor:kLine_Color_Default height:kLine_W_H_Default style:LineLayoutStyleInside];
}

- (void)addTopLineWithColor:(UIColor *)color
{
    [self addTopLineWithColor:color height:kLine_W_H_Default style:LineLayoutStyleInside];
}

- (void)addTopLineWithHeight:(CGFloat)height
{
    [self addTopLineWithColor:kLine_Color_Default height:height style:LineLayoutStyleInside];
}

- (void)addTopLineWithColor:(UIColor *)color height:(CGFloat)height
{
    [self addTopLineWithColor:color height:height style:LineLayoutStyleInside];
}

- (void)addTopLineWithStyle:(LineLayoutStyle)style
{
    [self addTopLineWithColor:kLine_Color_Default height:kLine_W_H_Default style:style];
}

- (void)addTopLineWithColor:(UIColor *)color style:(LineLayoutStyle)style
{
    [self addTopLineWithColor:color height:kLine_W_H_Default style:style];
}

- (void)addTopLineWithHeight:(CGFloat)height style:(LineLayoutStyle)style
{
    [self addTopLineWithColor:kLine_Color_Default height:height style:style];
}

- (void)addTopLineWithColor:(UIColor *)color height:(CGFloat)height style:(LineLayoutStyle)style
{
    UIView *lineView = [self viewWithTag:kTopLine_Tag];
    if (lineView)
    {
        return;
    }
    
    lineView = [UIView new];
    lineView.tag = kTopLine_Tag;
    lineView.backgroundColor = color;
    
    CGFloat topLayoutNum = 0;
    
    if (style == LineLayoutStyleMiddle)
    {
        topLayoutNum = -height / 2.0;
    }
    else if (style == LineLayoutStyleOutside)
    {
        topLayoutNum = -height;
    }
    
    if ([self isKindOfClass:[UIScrollView class]])
    {
        if (self.frame.size.height != 0 && self.frame.size.height != 0)
        {
            [self addSubview:lineView];
            [self bringSubviewToFront:lineView];
            
            lineView.frame = CGRectMake(0, topLayoutNum, self.frame.size.width, height);
        }
        
        return;
    }
    
    [self addSubview:lineView];
    [self bringSubviewToFront:lineView];
    
    //添加约束
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:height]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:topLayoutNum]];
}

- (void)addLeftLine
{
    [self addLeftLineWithColor:kLine_Color_Default width:kLine_W_H_Default style:LineLayoutStyleInside];
}

- (void)addLeftLineWithColor:(UIColor *)color
{
    [self addLeftLineWithColor:color width:kLine_W_H_Default style:LineLayoutStyleInside];
}

- (void)addLeftLineWithWidth:(CGFloat)width
{
    [self addLeftLineWithColor:kLine_Color_Default width:width style:LineLayoutStyleInside];
}

- (void)addLeftLineWithColor:(UIColor *)color width:(CGFloat)width
{
    [self addLeftLineWithColor:color width:width style:LineLayoutStyleInside];
}

- (void)addLeftLineWithStyle:(LineLayoutStyle)style
{
    [self addLeftLineWithColor:kLine_Color_Default width:kLine_W_H_Default style:style];
}

- (void)addLeftLineWithColor:(UIColor *)color style:(LineLayoutStyle)style
{
    [self addLeftLineWithColor:color width:kLine_W_H_Default style:style];
}

- (void)addLeftLineWithWidth:(CGFloat)width style:(LineLayoutStyle)style
{
    [self addLeftLineWithColor:kLine_Color_Default width:width style:style];
}

- (void)addLeftLineWithColor:(UIColor *)color width:(CGFloat)width style:(LineLayoutStyle)style
{
    UIView *lineView = [self viewWithTag:kLeftLine_Tag];
    if (lineView)
    {
        return;
    }
    
    lineView = [UIView new];
    lineView.tag = kLeftLine_Tag;
    lineView.backgroundColor = color;
    
    
    CGFloat leftLayoutNum = 0;
    
    if (style == LineLayoutStyleMiddle)
    {
        leftLayoutNum = -width / 2.0;
    }
    else if (style == LineLayoutStyleOutside)
    {
        leftLayoutNum = -width;
    }
    
    if ([self isKindOfClass:[UIScrollView class]])
    {
        if (self.frame.size.height != 0 && self.frame.size.height != 0)
        {
            [self addSubview:lineView];
            [self bringSubviewToFront:lineView];
            
            lineView.frame = CGRectMake(leftLayoutNum, 0, width, self.size.height);
        }
        
        return;
    }
    
    [self addSubview:lineView];
    [self bringSubviewToFront:lineView];
    
    //添加约束
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:width]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:leftLayoutNum]];
}

- (void)addLeftLineWithColor:(UIColor *)color width:(CGFloat)width margin:(CGFloat)margin style:(LineLayoutStyle)style
{
    UIView *lineView = [self viewWithTag:kLeftLine_Tag];
    if (lineView)
    {
        return;
    }
    
    lineView = [UIView new];
    lineView.tag = kLeftLine_Tag;
    lineView.backgroundColor = color;
    
    CGFloat leftLayoutNum = 0;
    
    if (style == LineLayoutStyleMiddle)
    {
        leftLayoutNum = -width / 2.0;
    }
    else if (style == LineLayoutStyleOutside)
    {
        leftLayoutNum = -width;
    }
    
    if ([self isKindOfClass:[UIScrollView class]])
    {
        if (self.frame.size.height != 0 && self.frame.size.height != 0)
        {
            [self addSubview:lineView];
            [self bringSubviewToFront:lineView];
            
            lineView.frame = CGRectMake(leftLayoutNum, 0, width, self.size.height);
        }
        
        return;
    }
    
    [self addSubview:lineView];
    [self bringSubviewToFront:lineView];
    
    //添加约束
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:margin]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-margin]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:width]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:leftLayoutNum]];
}


- (void)addBottomLine
{
    [self addBottomLineWithColor:kLine_Color_Default height:kLine_W_H_Default style:LineLayoutStyleInside];
}

- (void)addBottomLineWithColor:(UIColor *)color
{
    [self addBottomLineWithColor:color height:kLine_W_H_Default style:LineLayoutStyleInside];
}

- (void)addBottomLineWithHeight:(CGFloat)height
{
    [self addBottomLineWithColor:kLine_Color_Default height:height style:LineLayoutStyleInside];
}

- (void)addBottomLineWithColor:(UIColor *)color height:(CGFloat)height
{
    [self addBottomLineWithColor:color height:height style:LineLayoutStyleInside];
}

- (void)addBottomLineWithStyle:(LineLayoutStyle)style
{
    [self addBottomLineWithColor:kLine_Color_Default height:kLine_W_H_Default style:style];
}

- (void)addBottomLineWithColor:(UIColor *)color style:(LineLayoutStyle)style
{
    [self addBottomLineWithColor:color height:kLine_W_H_Default style:style];
}

- (void)addBottomLineWithHeight:(CGFloat)height style:(LineLayoutStyle)style
{
    [self addBottomLineWithColor:kLine_Color_Default height:height style:style];
}

- (void)addBottomLineWithColor:(UIColor *)color height:(CGFloat)height style:(LineLayoutStyle)style;
{
    UIView *lineView = [self viewWithTag:kBottomLine_Tag];
    if (lineView)
    {
        return;
    }
    
    lineView = [UIView new];
    lineView.tag = kBottomLine_Tag;
    lineView.backgroundColor = color;
    
    CGFloat bottomLayoutNum = 0;
    
    if (style == LineLayoutStyleMiddle)
    {
        bottomLayoutNum = height / 2.0;
    }
    else if (style == LineLayoutStyleOutside)
    {
        bottomLayoutNum = height;
    }
    
    if ([self isKindOfClass:[UIScrollView class]])
    {
        if (self.frame.size.height != 0 && self.frame.size.height != 0)
        {
            [self addSubview:lineView];
            [self bringSubviewToFront:lineView];
            
            lineView.frame = CGRectMake(0, self.size.height + bottomLayoutNum - height, self.size.width, height);
        }
        
        return;
    }
    
    [self addSubview:lineView];
    [self bringSubviewToFront:lineView];
    
    //添加约束
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:bottomLayoutNum]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:height]];
}

- (void)addRightLine
{
    [self addRightLineWithColor:kLine_Color_Default width:kLine_W_H_Default style:LineLayoutStyleInside];
}

- (void)addRightLineWithColor:(UIColor *)color
{
    [self addRightLineWithColor:color width:kLine_W_H_Default style:LineLayoutStyleInside];
}

- (void)addRightLineWithWidth:(CGFloat)width
{
    [self addRightLineWithColor:kLine_Color_Default width:width style:LineLayoutStyleInside];
}

- (void)addRightLineWithColor:(UIColor *)color width:(CGFloat)width
{
    [self addRightLineWithColor:color width:width style:LineLayoutStyleInside];
}

- (void)addRightLineWithStyle:(LineLayoutStyle)style
{
    [self addRightLineWithColor:kLine_Color_Default width:kLine_W_H_Default style:style];
}

- (void)addRightLineWithColor:(UIColor *)color style:(LineLayoutStyle)style
{
    [self addRightLineWithColor:color width:kLine_W_H_Default style:style];
}

- (void)addRightLineWithWidth:(CGFloat)width style:(LineLayoutStyle)style
{
    [self addRightLineWithColor:kLine_Color_Default width:width style:style];
}

- (void)addRightLineWithColor:(UIColor *)color width:(CGFloat)width style:(LineLayoutStyle)style
{
    
    UIView *lineView = [self viewWithTag:kRightLine_Tag];
    if (lineView)
    {
        return;
    }
    
    lineView = [UIView new];
    lineView.tag = kRightLine_Tag;
    lineView.backgroundColor = color;
    
    CGFloat rightLayoutNum = 0;
    
    if (style == LineLayoutStyleMiddle)
    {
        rightLayoutNum = width / 2.0;
    }
    else if (style == LineLayoutStyleOutside)
    {
        rightLayoutNum = width;
    }
    
    if ([self isKindOfClass:[UIScrollView class]])
    {
        if (self.frame.size.height != 0 && self.frame.size.height != 0)
        {
            [self addSubview:lineView];
            [self bringSubviewToFront:lineView];
            
            lineView.frame = CGRectMake(self.frame.size.width +  rightLayoutNum - width, 0, width, self.frame.size.height);
        }
        
        return;
    }
    
    
    [self addSubview:lineView];
    [self bringSubviewToFront:lineView];
    
    //添加约束
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:width]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:rightLayoutNum]];
}
#pragma mark shadow
- (void)setShadow
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影的透明度
    self.layer.shadowOpacity = 0.8f;
    //阴影的圆角
    self.layer.shadowRadius = 2.f;
    
    self.layer.shadowOffset = CGSizeMake(2, 2);
}

- (void)setShadowWithColor:(UIColor *)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
    //阴影的透明度
    self.layer.shadowOpacity = 0.8f;
    //阴影的圆角
    self.layer.shadowRadius = 2.f;
    
    self.layer.shadowOffset = CGSizeMake(2, 2);
}

- (void)setShadowWithOffset:(CGSize)size
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影的透明度
    self.layer.shadowOpacity = 0.8f;
    //阴影的圆角
    self.layer.shadowRadius = 2.f;
    self.layer.shadowOffset = size;
}

- (void)setShadowWithColor:(UIColor *)shadowColor offset:(CGSize)size
{
    self.layer.shadowColor = shadowColor.CGColor;
    //阴影的透明度
    self.layer.shadowOpacity = 0.8f;
    //阴影的圆角
    self.layer.shadowRadius = 2.f;
    self.layer.shadowOffset = size;
}
/**  投影效果（京东购物车底部工具条的效果） */
- (void)setProjection
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.4f;
    self.layer.shadowRadius = 4.0f;
    self.layer.shadowOffset = CGSizeMake(0, 0);
}
#pragma mark - Corner
- (void)setCornerWithRadius:(CGFloat)radius
{
    [self setCornerWithRadius:radius BorderColor:nil BorderWidth:0];
}

- (void)setCornerWithRadius:(CGFloat)radius BorderColor:(UIColor *)borderColor BorderWidth:(CGFloat)borderWidth
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    if (borderColor) {
        self.layer.borderColor = borderColor.CGColor;
    }
    if (borderWidth) {
        self.layer.borderWidth = borderWidth;
    }
}
- (void)setCornerWithRadius:(CGFloat)radius RoundingCorners:(UIRectCorner)roundingCorners
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:roundingCorners cornerRadii:CGSizeMake(10,10)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
/**  高性能设置圆角 */
- (void)setCornerViewHighPerformanceWithRadius:(CGFloat)radius
{
    CGSize size = self.frame.size;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIColor *bkColor = self.backgroundColor;
    
    UIImage *image = [[UIImage alloc] init];
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, bkColor.CGColor);
    CGContextAddPath(context,
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextDrawPath(context, kCGPathFill);
    [image drawInRect:rect];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = output;
    [self insertSubview:imageView atIndex:0];
    self.backgroundColor = [UIColor clearColor];
}
#pragma mark - GestureRecognizer
- (void)addTapGestureRecognizerWithTarget:(id)target Action:(SEL)action
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}
@end
