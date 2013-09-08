//
//  LibraryAPI.h
//  BlueLibrary
//
//  Created by Long Vinh Nguyen on 9/8/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Album;

@interface LibraryAPI : NSObject

+ (LibraryAPI *)shareInstance;

- (NSArray *)getAlbums;
- (void)addAlbum:(Album *)ablum atIndex:(int)index;
- (void)deleteAlbumAtIndex:(int)index;

@end
