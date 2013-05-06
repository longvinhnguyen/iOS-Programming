//
//  TraktAPIClient.h
//  CocoaPodsExample
//
//  Created by Long Vinh Nguyen on 5/6/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "AFHTTPClient.h"
@class AFHTTPClient;


extern NSString * const kTraktAPIKey;
extern NSString * const kTraktBaseURLString;

@interface TraktAPIClient : AFHTTPClient

+(TraktAPIClient *)sharedClient;

@end
