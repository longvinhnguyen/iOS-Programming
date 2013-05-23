//
//  ImageDownloader.m
//  ClassicPhotos
//
//  Created by Long Vinh Nguyen on 5/23/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ImageDownloader.h"

@interface ImageDownloader()

@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) PhotoRecord *photoRecord;

@end


@implementation ImageDownloader

- (id)initWithPhotoRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)theDelegate
{
    if (self = [super init]) {
        self.delegate = theDelegate;
        self.photoRecord = record;
        self.indexPathInTableView = indexPath;
    }
    return self;
}

#pragma mark - Download Image
- (void)main {
    @autoreleasepool {
        if (self.isCancelled) {
            return;
        }
        
        NSData *imageData = [NSData dataWithContentsOfURL:self.photoRecord.URL];
        
        if (self.isCancelled) {
            imageData = nil;
            return;
        }
        
        if (imageData) {
            UIImage *downloadedImage = [UIImage imageWithData:imageData];
            self.photoRecord.image = downloadedImage;
        } else {
            self.photoRecord.failed = YES;
        }
        imageData  = nil;
        if (self.isCancelled) return;

        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
    }
}

@end
