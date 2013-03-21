//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/28/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "DetailViewController.h"
#import "HomepwnerItemCell.h"
#import "BNRImageStore.h"
#import "ImageViewController.h"

@implementation ItemsViewController

-(id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [[self navigationItem] setTitle:NSLocalizedString(@"Homepwner", @"Name of appliation")];
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

-(id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the nib file
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    
    
    // Register this NIB which contains the cell
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where = row this cell
    // will appear in on the tableview
    BNRItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    
    HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    [cell setController:self];
    [cell setTableView:tableView];
    
    // Configure the cell with the BNRItem
    [[cell nameLabel] setText:[p itemName]];
    [[cell serialNumberLabel] setText:[p serialNumber]];
    
    NSString *currencySymbol = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    
    [[cell valueLabel] setText: [NSString stringWithFormat:@"%@%d", currencySymbol, [p valueInDollars]]];
    [[cell thumbnailView] setImage:[p thumbnail]];
    
    
    return cell;
}


- (void)addNewItem:(id)sender
{
    // Make a new index path for the 0th section, last row
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    [detailViewController setItem:newItem];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:navController animated:YES completion:nil];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is askig to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        
        // We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *item = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = [item objectAtIndex:[indexPath row]];
    [detailViewController setItem:selectedItem];

    
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}


-(NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(void)showImage:(id)sender atIndexPath:(NSIndexPath *)ip
{
    NSLog(@"Going to show the image for %@",ip);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Get the item for the index path
        BNRItem *i = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[ip row]];
        
        NSString *imageKey = [i imageKey];
        
        // If there is no image, we don't need to display anything
        UIImage *img = [[BNRImageStore sharedStore]imageForKey:imageKey];
        if (!img) {
            return;
        }
        
        // Make a rectangle that the frame of the button relative to our table view
        CGRect rect = [[self view] convertRect:[sender bounds] fromView:sender];
        
         // Create a new ImageViewController and set its image
        ImageViewController *ivc = [[ImageViewController alloc] init];
        [ivc setImage:img];
        
        // Present a 600 x 600 popover from the rect
        imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
        [imagePopover setDelegate:self];
        [imagePopover setPopoverContentSize:CGSizeMake(600, 600)];
        [imagePopover presentPopoverFromRect:rect inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [imagePopover dismissPopoverAnimated:YES];
    imagePopover =nil;
}
























@end
