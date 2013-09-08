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
    }
    
    return self;
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








@end
