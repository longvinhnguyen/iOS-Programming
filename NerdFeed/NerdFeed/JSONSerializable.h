//
//  JSONSerializable.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/17/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONSerializable <NSObject>

- (void)readFromJSONDictionary:(NSDictionary *)d;

@end
