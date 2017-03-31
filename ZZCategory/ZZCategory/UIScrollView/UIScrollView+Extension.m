//
//  UIScrollView+Extension.m
//  ZZCategory
//
//  Created by zhaozhe on 16/12/6.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import "UIScrollView+Extension.h"
#import <objc/runtime.h>
static void *scrollViewInset = &scrollViewInset;

@implementation UIScrollView (Extension)

#pragma mark - setter getter
- (void)setInsets:(UIEdgeInsets)insets
{
    NSValue *value = [NSValue value:&insets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &scrollViewInset, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.contentInset = insets;
    self.scrollIndicatorInsets = insets;
    self.contentOffset = CGPointMake(-insets.left, -insets.top);
}

- (UIEdgeInsets)insets
{
    NSValue *value = objc_getAssociatedObject(self, &scrollViewInset);
    if(value)
    {
        UIEdgeInsets aInsets;
        [value getValue:&aInsets];
        return aInsets;
    }
    else
    {
        return UIEdgeInsetsZero;
    }
}
@end
