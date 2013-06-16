//
//  Venue.h
//  APISExplorer
//
//  Created by Long Vinh Nguyen on 6/14/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detailTitle;

- (void)loadDataFromGooglePlacesResponse:(NSDictionary *)data;


@end
