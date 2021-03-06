//
//  Tools.h
//  ZZCategory
//
//  Created by zhaozhe on 16/12/6.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#ifndef ZZTools_h
#define ZZTools_h

//让NSLog在debug模式下有效, release模式下失效
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

//判断代理简写
#define JudgeDelegate(delegate,Sel) (delegate && [delegate respondsToSelector:@selector(Sel)])
//本地存
#define WriteForLocation(OBJECT,KEY) \
[[NSUserDefaults standardUserDefaults] setObject:OBJECT forKey:KEY];\
[[NSUserDefaults standardUserDefaults] synchronize];

//本地取
#define ReadForLocation(KEY)         [[NSUserDefaults standardUserDefaults] objectForKey:KEY]

//Library/Caches 文件路径
#define FilePath ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])

//获取temp
#define kPathTemp NSTemporaryDirectory()

//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//weak self
#define WS(weakSelf)  __weak __typeof(self)weakSelf = self;
//与之对应的 strong self
#define SS(strongSelf) __strong typeof(weakSelf) strongSelf = weakSelf;

/***********************判断***********************/
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//判断手机尺寸
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6_P ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )
#endif /* ZZTools_h */
