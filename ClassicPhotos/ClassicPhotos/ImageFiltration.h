//
//  ImageFiltration.h
//  ClassicPhotos
//
//  Created by Long Vinh Nguyen on 5/23/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoRecord.h"

@class ImageFiltration;

@protocol ImageFiltrationDelegate <NSObject>

- (void)imageFiltrationDidFinish:(ImageFiltration *)filtration;

@end

@interface ImageFiltration : NSOperation

@property (nonatomic, weak) id<ImageFiltrationDelegate> delegate;
@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) PhotoRecord *photoRecord;

- (id)initWithPhotoRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageFiltrationDelegate>) theDelegate;

@end
