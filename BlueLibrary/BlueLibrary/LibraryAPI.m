//
//  LibraryAPI.m
//  BlueLibrary
//
//  Created by Long Vinh Nguyen on 9/8/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "LibraryAPI.h"
#import "Album.h"
#import "PersistencyManager.h"
#import "HTTPClient.h"

@interface LibraryAPI()
{
    PersistencyManager *persistencyManager;
    HTTPClient *client;
    BOOL isOnline;
}

@end

@implementation LibraryAPI

- (id)init
{
    if (self = [super init]) {
        persistencyManager = [[PersistencyManager alloc] init];
        client = [[HTTPClient alloc] init];
        isOnline = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadImage:) name:@"BLDownloadImageNotification" object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (LibraryAPI *)shareInstance
{
    static LibraryAPI *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    
    return _sharedInstance;
}

- (NSArray *)getAlbums
{
    return [persistencyManager getAlbums];
}

- (void)addAlbum:(Album *)ablum atIndex:(int)index
{
    [persistencyManager addAlbum:ablum atIndex:index];
    if (isOnline) {
        [client postRequest:@"/api/addAlbum" body:[ablum description]];
    }
}

- (void)deleteAlbumAtIndex:(int)index
{
    [persistencyManager deleteAlbumAtIndex:index];
    if (isOnline) {
        [client postRequest:@"/api/deleteAlbum" body:[@(index) description]];
    }
}

- (void)downloadImage:(NSNotification *)notification
{
    UIImageView *imageView = notification.userInfo[@"imageView"];
    NSString *coverUrl = notification.userInfo[@"coverUrl"];
    
    imageView.image = [persistencyManager getImage:[coverUrl lastPathComponent]];
    
    if (!imageView.image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [client downloadImage:coverUrl];
            
            //
            dispatch_sync(dispatch_get_main_queue(), ^{
                imageView.image = image;
                [persistencyManager saveImage:image fileName:[coverUrl lastPathComponent]];
            });
        });
    }
}


- (void)saveAlbums
{
    [persistencyManager saveAlbums];
}







@end
