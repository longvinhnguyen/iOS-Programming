//
//  ChannelViewController.m
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/14/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "ChannelViewController.h"
#import "RSSChannel.h"

@implementation ChannelViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"UITableViewCell"];
    }
    
    if ([indexPath row] == 0) {
        // Put the title of the channel in row 0
        [[cell textLabel] setText:@"Title"];
        [[cell detailTextLabel] setText:[channel title]];
    } else {
        // Put the description of the channel in row 1
        [[cell textLabel] setText:@"Info"];
        [[cell detailTextLabel] setText:[channel infoString]];
    }
    return cell;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ) {
        return UIInterfaceOrientationLandscapeLeft;
    }
    return UIInterfaceOrientationPortrait;
}

- (void)listViewController:(ListViewController *)lvc handleObject:(id)object
{
    // Make sure that the ListViewController gave the right object
    if (![object isKindOfClass:[RSSChannel class]]) {
        return;
    }
    channel = object;
    [[self tableView] reloadData];
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    [barButtonItem setTitle:@"List"];
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if (barButtonItem == [[self navigationItem] leftBarButtonItem]) {
        [[self navigationItem] setLeftBarButtonItem:nil];
    }
}









@end
