//
//  StackedGridLayout.m
//  FlickSearch
//
//  Created by Long Vinh Nguyen on 4/11/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "StackedGridLayout.h"
#import "StackedGridLayoutSection.h"

@implementation StackedGridLayout
{
    __weak id <StackedGridLayoutDelegate> _myDelegate;
    NSMutableArray *sectionData;
    CGFloat _height;
}


- (void)prepareLayout
{
    // 1
    [super prepareLayout];
    
    // 2
    _myDelegate = (id<StackedGridLayoutDelegate>)self.collectionView.delegate;
    sectionData = [[NSMutableArray alloc] init];
    _height = 0.0f;
    
    // 3
    CGPoint currentOrigin = CGPointZero;
    NSInteger numberOfSections = self.collectionView.numberOfSections;

    VLLog(@"Number of sections: %d",numberOfSections);
    
    // 4
    for (int i = 0; i < numberOfSections; i++) {
        
        // 5
        _height = self.headerHeight;
        currentOrigin.y = _height;
        
        // 6
        NSInteger numberOfColumns = [_myDelegate collectionView:self.collectionView layout:self numberOfColumnsInSection:i];
        
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:i];
        
        UIEdgeInsets itemInsets = [_myDelegate collectionView:self.collectionView layout:self itemInsetsForSectionAtIndex:i];
        
        // 7
        StackedGridLayoutSection *section = [[StackedGridLayoutSection alloc] initWithOrigin:currentOrigin width:self.collectionView.bounds.size.width columns:numberOfColumns itemInsets:itemInsets];
        
        
        // 8
        for (int j = 0; j < numberOfItems; j++) {
            // 9
            CGFloat itemWidth = (section.columnWidth - section.itemInsets.left - section.itemInsets.right);
            NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            CGSize itemSize = [_myDelegate collectionView:self.collectionView layout:self sizeForItemWithWidth:itemWidth atIndexPath:itemIndexPath];
            
            // 10
            [section addItemOfSize:itemSize forIndex:j];
        }
        
        // 11
        [sectionData addObject:section];
        
        // 12
        _height += section.frame.size.height;
        VLLog(@"Height of section: %f",section.frame.size.height);
        currentOrigin.y = _height;
        
    }
    
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.bounds.size.width, _height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StackedGridLayoutSection *section = sectionData[indexPath.section];
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.frame = [section frameForItemAtIndex:indexPath.item];
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    StackedGridLayoutSection *section = sectionData[indexPath.section];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect sectionFrame = section.frame;
    CGRect headerFrame = CGRectMake(0.0f, sectionFrame.origin.y - self.headerHeight, sectionFrame.size.width, self.headerHeight);
    
    attributes.frame = headerFrame;
    
    return attributes;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 1
    NSMutableArray *attributes = [NSMutableArray new];
    
    // 2
    [sectionData enumerateObjectsUsingBlock:^(StackedGridLayoutSection *section, NSUInteger sectionIndex, BOOL *stop) {
        // 3
        CGRect sectionFrame = section.frame;
        CGRect headerFrame = CGRectMake(0.0f, section.frame.origin.y - self.headerHeight, sectionFrame.size.width, self.headerHeight);
        
        // 4
        if (CGRectIntersectsRect (headerFrame, rect)) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
            UICollectionViewLayoutAttributes *la = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
            
            [attributes addObject:la];
        }
        
        // 5
        if (CGRectIntersectsRect(sectionFrame, rect)) {
            // 6
            for (NSInteger index = 0; index < section.numberOfItems; index++) {
                // 7
                CGRect frame = [section frameForItemAtIndex:index];
                
                // 8
                if (CGRectIntersectsRect(frame, rect)) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:sectionIndex];
                    UICollectionViewLayoutAttributes *la = [self layoutAttributesForItemAtIndexPath:indexPath];
                    
                    [attributes addObject:la];
                }
            }
        }
    }];
    
    
    // 9
    return attributes;
    
    
}

@end
