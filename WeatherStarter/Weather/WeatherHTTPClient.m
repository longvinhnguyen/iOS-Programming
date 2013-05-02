//
//  WeatherHTTPClient.m
//  Weather
//
//  Created by Long Vinh Nguyen on 4/28/13.
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import "WeatherHTTPClient.h"

@implementation WeatherHTTPClient

+ (WeatherHTTPClient *)shareWeatherHTTPClient
{
    NSString *urlStr = @"http://free.worldweatheronline.com/feed/";
    
    static dispatch_once_t pread;
    static WeatherHTTPClient *sharedWeatherHTTPClient = nil;
    
    dispatch_once(&pread, ^{
        sharedWeatherHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    });
    return sharedWeatherHTTPClient;
    
}

- (id)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

- (void)updateWeatherAtLocation:(CLLocation *)location forNumberDays:(int)numbers
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d", numbers] forKey:@"num_of_days"];
    [parameters setObject:[NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude] forKey:@"q"];
    [parameters setObject:@"json" forKey:@"format"];
    [parameters setObject:@"7f3a3480fc162445131401" forKey:@"key"];
    
    [self getPath:@"weather.ashx" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        if ([self.delegate respondsToSelector:@selector(weatherHTTPClient:didUpdateWithWeather:)]) {
            [self.delegate weatherHTTPClient:self didUpdateWithWeather:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if ([self.delegate respondsToSelector:@selector(weatherHTTPClient:didFailWithError:)]) {
            [self.delegate weatherHTTPClient:self didFailWithError:error];
        }
    }];
    
}

@end
