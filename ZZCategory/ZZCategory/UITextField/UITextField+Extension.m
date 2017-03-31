//
//  UITextField+Extension.m
//  ZZTools
//
//  Created by zhaozhe on 16/12/6.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)
//设置全局颜色
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textColor = DDM_BlackColor;
    }
    return self;
}
@end
