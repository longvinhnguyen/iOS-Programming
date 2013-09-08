//
//  Album.m
//  BlueLibrary
//
//  Created by Long Vinh Nguyen on 9/8/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "Album.h"

@implementation Album

- (id)initWithTitle:(NSString *)title artist:(NSString *)artist coverUrl:(NSString *)coverUrl year:(NSString *)year
{
    if (self = [super init]) {
        _title = title;
        _artist = artist;
        _coverUrl = coverUrl;
        _year = year;
        _genre = @"Pop";
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.year forKey:@"year"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.artist forKey:@"artist"];
    [aCoder encodeObject:self.genre forKey:@"genre"];
    [aCoder encodeObject:self.coverUrl forKey:@"coverUrl"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self  = [super init];
    if (self) {
        _year = [aDecoder decodeObjectForKey:@"year"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _artist = [aDecoder decodeObjectForKey:@"artist"];
        _genre = [aDecoder decodeObjectForKey:@"genre"];
        _coverUrl = [aDecoder decodeObjectForKey:@"coverUrl"];
    }
    return self;
}

@end
