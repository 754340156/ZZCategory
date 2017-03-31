//
//  NSArray+Extension.m
//  ZZTools
//
//  Created by zhaozhe on 16/12/6.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)
//包含某个字符串
- (BOOL)isHaveString:(NSString *)string
{
    for (id obj in self)
    {
        if ([obj isKindOfClass:[NSString class]])
        {
            if ([obj isEqualToString:string])
            {
                return YES;
            }
        }
    }
    return NO;
}
@end
