//
//  ImageDownloader.h
//  ClassicPhotos
//
//  Created by Long Vinh Nguyen on 5/23/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoRecord.h"

@class ImageDownloader;

@protocol ImageDownloaderDelegate <NSObject>

- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader;

@end

@interface ImageDownloader : NSOperation

@property (nonatomic, weak) id<ImageDownloaderDelegate> delegate;

@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) PhotoRecord *photoRecord;

- (id)initWithPhotoRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>) theDelegate;


@end
