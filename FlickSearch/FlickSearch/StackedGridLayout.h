//
//  StackedGridLayout.h
//  FlickSearch
//
//  Created by Long Vinh Nguyen on 4/11/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StackedGridLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat headerHeight;

@end


@protocol StackedGridLayoutDelegate <UICollectionViewDelegate>

//1
- (NSInteger)collectionView: (UICollectionView *) cv layout:(UICollectionViewLayout *)cvl numberOfColumnsInSection:(NSInteger)section;

//2
- (CGSize)collectionView: (UICollectionView *)cv layout:(UICollectionViewLayout *)cvl sizeForItemWithWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

//3
- (UIEdgeInsets)collectionView: (UICollectionView *)cv layout:(UICollectionViewLayout *)cvl itemInsetsForSectionAtIndex:(NSInteger)section;


@end