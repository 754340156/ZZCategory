//
//  UIImage+ZZExtension.m
//  ZZCategory
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import "UIImage+ZZExtension.h"
#import <Accelerate/Accelerate.h>
@implementation UIImage (ZZExtension)
- (UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
- (UIColor *)colorAtPoint:(CGPoint )point
{
    if (point.x < 0 || point.y < 0) return nil;
    
    CGImageRef imageRef = self.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    if (point.x >= width || point.y >= height) return nil;
    // 申请内存 w*h*pixel
    unsigned char *rawData = malloc(height * width * 4);
    if (!rawData) return nil;
    // 指定颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    // 创建图形上下文
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast
                                                 | kCGBitmapByteOrder32Big);
    if (!context) {
        free(rawData);
        return nil;
    }
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    // 遍历寻找所要寻找位置的颜色，像素矩阵
    int byteIndex = (bytesPerRow * point.y) + point.x * bytesPerPixel;
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    
    UIColor *result = nil;
    result = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    free(rawData);
    return result;
}
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *)imageWithColor:(UIColor *)color text:(NSString *)name
{
    CGRect rect = CGRectMake(0, 0, 50, 50);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    [name drawAtPoint:CGPointMake(10, 15) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
+ (UIImage*)covertToGrayImageFromImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    // 指定颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    // 创建图形上下文
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    // 绘制图片
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    // 得到图片
    UIImage *grayImage = [UIImage imageWithCGImage:contextRef];
    CGContextRelease(context);
    CGImageRelease(contextRef);
    
    return grayImage;
}
+ (UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur;
{
    // 模糊度越界
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}
+ (UIImage *)circleImage:(UIImage *)originImage borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    //设置边框宽度
    CGFloat imageWH = originImage.size.width;
    
    //计算外圆的尺寸
    CGFloat ovalWH = imageWH + 2 * borderWidth;
    
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), NO, 0);
    
    //画一个大的圆形
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalWH, ovalWH)];
    
    [borderColor set];
    
    [path fill];
    
    //设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderWidth, borderWidth, imageWH, imageWH)];
    [clipPath addClip];
    
    //绘制图片
    [originImage drawAtPoint:CGPointMake(borderWidth, borderWidth)];
    
    //从上下文中获取图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    return resultImage;
}
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize {
    UIImage *image = [self imageWithAlpha];
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 image.size.width,
                                                 image.size.height,
                                                 CGImageGetBitsPerComponent(image.CGImage),
                                                 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));
    
    CGContextBeginPath(context);
    [self addRoundedRectToPath:CGRectMake(borderSize, borderSize, image.size.width - borderSize * 2, image.size.height - borderSize * 2)
                       context:context
                     ovalWidth:cornerSize
                    ovalHeight:cornerSize];
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight {
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
    CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}
- (BOOL)hasAlpha
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
}

