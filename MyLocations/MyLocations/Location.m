//
//  Location.m
//  MyLocations
//
//  Created by Long Vinh Nguyen on 4/30/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "Location.h"


@implementation Location

@dynamic latitude;
@dynamic longtitude;
@dynamic date;
@dynamic locationDescription;
@dynamic category;
@dynamic placemark;
@dynamic photoId;

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longtitude);
}

- (NSString *)title
{
    if (self.locationDescription.length > 0) {
        return self.locationDescription;
    }
    return @"No Description";
}

- (NSString *)subtitle
{
    return self.category;
}

- (BOOL)hasPhoto
{
    return (self.photoId != -1);
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

- (NSString *)photoPath
{
    NSString *fileName = [NSString stringWithFormat:@"Photo-%d.png",self.photoId];
    return [[self documentsDirectory] stringByAppendingPathComponent:fileName];
}

- (UIImage *)photoImage
{
    NSAssert(self.photoId !=-1, @"Photo ID is -1");
    
    return [UIImage imageWithContentsOfFile:[self photoPath]];
}

- (void)removePhotoFile
{
    NSString *path = [self photoPath];
    NSFileManager *fileManager =[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error;
        if (![fileManager removeItemAtPath:path error:&error]) {
            VLog(@"Error removing file: %@",error.localizedDescription);
        }
    }
}

@end
