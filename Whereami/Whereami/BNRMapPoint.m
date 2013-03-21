//
//  BNRMapPoint.m
//  Whereami
//
//  Created by Long Vinh Nguyen on 1/24/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "BNRMapPoint.h"

@implementation BNRMapPoint
@synthesize coordinate, title, subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
    self = [super init];
    if (self) {
        coordinate = c;
        [self setTitle:t];
        
        subtitle = [NSDateFormatter localizedStringFromDate:[[NSDate alloc] init] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    }
    return self;
}

- (id)init
{
    return [self initWithCoordinate:CLLocationCoordinate2DMake(43.07, -87.2) title:@"@Hometown"];
}

@end
