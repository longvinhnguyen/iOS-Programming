//
//  Photo.m
//  APISExplorer
//
//  Created by Long Vinh Nguyen on 6/21/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (id) initWithID:(NSString *)photoID title:(NSString *)title andURL:(NSURL *)url
{
    if (self == [super self]) {
        _photoID = photoID;
        _photoURL = url;
        _title = title;
    }
    return self;
}

- (void)loadPhotoFromFlickr:(NSDictionary *)data
{
    _photoID = data[@"id"];
    _title = data[@"title"];
    NSString *farm = data[@"farm"];
    NSString *secret = data[@"secret"];
    NSString *server = data[@"server"];
    _photoURL = [self getPhotURLfromFarm:farm server:server andSecretID:secret];
}

- (NSURL *)getPhotURLfromFarm:(NSString *)farm server:(NSString *)server andSecretID:(NSString *)secret
{
    return [NSURL URLWithString:[NSString stringWithFormat:STRING_FLICKR_FORMAT_PHOTO_URL,farm, server, _photoID, secret]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@-%@-%@", _title, _photoID, _photoURL];
}

@end
