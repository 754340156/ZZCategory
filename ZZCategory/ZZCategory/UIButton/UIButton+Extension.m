//
//  UIButton+Extension.m
//  ZZCategory
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>
static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

static NSString *const kIndicatorViewKey = @"indicatorView";
static NSString *const kButtonTextObjectKey = @"buttonTextObject";


static NSTimeInterval defaultInterval = 2;
@interface UIButton ()
@property (nonatomic, assign) BOOL isIgnoreEvent;
@end

@implementation UIButton (Extension)


- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}
#pragma mark - 处理暴力点击
+ (void)load
{
    //需要的时候再开
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        SEL selA = @selector(sendAction:to:forEvent:);
//        SEL selB = @selector(mySendAction:to:forEvent:);
//        Method methodA =   class_getInstanceMethod(self,selA);
//        Method methodB = class_getInstanceMethod(self, selB);
//        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
//        if (isAdd) {
//            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
//        }else{
//            method_exchangeImplementations(methodA, methodB);
//        }
//    });
}
- (NSTimeInterval)timeInterval
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}
- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
        self.timeInterval =self.timeInterval ==0 ?defaultInterval:self.timeInterval;
        if (self.isIgnoreEvent){
            return;
        }else if (self.timeInterval > 0){
            [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
        }
    }
    self.isIgnoreEvent = YES;
    [self mySendAction:action to:target forEvent:event];
}
- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent
{
    
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isIgnoreEvent
{
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)resetState
{
    [self setIsIgnoreEvent:NO];
}
#pragma mark - 按钮的倒计时
- (void)startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle{
    
    __block NSInteger timeOut = timeout; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:tittle forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2ld", (long)timeOut];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:[NSString stringWithFormat:@"(%@s)%@",strTime,waitTittle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
                
            });
            timeOut--;
            
        }
    });
    dispatch_resume(_timer);
    
}
#pragma mark - 按钮上显示菊花
/**
 *  在按钮上显示一个菊花对象
 */
- (void) showIndicator {
    
    // 菊花对象
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [indicator startAnimating];
    
    NSString *currentButtonText = self.titleLabel.text;
    // 关联一个按钮文本
    objc_setAssociatedObject(self, &kButtonTextObjectKey, currentButtonText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // 关联一个菊花对象
    objc_setAssociatedObject(self, &kIndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTitle:@"" forState:UIControlStateNormal];
    self.enabled = NO;
    [self addSubview:indicator];
    
    
}

/**
 *  隐藏菊花对象
 */
- (void) hideIndicator {
    // 获取按钮标题
    NSString *currentButtonText = (NSString *)objc_getAssociatedObject(self, &kButtonTextObjectKey);
    // 获取菊花对象并移除
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, &kIndicatorViewKey);
    
    [indicator removeFromSuperview];
    [self setTitle:currentButtonText forState:UIControlStateNormal];
    self.enabled = YES;
    
}
#pragma mark - block
static char overviewKey;

@dynamic event;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}
#pragma mark - init
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:nil SelectedTitle:nil SelectedTitleColor:nil BackGroundColor:nil Image:nil SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font BackGroundColor:(UIColor *)backGroundColor Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:nil SelectedTitle:nil SelectedTitleColor:nil BackGroundColor:backGroundColor Image:nil SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font BackGroundColor:(UIColor *)backGroundColor TitleColor:(UIColor *)titleColor Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:titleColor SelectedTitle:nil SelectedTitleColor:nil BackGroundColor:backGroundColor Image:nil SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font TitleColor:(UIColor *)titleColor Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:titleColor SelectedTitle:nil SelectedTitleColor:nil BackGroundColor:nil Image:nil SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:nil SelectedTitle:selectedTitle SelectedTitleColor:nil BackGroundColor:nil Image:nil SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle BackGroundColor:(UIColor *)backGroundColor Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:nil SelectedTitle:selectedTitle SelectedTitleColor:nil BackGroundColor:backGroundColor Image:nil SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle BackGroundColor:(UIColor *)backGroundColor TitleColor:(UIColor *)titleColor SelectedTitleColor:(UIColor *)selectedTitleColor Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:titleColor SelectedTitle:selectedTitle SelectedTitleColor:selectedTitleColor BackGroundColor:backGroundColor Image:nil SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle TitleColor:(UIColor *)titleColor SelectedTitleColor:(UIColor *)selectedTitleColor Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:titleColor SelectedTitle:selectedTitle SelectedTitleColor:selectedTitleColor BackGroundColor:nil Image:nil SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font TitleColor:(UIColor *)titleColor BackGroundColor:(UIColor *)backGroundColor DisableBackGroundColor:(UIColor *)disableBackGroundColor Target:(id)target Action:(SEL)action
{
    return  [self buttonWithFrame:frame Title:title Font:font TitleColor:titleColor BackGroundColor:backGroundColor DisableBackGroundColor:disableBackGroundColor Target:target Action:action];
}