- (UIImage *)imageWithAlpha
{
    if ([self hasAlpha])
    {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height, 8, 0, CGImageGetColorSpace(imageRef), kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}
- (UIImage *)roundImage{
    
    //获取size
    CGSize size = [self sizeFromImage:self];
    
    CGRect rect = (CGRect){CGPointZero,size};
    
    //新建一个图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //绘制圆形路径
    CGContextAddEllipseInRect(ctx, rect);
    
    //剪裁上下文
    CGContextClip(ctx);
    
    //绘制图片
    [self drawInRect:rect];
    
    //取出图片
    UIImage *roundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束上下文
    UIGraphicsEndImageContext();
    
    return roundImage;
}


- (CGSize)sizeFromImage:(UIImage *)image{
    
    CGSize size = image.size;
    
    CGFloat wh =MIN(size.width, size.height);
    
    return CGSizeMake(wh, wh);
}

+ (UIImage *)cutScreen
{
    return [self cutFromView:[UIApplication sharedApplication].keyWindow];
}

+ (UIImage *)cutFromView:(UIView *)view
{
    
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0f);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //在新建的图形上下文中渲染view的layer
    [view.layer renderInContext:context];
    
    [[UIColor clearColor] setFill];
    
    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (UIImage *)cutWithFrame:(CGRect)frame{
    
    //创建CGImage
    CGImageRef cgimage = CGImageCreateWithImageInRect(self.CGImage, frame);
    
    //创建image
    UIImage *newImage=[UIImage imageWithCGImage:cgimage];
    
    //释放CGImage
    CGImageRelease(cgimage);
    
    return newImage;
}
#pragma mark - 水印
/**
 *  文字水印
 *
 *  @param text      文字
 *  @param direction 文字方向
 *  @param fontColor 文字颜色
 *  @param fontPoint 字体
 *  @param marginXY   对齐点
 *
 */
- (UIImage *)waterWithText:(NSString *)text
                 direction:(ImageWaterDirect)direction
                 fontColor:(UIColor *)fontColor
                 fontPoint:(CGFloat)fontPoint
                  marginXY:(CGPoint)marginXY
{
    
    CGSize size = self.size;
    
    CGRect rect = (CGRect){CGPointZero,size};
    
    //新建图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //绘制图片
    [self drawInRect:rect];
    
    //绘制文本
    NSDictionary *attr =@{NSFontAttributeName : [UIFont systemFontOfSize:fontPoint],NSForegroundColorAttributeName:fontColor};
    
    CGRect strRect = [self calWidth:text attr:attr direction:direction rect:rect marginXY:marginXY];
    
    [text drawInRect:strRect withAttributes:attr];
    
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束图片图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  绘制图片水印
 *
 *  @param waterImage 图片水印
 *  @param direction  方向
 *  @param waterSize  水印大小
 *  @param marginXY   对齐点
 *
 */
- (UIImage *)waterWithWaterImage:(UIImage *)waterImage
                       direction:(ImageWaterDirect)direction
                       waterSize:(CGSize)waterSize
                        marginXY:(CGPoint)marginXY
{
    
    CGSize size = self.size;
    
    CGRect rect = (CGRect){CGPointZero,size};
    
    //新建图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //绘制图片
    [self drawInRect:rect];
    
    //计算水印的rect
    CGSize waterImageSize = CGSizeEqualToSize(waterSize, CGSizeZero)?waterImage.size:waterSize;
    CGRect calRect = [self rectWithRect:rect size:waterImageSize direction:direction marginXY:marginXY];
    
    //绘制水印图片
    [waterImage drawInRect:calRect];
    
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束图片图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (CGRect)calWidth:(NSString *)str
              attr:(NSDictionary *)attr
         direction:(ImageWaterDirect)direction
              rect:(CGRect)rect
          marginXY:(CGPoint)marginXY{
    
    CGSize size =  [str sizeWithAttributes:attr];
    
    CGRect calRect = [self rectWithRect:rect size:size direction:direction marginXY:marginXY];
    
    return calRect;
}
- (CGRect)rectWithRect:(CGRect)rect
                  size:(CGSize)size
             direction:(ImageWaterDirect)direction
              marginXY:(CGPoint)marginXY{
    
    CGPoint point = CGPointZero;
    
    //右上
    if(ImageWaterDirectTopRight == direction) point = CGPointMake(rect.size.width - size.width, 0);
    
    //左下
    if(ImageWaterDirectBottomLeft == direction) point = CGPointMake(0, rect.size.height - size.height);
    
    //右下
    if(ImageWaterDirectBottomRight == direction) point = CGPointMake(rect.size.width - size.width, rect.size.height - size.height);
    
    //正中
    if(ImageWaterDirectCenter == direction) point = CGPointMake((rect.size.width - size.width)*.5f, (rect.size.height - size.height)*.5f);
    
    point.x+=marginXY.x;
    point.y+=marginXY.y;
    
    CGRect calRect = (CGRect){point,size};
    
    return calRect;
}
#pragma mark - 图片透明度
- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

//设置图片透明度
- (UIImage *)imageWithAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    if (!tintColor) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn)
    {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}
#pragma mark - 图片压缩
/**
 图片压缩的逻辑:
 一:图片尺寸压缩 主要分为以下几种情况 一般参照像素为1280
 a.图片宽高均≤1280px时，图片尺寸保持不变;
 b.宽或高均＞1280px时 ——图片宽高比≤2，则将图片宽或者高取大的等比压缩至1280px; ——但是图片宽高比＞2时，则宽或者高取小的等比压缩至1280px;
 c.宽高一个＞1280px，另一个＜1280px，--图片宽高比＞2时，则宽高尺寸不变;--但是图片宽高比≤2时,则将图片宽或者高取大的等比压缩至1280px.
 
 二:图片质量压缩
 一般图片质量都压缩在90%就可以了
 */
+ (NSData *)imageCompressForSize:(UIImage *)sourceImage targetPx:(NSInteger)targetPx
{
    UIImage *newImage = nil;  // 尺寸压缩后的新图片
    CGSize imageSize = sourceImage.size; // 源图片的size
    CGFloat width = imageSize.width; // 源图片的宽
    CGFloat height = imageSize.height; // 原图片的高
    BOOL drawImge = NO;   // 是否需要重绘图片 默认是NO
    CGFloat scaleFactor = 0.0;  // 压缩比例
    CGFloat scaledWidth = targetPx;  // 压缩时的宽度 默认是参照像素
    CGFloat scaledHeight = targetPx; // 压缩是的高度 默认是参照像素
    
    // 先进行图片的尺寸的判断
    
    // a.图片宽高均≤参照像素时，图片尺寸保持不变
    if (width < targetPx && height < targetPx) {
        newImage = sourceImage;
    }
    // b.宽或高均＞1280px时
    else if (width > targetPx && height > targetPx) {
        drawImge = YES;
        CGFloat factor = width / height;
        if (factor <= 2) {
            // b.1图片宽高比≤2，则将图片宽或者高取大的等比压缩至1280px
            if (width > height) {
                scaleFactor  = targetPx / width;
            } else {
                scaleFactor = targetPx / height;
            }
        } else {
            // b.2图片宽高比＞2时，则宽或者高取小的等比压缩至1280px
            if (width > height) {
                scaleFactor  = targetPx / height;
            } else {
                scaleFactor = targetPx / width;
            }
        }
    }
    // c.宽高一个＞1280px，另一个＜1280px 宽大于1280
    else if (width > targetPx &&  height < targetPx ) {
        if (width / height > 2) {
            newImage = sourceImage;
        } else {
            drawImge = YES;
            scaleFactor = targetPx / width;
        }
    }
    // c.宽高一个＞1280px，另一个＜1280px 高大于1280
    else if (width < targetPx &&  height > targetPx) {
        if (height / width > 2) {
            newImage = sourceImage;
        } else {
            drawImge = YES;
            scaleFactor = targetPx / height;
        }
    }
    
    // 如果图片需要重绘 就按照新的宽高压缩重绘图片
    if (drawImge == YES) {
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
        // 绘制改变大小的图片
        [sourceImage drawInRect:CGRectMake(0, 0, scaledWidth,scaledHeight)];
        // 从当前context中创建一个改变大小后的图片
        newImage =UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
    }
    // 防止出错  可以删掉的
    if (newImage == nil) {
        newImage = sourceImage;
    }
    
    // 如果图片大小大于200kb 在进行质量上压缩
    NSData * scaledImageData = nil;
    if (UIImageJPEGRepresentation(newImage, 1) == nil) {
        scaledImageData = UIImagePNGRepresentation(newImage);
    }else{
        scaledImageData = UIImageJPEGRepresentation(newImage, 1);
        if (scaledImageData.length >= 1024 * 200) {
            scaledImageData = UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    
    return scaledImageData;
    
}
@end
