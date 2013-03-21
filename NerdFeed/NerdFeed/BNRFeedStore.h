//
//  BNRFeedStore.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/16/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RSSChannel;
@class RSSItem;

@interface BNRFeedStore : NSObject
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

@property (nonatomic, strong)NSDate *topSongCacheDate;


+ (BNRFeedStore *)sharedStore;

- (void)fetchTopSongs:(int)count withCompletion:(void (^)(RSSChannel *obj, NSError *error))block;
- (RSSChannel *)fetchRSSFeedWithCompletion:(void (^)(RSSChannel * obj, NSError *error))block;

- (void)markItemAsRead:(RSSItem *)item;
- (BOOL)hasItemBeenRead:(RSSItem *)item;

@end
