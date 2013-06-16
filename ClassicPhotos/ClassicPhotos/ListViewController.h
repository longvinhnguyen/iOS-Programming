//
//  ListViewController.h
//  ClassicPhotos
//
//  Created by Long Vinh Nguyen on 5/23/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"
#import "ImageFiltration.h"
#import "PendingOperations.h"
#import <iCarousel.h>
#import <AFNetworking.h>

#define kDatasourceString @"https://sites.google.com/site/soheilsstudio/tutorials/nsoperationsampleproject/ClassicPhotosDictionary.plist"

@interface ListViewController : UITableViewController<ImageDownloaderDelegate, ImageFiltrationDelegate, UIScrollViewDelegate, iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) PendingOperations *pendingOperations;
@property (nonatomic, strong) iCarousel *flowView;

@end
