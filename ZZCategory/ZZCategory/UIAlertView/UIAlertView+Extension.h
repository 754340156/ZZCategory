//
//  UIAlertView+Extension.h
//  ZZCategory
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UIAlertViewCallBackBlock)(NSInteger buttonIndex);
@interface UIAlertView (Extension)
/**
 *  便捷UIAlertView Block
 *
 *  @param alertViewCallBackBlock 回调
 *  @param title                  标题
 *  @param message                信息
 *  @param cancelButtonName       取消按钮
 *  @param otherButtonTitles      其他按钮.....
 */
+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;
@end
