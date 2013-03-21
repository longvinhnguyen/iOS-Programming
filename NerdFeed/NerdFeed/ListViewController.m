//
//  ListViewController.m
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/13/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "ListViewController.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "WebViewController.h"
#import "ChannelViewController.h"
#import "BNRFeedStore.h"



@implementation ListViewController
@synthesize webViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:self action:@selector(showInfo:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        UISegmentedControl *rssTypeControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"BNR", @"Apple", nil]];
        [rssTypeControl setSelectedSegmentIndex:0];
        [rssTypeControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [rssTypeControl addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventValueChanged];
        [[self navigationItem] setTitleView:rssTypeControl];
        
        [self fetchEntries];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[channel items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    RSSItem *item = [[channel items] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item title]];
    
    if ([[BNRFeedStore sharedStore] hasItemBeenRead:item]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}


- (void)fetchEntries
{
    // Get a hold of the segmented control that is currently in the title view
    UIView *currentTitleView = [[self navigationItem] titleView];
    
    // Create a activity indicator and start it spinning in the nav bar
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [[self navigationItem] setTitleView:aiView];
    [aiView startAnimating];
    
    // Initiate the request
    void (^completionBlock)(RSSChannel *obj, NSError *err) = ^(RSSChannel *obj, NSError *error) {
        NSLog(@"Completion block called");
        // When the request completes - success or failure - replace the activity
        // indicator with the segmented control
        [[self navigationItem] setTitleView:currentTitleView];
        if (!error) {
            // If everything went ok, grab the channel object, and reload the table
            channel = obj;
            [[self tableView] reloadData];
        } else {
            // If things went bad, show an alert view
            UIAlertView  * av = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    };
    
    
    // Initiate the request ...
    if (rssType == ListViewControllerRSSTypeBNR) {
        channel = [[BNRFeedStore sharedStore] fetchRSSFeedWithCompletion:^(RSSChannel *obj,NSError *err) {
            // Replace the activity indicator
            [[self navigationItem] setTitleView:currentTitleView];
            
            if (!err) {
                //How many items are there currently?
                int currentItemCount = [[channel items] count];
                
                // Set our channel to the merged one
                channel = obj;
                
                // How many items are there now?
                int newItemCount = [[channel items] count];
                
                // For each new item, insert a new row. the data source will take care of the rest
                int itemDelta = newItemCount - currentItemCount;
                if (itemDelta > 0) {
                    NSMutableArray *rows = [NSMutableArray array];
                    for (int i = 0; i < itemDelta; i++) {
                        NSIndexPath *ip =[NSIndexPath indexPathForRow:i inSection:0];
                        
                        [rows addObject:ip];
                    }
                    
                    [[self tableView] insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];
                }
            } else {
                // If things went bad, show an alert view
                UIAlertView  * av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            }
        }];
        [[self tableView] reloadData];
    } else if (rssType == ListViewControllerRSSTypeApple) {
         [[BNRFeedStore sharedStore] fetchTopSongs:10 withCompletion:completionBlock];
    }
    
    NSLog(@"Executing code at the end of fetchEntries");
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self splitViewController]) {
        // Create the web view controller's view the first time through
        [[self navigationController] pushViewController:webViewController animated:YES];
    } else {
        // We have to create a new navigation controller, as the old one
        // was only retained by the split view controller and is now gone
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webViewController];
        NSArray *vcs = [NSArray arrayWithObjects:[self navigationController], nav, nil];
        [[self splitViewController] setViewControllers:vcs];
        
        [[self splitViewController] setDelegate:webViewController];

    }
    
    // Grab the selected item
    RSSItem *entry = [[channel items] objectAtIndex:[indexPath row]];
    
    [[BNRFeedStore sharedStore] markItemAsRead:entry];
    
    // Immediately add a checkmark to this row
    [[[self tableView] cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    [webViewController listViewController:self handleObject:entry];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ) {
        return UIInterfaceOrientationLandscapeLeft;
    }
    return UIInterfaceOrientationPortrait;
}

- (void)showInfo:(id)sender
{
    // Create the channel view controller
    ChannelViewController *channelViewController = [[ChannelViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    if ([self splitViewController]) {
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:channelViewController];
        
        // Create an array with our nav controller and this new VC's nav controller
        NSArray *vcs = [NSArray arrayWithObjects:[self navigationController], nvc, nil];
        
        // Grab a pointer to the split view controller
        // and reset its view controller array
        [[self splitViewController] setViewControllers:vcs];
        
        // Make the detail view controller the delegate of the split view controller
        [[self splitViewController] setDelegate:channelViewController];
        
        NSIndexPath *selectedRow = [[self tableView] indexPathForSelectedRow];
        if (selectedRow) {
            [[self tableView] deselectRowAtIndexPath:selectedRow animated:YES];
        }
    } else {
        [[self navigationController] pushViewController:channelViewController animated:YES];
    }
    
    // Give the VC the channel object through the protocol message
    [channelViewController listViewController:self handleObject:channel];
}

- (void)changeType:(id)sender
{
    rssType = [sender selectedSegmentIndex];
    [self fetchEntries];
}














@end
