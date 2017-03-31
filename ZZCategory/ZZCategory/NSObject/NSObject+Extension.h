//
//  NSObject+Extension.h
//  ZZCategory
//
//  Created by zhaozhe on 16/12/6.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)
#pragma mark - block
typedef void (^CommonVoidBlock)();

typedef void (^CommonBlock)(id selfPtr);

typedef void (^CommonCompletionBlock)(id selfPtr, BOOL isFinished);

typedef void (^CommonFinishBlock)(BOOL isFinished);

- (void)excuteBlock:(CommonBlock)block;

- (void)performBlock:(CommonBlock)block;

//- (void)cancelBlock:(CommonBlock)block;

- (void)performBlock:(CommonBlock)block afterDelay:(NSTimeInterval)delay;



- (void)excuteCompletion:(CommonCompletionBlock)block withFinished:(NSNumber *)finished;

- (void)performCompletion:(CommonCompletionBlock)block withFinished:(BOOL)finished;

// 并发执行tasks里的作务，等tasks执行行完毕，回调到completion
- (void)asynExecuteCompletion:(CommonBlock)completion tasks:(CommonBlock)task, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark -
- (NSString *)className;

+ (NSString *)className;
@end
