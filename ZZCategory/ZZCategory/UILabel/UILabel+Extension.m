//
//  UILabel+Extension.m
//  ZZCategory
//
//  Created by zhaozhe on 16/12/6.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)
//设置全局颜色
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textColor = DDM_BlackColor;
    }
    return self;
}
//计算字符串宽度(单行)
- (CGFloat)getWidth
{
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    return rect.size.width;
}

//计算字符串的高度(单行)
- (CGFloat)getHeight
{
    CGSize size = [@"哈哈" sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGFloat height = ceilf(size.height);
    NSInteger lineNum = (self.numberOfLines == 0) ? 1 : self.numberOfLines;
    return height * lineNum;
}


//计算文字绘制所需大小
- (CGSize)getSize
{
    return [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
}

//计算文字绘制所需大小
- (CGSize)getSizeWithWidth:(CGFloat)width
{
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}

//计算文字绘制所需大小
+ (CGFloat)getHeightWithFont:(UIFont *)font
{
    CGRect rect = [@"哈哈" boundingRectWithSize:CGSizeMake(1000, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return ceilf(rect.size.height);
}

//计算文字绘制所需宽度
+ (CGFloat)getWidthWithFont:(UIFont *)font text:(NSString *)text
{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat width = ceilf(size.width);
    return width;
}

//计算文字绘制所需宽度
- (CGFloat)getWidthWithText:(NSString *)text
{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGFloat width = ceilf(size.width);
    return width;
}

//根据字体,宽度绘制所需高度
+ (CGFloat)getHeightWithFont:(UIFont *)font Width:(CGFloat)width text:(NSString *)text
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return ceilf(rect.size.height);
}
+ (CGSize)getSizeFont:(UIFont *)font text:(NSString *)text
{
    return [text sizeWithAttributes:@{NSFontAttributeName:font}];
}
+ (instancetype)label
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    return label;
}

+ (instancetype)labelWithTitle:(NSString *)title
{
    UILabel *label = [UILabel label];
    
    label.text = title;
    return label;
}
- (CGSize)contentSize
{
    return [self textSizeIn:self.bounds.size];
}

- (CGSize)textSizeIn:(CGSize)size
{
    NSLineBreakMode breakMode = self.lineBreakMode;
    UIFont *font = self.font;
    
    CGSize contentSize = CGSizeZero;
    //    if ([IOSDeviceConfig sharedConfig].isIOS7)
    //    {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = breakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary* attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle};
    contentSize = [self.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    //    }
    //    else
    //    {
    //        contentSize = [self.text sizeWithFont:font constrainedToSize:size lineBreakMode:breakMode];
    //    }
    
    
    contentSize = CGSizeMake(ceilf(contentSize.width), ceilf(contentSize.width));
    return contentSize;
}

//- (void)layoutInContent
//{
//    CGSize size = [self contentSize];
//    CGRect rect = self.frame;
//    rect.size = size;
//    self.frame = rect;
//}
//
/**  设置中划线 */
- (void)setMidStrikethrough
{
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.text attributes:attribtDic];
    self.attributedText = attribtStr;
}
/**  设置下划线 */
- (void)setUnderlineWithRange:(NSRange)range
{
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attribtStr addAttributes:attribtDic range:range];
    self.attributedText = attribtStr;
}
@end
@implementation InsetLabel


- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _contentInset)];
}


- (CGSize)contentSize
{
    CGRect rect = UIEdgeInsetsInsetRect(self.bounds, _contentInset);
    CGSize size = [super textSizeIn:rect.size];
    return CGSizeMake(size.width + _contentInset.left + _contentInset.right, size.height + _contentInset.top + _contentInset.bottom);
}

- (CGSize)textSizeIn:(CGSize)size
{
    size.width -= _contentInset.left + _contentInset.right;
    size.height -= _contentInset.top + _contentInset.bottom;
    CGSize textSize = [super textSizeIn:size];
    return CGSizeMake(textSize.width + _contentInset.left + _contentInset.right, textSize.height + _contentInset.top + _contentInset.bottom);
}

@end
