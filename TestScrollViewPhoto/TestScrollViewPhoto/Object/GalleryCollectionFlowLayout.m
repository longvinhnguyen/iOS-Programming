//
//  GalleryCollectionFlowLayout.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 8/21/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "GalleryCollectionFlowLayout.h"

@implementation GalleryCollectionFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    NSLog(@"Item %d - Frame %f %f %f %f", indexPath.item, attributes.frame.origin.x, attributes.frame.origin.y, attributes.frame.size.width, attributes.frame.size.height);
    
    
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [super layoutAttributesForElementsInRect:rect];
}

@end
