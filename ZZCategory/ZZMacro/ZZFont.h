//
//  Font.h
//  ZZCategory
//
//  Created by zhaozhe on 16/12/6.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#ifndef ZZFont_h
#define ZZFont_h

#pragma mark - 通用
#define Font(x)      [UIFont systemFontOfSize:x]
#define WeightFont(x,h)   [UIFont systemFontOfSize:x weight:h]
#define BoldFont(x)  [UIFont boldSystemFontOfSize:x]
//收屏幕比例缩放影响的字体适配
#define AdaptedFont(x)     [UIFont systemFontOfSize:FloatAdapted(x)]
#define AdaptedBoldFont(x) [UIFont boldSystemFontOfSize:FloatAdapted(x)]

#define LightAdaptedFont(x)     [UIFont systemFontOfSize:LightAdapted(x)]
//适配 5s和6字体相同 6plus大一号
#define StandardFont(x) kScreenW != 414 ? Font(x) : Font(x + 1)
#define StandardBoldFont(x) kScreenW != 414 ? BoldFont(x) : BoldFont(x + 1)

#endif /* ZZFont_h */
