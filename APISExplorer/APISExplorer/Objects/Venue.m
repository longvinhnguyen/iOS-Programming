//
//  Venue.m
//  APISExplorer
//
//  Created by Long Vinh Nguyen on 6/14/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "Venue.h"

@implementation Venue


- (void) loadDataFromGooglePlacesResponse:(NSDictionary *)data
{
    CLLocationDegrees latitude = [data[@"geometry"][@"location"][@"lat"] doubleValue];
    CLLocationDegrees longitude = [data[@"geometry"][@"location"][@"lng"] doubleValue];
    _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    _title = data[@"name"];
    _detailTitle = data[@"vicinity"];
}

@end
