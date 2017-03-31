//
//  NSString+ZZExtension.m
//  ZZCategory
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import "NSString+ZZExtension.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (ZZExtension)
/// 验证字符串为空 ,为空:YES, 不为空:NO
+ (BOOL)StringIsNULL:(NSString *)string
{
    if (string == nil || string == NULL || [string  isEqual:NULL]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}
/// 验证手机号码, 正确:YES , 错误: 提示
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    //NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[06-8]|8[0-9])\\d{8}$";
    NSString *MOBILE = @"^((13[0-9])|(15[0-9])|(18[0-9])|(17[0-9])|(14[0-9]))\\d{8}$";
    //NSString *MOBILE = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    return NO;
}

//判断某个字符串的长度是否在某个范围内0除外
- (BOOL)RangeMinNum:(int) minNum maxNum:(int) maxNum
{
    if ((self.length>=minNum)&&(self.length<=maxNum)&&(self.length!=0))
    {
        return YES;
    }
    return NO;
}
//判断是否只有数字或字母
- (BOOL)isOnlyNumAndLetter;
{
    NSString *regex = @"[a-z][A-Z][0-9]";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:self] == YES) {
        return YES;
    }
    return NO;
}
//判断是否全为中文
+(BOOL)isValidateHomePhoneNum:(NSString *)string
{
    // 只需要不是中文即可
    NSString *regex = @".{0,}[\u4E00-\u9FA5].{0,}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    BOOL res = [predicate evaluateWithObject:string];
    if (res == TRUE) {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}
- (BOOL) isValidVerifyCode
{
    NSString *pattern = @"^[0-9]{6}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:self];
}
+ (BOOL)isWheatNumber:(NSString *)str
{
    
    NSString *regex = @"^[a-zA-Zd_]{5,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    BOOL res = [predicate evaluateWithObject:str];
    if (res) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

/* 判断文本是否包含emoji */
+ (BOOL)isContainsEmoji:(NSString *)string{
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             
             if (0x2100 <= hs && hs <= 0x27ff /*&& hs != 0x263b*/) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 /*|| hs == 0x231a*/ ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}
//银行卡判断  -——>不适合16位以上信用卡的判断
+ (BOOL)isValidCreditNumber:(NSString*)value
{
    BOOL result = TRUE;
    NSInteger length = [value length];
    if (length >= 13)
    {
        result = [NSString  isPureNumandCharacters:value];
        if (result)
        {
            NSInteger twoDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 2)] integerValue];
            NSInteger threeDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 3)] integerValue];
            NSInteger fourDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 4)] integerValue];
            //Diner's Club
            if (((threeDigitBeginValue >= 300 && threeDigitBeginValue <= 305)||
                 fourDigitBeginValue == 3095||twoDigitBeginValue==36||twoDigitBeginValue==38) && (14 != length))
            {
                result = FALSE;
            }
            //VISA
            else if([value  hasPrefix :@"4"] && !(13 == length||16 == length))
            {
                result = FALSE;
            }
            //MasterCard
            else if((twoDigitBeginValue >= 51||twoDigitBeginValue <= 55) && (16 != length))
            {
                result = FALSE;
            }
            //American Express
            else if(([value  hasPrefix :@"34"]||[value hasPrefix:@"37"]) && (15 != length))
            {
                result = FALSE;
            }
            //Discover
            else if([value hasPrefix:@"6011"] && (16 != length))
            {
                result = FALSE;
            }
            else
            {
                NSInteger begin = [[value substringWithRange:NSMakeRange(0, 6)] integerValue];
                //CUP
                if ((begin >= 622126 && begin <= 622925) && (16 != length))
                {
                    result = FALSE;
                }
                //other
                else
                {
                    result = TRUE;
                }
            }
        }
        if (result)
        {
            NSInteger digitValue;
            NSInteger checkSum = 0;
            NSInteger index = 0;
            NSInteger leftIndex;
            //even length, odd index
            if (0 == length%2)
            {
                index = 0;
                leftIndex = 1;
            }
            //odd length, even index
            else
            {
                index = 1;
                leftIndex = 0;
            }
            while (index < length)
            {
                digitValue = [[value substringWithRange:NSMakeRange(index, 1)] integerValue];
                digitValue = digitValue*2;
                if (digitValue >= 10)
                {
                    checkSum += digitValue/10 + digitValue%10;
                }
                else
                {
                    checkSum += digitValue;
                }
                digitValue = [[value substringWithRange:NSMakeRange(leftIndex, 1)] integerValue];
                checkSum += digitValue;
                index += 2;
                leftIndex += 2;
            }
            result = (0 == checkSum%10) ? TRUE:FALSE;
        }
    }
    else
    {
        result = FALSE;
    }
    return result;
    
}
#pragma mark - 计算文本
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constrainedToWidth:(CGFloat)width{
    
    
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:(NSStringDrawingUsesLineFragmentOrigin |
                                                 NSStringDrawingTruncatesLastVisibleLine)
                                     attributes:attributes
                                        context:nil].size;
    } else
    {
        textSize = [string sizeWithFont:textFont
                      constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                    options:(NSStringDrawingUsesLineFragmentOrigin |
                                             NSStringDrawingTruncatesLastVisibleLine)
                                 attributes:attributes
                                    context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    
}
// 去除尾部space, /n, /t
+(NSString*)trimWithstring:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
#pragma mark - time
+(NSString *) compareCurrentTime:(NSTimeInterval) compareDate
{
    
    NSDate *confromTimesp        = [NSDate dateWithTimeIntervalSince1970:compareDate/1000];
    
    NSTimeInterval  timeInterval = [confromTimesp timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    
    NSCalendar *calendar     = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents*referenceComponents=[calendar components:unitFlags fromDate:confromTimesp];
    NSInteger referenceHour  =referenceComponents.hour;
    
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp= timeInterval/60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = timeInterval/3600) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if ((temp = timeInterval/3600/24)==1)
    {
        result = [NSString stringWithFormat:@"昨天%ld时",(long)referenceHour];
    }
    else if ((temp = timeInterval/3600/24)==2)
    {
        result = [NSString stringWithFormat:@"前天%ld时",(long)referenceHour];
    }
    
    else if((temp = timeInterval/3600/24) <31){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = timeInterval/3600/24/30) <12){
        result = [NSString stringWithFormat:@"%ld个月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}
+ (NSString*) getDateStringWithTimestamp:(NSTimeInterval)timestamp
{
    NSDate *confromTimesp    = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSCalendar *calendar     = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents*referenceComponents=[calendar components:unitFlags fromDate:confromTimesp];
    NSInteger referenceYear  =referenceComponents.year;
    NSInteger referenceMonth =referenceComponents.month;
    NSInteger referenceDay   =referenceComponents.day;
    
    return [NSString stringWithFormat:@"%ld年%ld月%ld日",referenceYear,(long)referenceMonth,(long)referenceDay];
}



+ (NSString*) getStringWithTimestamp:(NSTimeInterval)timestamp formatter:(NSString*)formatter
{
    if ([NSString stringWithFormat:@"%@", @(timestamp)].length == 13) {
        timestamp /= 1000.0f;
    }
    NSDate*timestampDate=[NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *strDate = [dateFormatter stringFromDate:timestampDate];
    
    return strDate;
}
#pragma mark - MD5
- (NSString *) md5WithString
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [NSString stringWithString:outputString];
}
#pragma mark - get
//如果字符串长度大于min, 截取min长度的字符串
- (NSString *)getSubStringNotLongThanLength:(NSInteger)length
{
    if (self.length > length)
    {
        return [self substringToIndex:length];
    }
    return self;
}

//去除一个字符串的某个字串
- (NSString *)removeString:(NSString *)string
{
    return [self stringByReplacingOccurrencesOfString:string withString:@""];
}

//将一个字符串后N位,转换为某个字符串
- (NSString *)getStringCoverLastLength:(NSInteger)length
                             newString:(NSString *)newString
{
    if (self.length > length)
    {
        NSString *frontSubString = [self substringToIndex:self.length - length];
        return [NSString stringWithFormat:@"%@%@", frontSubString, newString];
    }
    return self;
}

//将一个字符串按照某个格式进行空格
- (NSString *)getStringLikeFormatString:(NSString *)formatString
{
    NSMutableString *newstring = [NSMutableString stringWithString:[self removeString:@" "]];
    
    for (int i = 0; i < formatString.length; i++)
    {
        if (newstring.length <= i)
        {
            break;
        }
        NSString *charString = [formatString substringWithRange:NSMakeRange(i, 1)];
        if ([charString isEqualToString:@" "])
        {
            NSString *newCharString = [newstring substringWithRange:NSMakeRange(i, 1)];
            if (![newCharString isEqualToString:@" "])
            {
                [newstring insertString:@" " atIndex:i];
            }
        }
    }
    return [NSString stringWithString:newstring];
}

//将一个字符串在固定的N个位置插入某个字符
- (NSString *)insetedSubString:(NSString *)subString
                  atIndexArray:(NSArray *)indexArray
{
    NSMutableString *muString = [NSMutableString stringWithString:[self removeString:@" "]];
    for (NSNumber *number in indexArray)
    {
        NSInteger index = [number integerValue];
        if (muString.length <= index)
        {
            break;
        }
        if ([[muString substringWithRange:NSMakeRange(index, 1)] isEqualToString:subString])
        {
            continue;
        }
        [muString insertString:subString atIndex:index];
    }
    return [NSString stringWithString:muString];
}
/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}
#pragma mark - search
//获取汉字转成拼音字符串  通讯录模糊搜索 支持拼音检索 首字母 全拼 汉字 搜索
+ (NSString *)transformToPinyin:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    int count = 0;
    
    for (int  i = 0; i < pinyinArray.count; i++)
    {
        
        for(int i = 0; i < pinyinArray.count;i++)
        {
            if (i == count) {
                [allString appendString:@"#"];//区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
            
        }
        [allString appendString:@","];
        count ++;
        
    }
    
    NSMutableString *initialStr = [NSMutableString new];//拼音首字母
    
    for (NSString *s in pinyinArray)
    {
        if (s.length > 0)
        {
            
            [initialStr appendString:  [s substringToIndex:1]];
        }
    }
    
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",aString];
    
    return allString;
}
@end
