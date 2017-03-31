//
//  UIAlertController+Extension.h
//  DiDiBeauty
//
//  Created by zhaozhe on 17/2/23.
//  Copyright © 2017年 zhaozhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertTitleAble <NSObject>

- (NSString *)alertTitle;

@end

@interface UIAlertController (Extension)

+ (UIAlertController *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray *)otherTitles handler:(void (^)(UIAlertController *alertController, NSInteger buttonIndex))block vc:(UIViewController *)vc;

+ (UIAlertController *)showSheetWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray *)otherTitles handler:(void (^)(UIAlertController *alertController, NSInteger buttonIndex))block vc:(UIViewController *)vc;

@end
