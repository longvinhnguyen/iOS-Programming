//
//  WeatherHTTPClient.h
//  Weather
//
//  Created by Long Vinh Nguyen on 4/28/13.
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import "AFHTTPClient.h"
@protocol WeatherHTTPClientDelegate;

@interface WeatherHTTPClient : AFHTTPClient

@property(nonatomic, weak)id<WeatherHTTPClientDelegate> delegate;
+ (WeatherHTTPClient *) shareWeatherHTTPClient;
- (id)initWithBaseURL:(NSURL *)url;
- (void)updateWeatherAtLocation:(CLLocation *)location forNumberDays:(int)numbers;

@end

@protocol WeatherHTTPClientDelegate <NSObject>

- (void)weatherHTTPClient:(WeatherHTTPClient *)client didUpdateWithWeather:(id)weather;
- (void)weatherHTTPClient:(WeatherHTTPClient *)client didFailWithError:(id)error;

@end
