//
//  SearchResult.h
//  StoreSearch
//
//  Created by Long Vinh Nguyen on 5/8/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResult : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString *artWorkURL60;
@property (nonatomic, copy) NSString *artWorkURL100;
@property (nonatomic, copy) NSString *storeURL;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSDecimalNumber *price;
@property (nonatomic, copy) NSString  *genre;

- (NSComparisonResult)compareName:(SearchResult *)other;

@end
