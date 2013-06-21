//
//  FIickrPhotoCell.h
//  APISExplorer
//
//  Created by Long Vinh Nguyen on 6/21/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo;

@interface FIickrPhotoCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) Photo *photo;


@end
