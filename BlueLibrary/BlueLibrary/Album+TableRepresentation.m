//
//  Album+TableRepresentation.m
//  BlueLibrary
//
//  Created by Long Vinh Nguyen on 9/8/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "Album+TableRepresentation.h"

@implementation Album (TableRepresentation)

- (NSDictionary *)tr_tableReprentation
{
    return @{@"titles":@[@"Artist", @"Album", @"Genre", @"Year"],
            @"values":@[self.artist, self.title, self.genre, self.year]};
}



@end
