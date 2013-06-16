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
    _referID = data[@"reference"];
    NSURLRequest *requestIconImage = [NSURLRequest requestWithURL:[NSURL URLWithString:data[@"icon"]]];
    VLog(@"URL request image: %@", requestIconImage);
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:requestIconImage queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            _imageIcon = [UIImage imageWithData:data];
        }
    }];
}

- (void)loadDataFromGooglePlaceTextSearch:(NSDictionary *)data
{
    CLLocationDegrees latitude = [data[@"geometry"][@"location"][@"lat"] doubleValue];
    CLLocationDegrees longitude = [data[@"geometry"][@"location"][@"lng"] doubleValue];
    _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    _title = data[@"name"];
    _detailTitle = data[@"formatted_address"];
    _referID = data[@"reference"];
    NSURLRequest *requestIconImage = [NSURLRequest requestWithURL:[NSURL URLWithString:data[@"icon"]]];
    VLog(@"URL request image: %@", requestIconImage);
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:requestIconImage queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            _imageIcon = [UIImage imageWithData:data];
        }
    }];
}

@end
