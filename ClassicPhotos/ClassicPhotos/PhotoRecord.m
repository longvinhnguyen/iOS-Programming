//
//  PhotoRecord.m
//  ClassicPhotos
//
//  Created by Long Vinh Nguyen on 5/23/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "PhotoRecord.h"

@implementation PhotoRecord

- (BOOL)hasImage
{
    return _image != nil;
}

- (BOOL)isFailed
{
    return _failed;
}

- (BOOL)isFiltered
{
    return _filtered;
}

@end
