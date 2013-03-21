//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Long Vinh Nguyen on 2/2/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell
@synthesize tableView, controller;

- (IBAction)showImage:(id)sender
{
    
    // Get this name of this method, "showImage:"
    NSString *selector = NSStringFromSelector(_cmd);
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    // Prepare a new selector from this string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    if (indexPath) {
        if ([[self controller] respondsToSelector:newSelector]) {
            [[self controller] performSelector:newSelector withObject:sender withObject:indexPath];
        }
    }
}
@end
