//
//  PinchLayout.m
//  FlickSearch
//
//  Created by Long Vinh Nguyen on 4/9/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "PinchLayout.h"

@implementation PinchLayout

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self applySettingToAttributes:attributes];
    return attributes;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    [layoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop)
    {
        [self applySettingToAttributes:attributes];
    }];
    return layoutAttributes;
}

- (void)applySettingToAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    NSIndexPath *indexPath = attributes.indexPath;
    attributes.zIndex = -indexPath.item;
    
    CGFloat deltaX = self.pinchCenter.x - attributes.center.x;
    CGFloat deltaY = self.pinchCenter.y - attributes.center.y;
    CGFloat scale = 1.0f - self.pinchScale;
    
    CATransform3D transaform =CATransform3DMakeTranslation(deltaX * scale, deltaY * scale, 0.0f);
    attributes.transform3D = transaform;

}

- (void)setPinchCenter:(CGPoint)pinchCenter
{
    _pinchCenter = pinchCenter;
    [self invalidateLayout];
}

- (void)setPinchScale:(CGFloat)pinchScale
{
    _pinchScale = pinchScale;
    [self invalidateLayout];
}











@end
