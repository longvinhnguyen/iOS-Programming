//
//  PendingOperations.m
//  ClassicPhotos
//
//  Created by Long Vinh Nguyen on 5/23/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "PendingOperations.h"

@implementation PendingOperations

- (NSMutableDictionary *)downloadsInProgress
{
    if (!_downloadsInProgress) {
        _downloadsInProgress = [[NSMutableDictionary alloc] init];
    }
    return _downloadsInProgress;
}

- (NSOperationQueue *)downloadQueue
{
    if (!_downloadQueue) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.name = @"Download Queue";
        _downloadQueue.maxConcurrentOperationCount = 4;
    }
    return _downloadQueue;
}

- (NSMutableDictionary *)filtrationInProgress
{
    if (!_filtrationInProgress) {
        _filtrationInProgress = [[NSMutableDictionary alloc] init];
    }
    return _filtrationInProgress;
}

- (NSOperationQueue *)filtrationQueue
{
    if (!_filtrationQueue) {
        _filtrationQueue = [[NSOperationQueue alloc] init];
        _filtrationQueue.name = @"Image Filtration Queue";
        _filtrationQueue.maxConcurrentOperationCount = 4;
    }
    return _filtrationQueue;
}

@end