+ (instancetype)zz_buttonWithFrame:(CGRect)frame Image:(UIImage *)image Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:nil Font:nil TitleColor:nil SelectedTitle:nil SelectedTitleColor:nil BackGroundColor:nil Image:image SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame  Image:(UIImage *)image SelectedImage:(UIImage *)selectedImage Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:nil Font:nil TitleColor:nil SelectedTitle:nil SelectedTitleColor:nil BackGroundColor:nil Image:image SelectedImage:selectedImage Target:target Action:action];
}


+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font Image:(UIImage *)image Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:nil SelectedTitle:nil SelectedTitleColor:nil BackGroundColor:nil Image:image SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font BackGroundColor:(UIColor *)backGroundColor Image:(UIImage *)image Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:nil SelectedTitle:nil SelectedTitleColor:nil BackGroundColor:backGroundColor Image:image SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font BackGroundColor:(UIColor *)backGroundColor TitleColor:(UIColor *)titleColor Image:(UIImage *)image Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:titleColor SelectedTitle:nil SelectedTitleColor:nil BackGroundColor:backGroundColor Image:image SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font TitleColor:(UIColor *)titleColor Image:(UIImage *)image Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:titleColor SelectedTitle:nil SelectedTitleColor:nil BackGroundColor:nil Image:image SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle Image:(UIImage *)image Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:nil SelectedTitle:selectedTitle SelectedTitleColor:nil BackGroundColor:nil Image:image SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle BackGroundColor:(UIColor *)backGroundColor Image:(UIImage *)image Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:nil SelectedTitle:selectedTitle SelectedTitleColor:nil BackGroundColor:backGroundColor Image:image SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle BackGroundColor:(UIColor *)backGroundColor TitleColor:(UIColor *)titleColor SelectedTitleColor:(UIColor *)selectedTitleColor Image:(UIImage *)image Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:titleColor SelectedTitle:selectedTitle SelectedTitleColor:selectedTitleColor BackGroundColor:backGroundColor Image:image SelectedImage:nil Target:target Action:action];
}
+ (instancetype)zz_buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font SelectedTitle:(NSString *)selectedTitle TitleColor:(UIColor *)titleColor SelectedTitleColor:(UIColor *)selectedTitleColor Image:(UIImage *)image Target:(id)target Action:(SEL)action
{
    return [self buttonWithFrame:frame Title:title Font:font TitleColor:titleColor SelectedTitle:selectedTitle SelectedTitleColor:selectedTitleColor BackGroundColor:nil Image:image SelectedImage:nil Target:target Action:action];
}

+ (instancetype)buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font TitleColor:(UIColor *)titleColor SelectedTitle:(NSString *)selectedTitle SelectedTitleColor:(UIColor *)selectedTitleColor BackGroundColor:(UIColor *)backGroundColor Image:(UIImage *)image SelectedImage:(UIImage *)selectedImage Target:(nullable id)target Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;

    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (selectedTitle) {
        [button setTitle:selectedTitle forState:UIControlStateSelected];
    }
    if (selectedTitleColor) {
        [button setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }
    if (backGroundColor) {
        [button setBackgroundColor:backGroundColor];
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (selectedImage) {
        [button setImage:selectedImage forState:UIControlStateSelected];
    }
    return button;
}
+ (instancetype)buttonWithFrame:(CGRect)frame Title:(NSString *)title Font:(UIFont *)font TitleColor:(UIColor *)titleColor BackGroundColor:(UIColor *)backGroundColor DisableBackGroundColor:(UIColor *)disableBackGroundColor Target:(id)target Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (backGroundColor) {
        [button setBackgroundImage:[UIImage imageWithColor:backGroundColor andSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    }
    if (disableBackGroundColor) {
        [button setBackgroundImage:[UIImage imageWithColor:disableBackGroundColor andSize:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
    }
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}
@end
