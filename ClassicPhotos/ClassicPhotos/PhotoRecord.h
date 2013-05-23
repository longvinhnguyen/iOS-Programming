//
//  PhotoRecord.h
//  ClassicPhotos
//
//  Created by Long Vinh Nguyen on 5/23/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoRecord : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, readonly) BOOL hasImage;
@property (nonatomic, getter = isFiltered)BOOL filtered;
@property (nonatomic, getter = isFailed)BOOL failed;


@end
