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

@end
