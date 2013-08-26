//
//  BHPhotoAlbumLayout.h
//  CollectionViewTutorial
//
//  Created by VisiKard MacBook Pro on 8/24/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const BHPhotoAlbumLayoutAlbumTitleKind;

@interface BHPhotoAlbumLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) CGFloat titleHeight;

@end
