//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/28/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemsViewController : UITableViewController <UIPopoverControllerDelegate>
{
    UIPopoverController *imagePopover;
}


- (IBAction)addNewItem:(id)sender;



@end
