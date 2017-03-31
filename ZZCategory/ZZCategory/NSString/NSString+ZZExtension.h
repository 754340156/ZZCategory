//
//  NSString+ZZExtension.h
//  ZZCategory
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (ZZExtension)
/// 验证字符串为空 ,为空:YES, 不为空:NO
+ (BOOL)StringIsNULL:(NSString *)string;

/// 验证手机号码, 正确:YES , 错误: 提示
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//判断是否全为中文
+(BOOL)isValidateHomePhoneNum:(NSString *)string;

//有效的验证码(根据自家的验证码位数进行修改)
- (BOOL) isValidVerifyCode;

//判断某个字符串的长度是否在某个范围内0除外
- (BOOL)RangeMinNum:(int) minNum maxNum:(int) maxNum;

//判断是否只有数字或字母
- (BOOL)isOnlyNumAndLetter;

//判断是否是微信
+ (BOOL)isWheatNumber:(NSString *)str;

//判断是否全为数字
+ (BOOL)isPureNumandCharacters:(NSString *)string;

//判断是否身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard;

/* 判断文本是否包含emoji */
+ (BOOL)isContainsEmoji:(NSString *)string;

//银行卡判断  -——>不适合16位以上信用卡的判断
+ (BOOL)isValidCreditNumber:(NSString*)value;

//根据字符计算高度
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constrainedToWidth:(CGFloat)width;
// 去除尾部space, /n, /t
+(NSString*)trimWithstring:(NSString *)string;
#pragma mark - time
//通过时间戳计算时间差（几小时前、几天前）
+ (NSString *) compareCurrentTime:(NSTimeInterval) compareDate;

//通过时间戳得出显示时间
+ (NSString *) getDateStringWithTimestamp:(NSTimeInterval)timestamp;

//通过时间戳和格式显示时间
+ (NSString *) getStringWithTimestamp:(NSTimeInterval)timestamp formatter:(NSString*)formatter;
#pragma mark - MD5
- (NSString *) md5WithString;//MD5加密
#pragma mark - get
//如果字符串长度大于min, 截取min长度的字符串
- (NSString *)getSubStringNotLongThanLength:(NSInteger)length;

//去除一个字符串的某个字串
- (NSString *)removeString:(NSString *)string;

//将一个字符串后N位,转换为某个字符串
- (NSString *)getStringCoverLastLength:(NSInteger)length
                             newString:(NSString *)newString;

//将一个字符串按照某个格式进行空格
- (NSString *)getStringLikeFormatString:(NSString *)formatString;

//将一个字符串在固定的N个位置插入某个字符
- (NSString *)insetedSubString:(NSString *)subString
                  atIndexArray:(NSArray *)indexArray;
/**  将阿拉伯数字转换为中文数字 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum;
#pragma mark - search 
//获取汉字转成拼音字符串
+ (NSString *)transformToPinyin:(NSString *)aString;

@end
