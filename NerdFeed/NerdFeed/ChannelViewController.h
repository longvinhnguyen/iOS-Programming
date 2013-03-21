//
//  ChannelViewController.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/14/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"
@class RSSChannel;

@interface ChannelViewController : UITableViewController<ListViewControllerDelegate, UISplitViewControllerDelegate>
{
    RSSChannel *channel;
}

@end
