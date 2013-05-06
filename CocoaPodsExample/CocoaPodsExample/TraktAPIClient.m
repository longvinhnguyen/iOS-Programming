//
//  TraktAPIClient.m
//  CocoaPodsExample
//
//  Created by Long Vinh Nguyen on 5/6/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "TraktAPIClient.h"
#import <AFNetworking.h>

NSString *const kTraktBaseURLString = @"http://api.trakt.tv";
NSString *const kTraktAPIKey = @"fc3df235908f83107cedd7914950d7a0";

@implementation TraktAPIClient

+ (TraktAPIClient *)sharedClient
{
    static TraktAPIClient *sharedClient = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedClient = [[TraktAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kTraktBaseURLString]];
    });
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        self.parameterEncoding = AFJSONParameterEncoding;
    }
    return self;
}



@end
