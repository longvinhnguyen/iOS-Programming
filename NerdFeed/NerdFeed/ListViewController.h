//
//  ListViewController.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/13/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RSSChannel;
@class WebViewController;

typedef enum {
    ListViewControllerRSSTypeBNR,
    ListViewControllerRSSTypeApple
}ListViewControllerRSSType;

@interface ListViewController : UITableViewController<NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSXMLParserDelegate>
{
    RSSChannel *channel;
    ListViewControllerRSSType rssType;
}

@property (nonatomic, strong) WebViewController* webViewController;



- (void)fetchEntries;





@end

// Add new protocol named ListViewControllerDelegate
@protocol ListViewControllerDelegate

// Classes that conform to this protocol must implement this method
- (void)listViewController:(ListViewController *)lvc handleObject:(id)object;

@end
