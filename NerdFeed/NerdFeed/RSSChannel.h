//
//  RSSChannel.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/13/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface RSSChannel : NSObject<NSXMLParserDelegate, JSONSerializable, NSCoding, NSCopying>
{
    NSMutableString *currentString;
}

- (void)addItemsFromChannel:(RSSChannel *)otherChannel;

@property (nonatomic, weak) id parentParserDelegate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *infoString;
@property (nonatomic, readonly, strong) NSMutableArray *items;

- (void)trimItemTitles;

@end
