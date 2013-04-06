//
//  SimpleFlowLayout.m
//  FlickSearch
//
//  Created by Long Vinh Nguyen on 4/6/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "SimpleFlowLayout.h"

@implementation SimpleFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    _insertedIndexPaths = [NSMutableArray new];
    _deletedIndexPaths = [NSMutableArray new];
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            [_insertedIndexPaths addObject:updateItem.indexPathAfterUpdate];
        } else if (updateItem.updateAction == UICollectionUpdateActionDelete) {
            [_deletedIndexPaths addObject:updateItem.indexPathBeforeUpdate];
        }
    }
    NSLog(@"SimpleLayout %d %d",_insertedIndexPaths.count, _deletedIndexPaths.count);
}

- (void)finalizeCollectionViewUpdates
{
    [_insertedIndexPaths removeAllObjects];
    [_deletedIndexPaths removeAllObjects];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if ([_insertedIndexPaths containsObject:itemIndexPath]) {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
        
        CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
        attributes.center = CGPointMake(CGRectGetMidX(visibleRect),CGRectGetMidY(visibleRect));
        attributes.alpha = 0.0f;
        attributes.transform3D = CATransform3DMakeScale(0.6f, 0.6f, 1.0f);
        
        return attributes;
        
    } else {
        return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    }
}


- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if ([_deletedIndexPaths containsObject:itemIndexPath]) {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
        CGRect visibleRect = (CGRect) {
            .origin = self.collectionView.contentOffset,
            .size = self.collectionView.bounds.size
        };
        attributes.center = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        attributes.alpha = 0.0f;
        attributes.transform3D = CATransform3DMakeScale(1.3f, 1.3f, 1.0f);
        return attributes;
    } else {
        return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    }
}

















@end
