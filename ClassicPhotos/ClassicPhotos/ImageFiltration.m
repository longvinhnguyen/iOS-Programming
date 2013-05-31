//
//  ImageFiltration.m
//  ClassicPhotos
//
//  Created by Long Vinh Nguyen on 5/23/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ImageFiltration.h"

@interface ImageFiltration()

@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) PhotoRecord *photoRecord;

@end

@implementation ImageFiltration

#pragma mark - Lifecycle
- (id)initWithPhotoRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageFiltrationDelegate>)theDelegate
{
    if (self = [super init]) {
        self.indexPathInTableView = indexPath;
        self.photoRecord = record;
        self.delegate = theDelegate;
    }
    return self;
}

#pragma mark - Main operation
- (void)main
{
    @autoreleasepool {
        if (self.isCancelled) {
            return;
        }
        if (!self.photoRecord.hasImage) {
            return;
        }
        UIImage *rawImage = self.photoRecord.image;
        UIImage *processedImage = [self applySepialFilterToImage:rawImage];
        if (self.isCancelled) {
            return;
        }
        if (processedImage) {
            self.photoRecord.image = processedImage;
            self.photoRecord.filtered = YES;
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageFiltrationDidFinish:) withObject:self waitUntilDone:NO];
        }
    }
}
                  
#pragma mark - Filtering image
- (UIImage *)applySepialFilterToImage:(UIImage *)image {
    CIImage *inputImage = [CIImage imageWithData:UIImagePNGRepresentation(image)];
    if (self.isCancelled) {
        return nil;
    }

    UIImage *sepialImage = nil;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey, inputImage, @"inputIntensity", [NSNumber numberWithFloat:0.8f], nil];
    CIImage *outputImage = [filter outputImage];
    if (self.isCancelled) return nil;

    CGImageRef outputImageRef = [context createCGImage:outputImage fromRect:[outputImage extent]];
    if (self.isCancelled) {
        CGImageRelease(outputImageRef);
        return nil;
    }

    sepialImage = [UIImage imageWithCGImage:outputImageRef];
    CGImageRelease(outputImageRef);
    return sepialImage;


}









@end
