//
//  PersistencyManager.m
//  BlueLibrary
//
//  Created by Long Vinh Nguyen on 9/8/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "PersistencyManager.h"
#import "Album.h"

@implementation PersistencyManager
{
    NSMutableArray *albums;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [documentPath stringByAppendingPathComponent:@"album.bin"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        albums = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (!albums) {
            albums = [NSMutableArray arrayWithArray:
                      @[[[Album alloc] initWithTitle:@"Best of Bowie" artist:@"David Bowie" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_david%20bowie_best%20of%20bowie.png" year:@"1992"],
                      [[Album alloc] initWithTitle:@"It's My Life" artist:@"No Doubt" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_no%20doubt_its%20my%20life%20%20bathwater.png" year:@"2003"],
                      [[Album alloc] initWithTitle:@"Nothing Like The Sun" artist:@"Sting" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_sting_nothing%20like%20the%20sun.png" year:@"1999"],
                      [[Album alloc] initWithTitle:@"Staring at the Sun" artist:@"U2" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_u2_staring%20at%20the%20sun.png" year:@"2000"],
                      [[Album alloc] initWithTitle:@"American Pie" artist:@"Madonna" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_madonna_american%20pie.png" year:@"2000"]]];
        }
    }
    
    return self;
}

- (NSArray *)getAlbums
{
    return albums;
}

- (void)addAlbum:(Album *)album atIndex:(int)index
{
    if (albums.count >= index) {
        [albums insertObject:album atIndex:index];
    } else {
        [albums addObject:album];
    }
}

- (void)deleteAlbumAtIndex:(int)index
{
    [albums removeObjectAtIndex:index];
}

- (void)saveImage:(UIImage *)image fileName:(NSString *)fileName
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:filePath atomically:YES];
}

- (UIImage *)getImage:(NSString *)fileName
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return [UIImage imageWithData:data];
}

- (void)saveAlbums
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"album.bin"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:albums];
    [data writeToFile:filePath atomically:YES];
}



@end
