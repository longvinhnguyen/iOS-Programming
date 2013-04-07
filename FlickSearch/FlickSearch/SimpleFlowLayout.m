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
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    NSLog(@"Initial Layout %d", _insertedIndexPaths.count);
    if ([_insertedIndexPaths containsObject:itemIndexPath]) {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
        
        CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
        attributes.center = CGPointMake(CGRectGetMidX(visibleRect),CGRectGetMidY(visibleRect));
        attributes.alpha = 0.3f;
        attributes.transform3D = CATransform3DMakeScale(0.6f, 0.6f, 1.0f);
        
        return attributes;
        
    } else {
        return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    }
}


- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    NSLog(@"Deleted Layout  %d", _deletedIndexPaths.count);
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

- (void)finalizeCollectionViewUpdates
{
    [_insertedIndexPaths removeAllObjects];
    [_deletedIndexPaths removeAllObjects];
}

















@end
