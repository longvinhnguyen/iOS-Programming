//
//  PersistencyManager.h
//  BlueLibrary
//
//  Created by Long Vinh Nguyen on 9/8/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Album;

@interface PersistencyManager : NSObject

- (NSArray *)getAlbums;
- (void)addAlbum:(Album *)album atIndex:(int)index;
- (void)deleteAlbumAtIndex:(int)index;
- (void)saveImage:(UIImage *)image fileName:(NSString *)fileName;
- (UIImage *)getImage:(NSString *)fileName;
- (void)saveAlbums;;


@end
