
//
//  UICollectionViewFlowLayout+Extension.m
//  DiDiBeauty
//
//  Created by zhaozhe on 17/1/18.
//  Copyright © 2017年 zhaozhe. All rights reserved.
//

#import "UICollectionViewFlowLayout+Extension.h"

#import <objc/objc.h>
static NSString *isPagingEnableKey = @"isPagingEnableKey";

@implementation UICollectionViewFlowLayout (Extension)
- (void)setPagingEnable:(BOOL)pagingEnable
{
    objc_setAssociatedObject(self, &isPagingEnableKey, @(pagingEnable), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)pagingEnable
{
    return objc_getAssociatedObject(self, &isPagingEnableKey);
}
#pragma mark - pagingEnable
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if (self.pagingEnable) {
        //1.计算scrollview最后停留的范围
        CGRect lastRect ;
        lastRect.origin = proposedContentOffset;
        lastRect.size = self.collectionView.frame.size;
        
        //2.取出这个范围内的所有属性
        NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
        
        //起始的x值，也即默认情况下要停下来的x值
        CGFloat startX = proposedContentOffset.x;
        
        //3.遍历所有的属性
        CGFloat adjustOffsetX = MAXFLOAT;
        for (UICollectionViewLayoutAttributes *attrs in array) {
            CGFloat attrsX = CGRectGetMinX(attrs.frame);
            CGFloat attrsW = CGRectGetWidth(attrs.frame) ;
            
            if (startX - attrsX  < attrsW/2) {
                adjustOffsetX = -(startX - attrsX+self.minimumInteritemSpacing);
            }else{
                adjustOffsetX = attrsW - (startX - attrsX);
            }
            
            break ;//只循环数组中第一个元素即可，所以直接break了
        }
        return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
    }
    return proposedContentOffset;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return self.pagingEnable ?  YES : NO;
}
@end
