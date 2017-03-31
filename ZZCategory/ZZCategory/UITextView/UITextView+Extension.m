
//
//  UITextView+Extension.m
//  ZZCategory
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import "UITextView+Extension.h"
#import <objc/runtime.h>
static const char *phTextView = "placeHolderTextView";

@interface UITextView () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *placeHolderTextView;

@end

@implementation UITextView (PlaceHolder)

- (UITextView *)placeHolderTextView
{
    return objc_getAssociatedObject(self, phTextView);
}
- (void)setPlaceHolderTextView:(UITextView *)placeHolderTextView
{
    objc_setAssociatedObject(self, phTextView, placeHolderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addPlaceHolder:(NSString *)placeHolder
{
    if (![self placeHolderTextView]) {
        self.delegate = self;
        UITextView *textView = [[UITextView alloc] initWithFrame:self.bounds];
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        textView.font = self.font;
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor colorWithRed:192 / 255.0 green:192 / 255.0 blue:196 / 255.0 alpha:1.0];
        textView.userInteractionEnabled = NO;
        textView.text = placeHolder;
        [self addSubview:textView];
        [self setPlaceHolderTextView:textView];
    }
}

# pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeHolderTextView.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text && [textView.text isEqualToString:@""]) {
        self.placeHolderTextView.hidden = NO;
    }
}

@end
