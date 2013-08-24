//
//  BHPhotoAlbumLayout.h
//  CollectionViewTutorial
//
//  Created by VisiKard MacBook Pro on 8/24/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHPhotoAlbumLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;

@end
