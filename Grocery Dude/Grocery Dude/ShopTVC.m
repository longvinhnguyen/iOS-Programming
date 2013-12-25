//
//  ShopTVC.m
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/16/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ShopTVC.h"
#import "Item.h"
#import "Unit.h"
#import "AppDelegate.h"
#import "ItemVC.h"
#import "Item_Photo.h"
#import "Thumbnailer.h"

@interface ShopTVC ()

@end

@implementation ShopTVC

#define debug 0

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VIEW
- (void)viewDidLoad
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    [self configureSearch];
    
    // Respond changes in underlying store
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    // Create missing thumbnails
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"locationAtHome.storedIn" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    [Thumbnailer createMissingThumbnailsForEntityName:@"Item" withThumbnailAttributeName:@"thumbnail" withPhotoRelationshipName:@"photo" withPhotoAttributeName:@"data" withSortDescriptors:sortDescriptors withImportContext:cdh.importContext];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    static NSString *cellIdentifier = @"Shop Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    Item * item = [[self frcFromTV:tableView] objectAtIndexPath:indexPath];
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@%@ %@", item.quantity, item.unit, item.name];
    [title replaceOccurrencesOfString:@"(null)" withString:@"" options:0 range:NSMakeRange(0, [title length])];
    cell.textLabel.text = item.name;
    
    // make collected items green
    if ([item.collected boolValue]) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
        cell.textLabel.textColor = [UIColor colorWithRed:1.0/3 green:3.0/4 blue:1.0/3 alpha:1.0];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    cell.imageView.image = [UIImage imageWithData:item.thumbnail];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    Item *item = [[self frcFromTV:tableView] objectAtIndexPath:indexPath];
    if ([item.collected boolValue]) {
        item.collected = [NSNumber numberWithBool:NO];
    } else {
        item.collected = [NSNumber numberWithBool:YES];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - DATA
- (void)configureFetch
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    NSFetchRequest *request = [[cdh.model fetchRequestTemplateForName:@"ShoppingList"] copy];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"locationAtShop.aisle" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    [request setFetchBatchSize:50];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"locationAtShop.aisle" cacheName:nil];
    self.frc.delegate = self;
}

#pragma mark - INTERACTION
- (IBAction)clear:(id)sender
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if ([self.frc.fetchedObjects count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing to Clear" message:@"Add items using the Prepare tab" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    BOOL nothingCleared = YES;
    for (Item *item in self.frc.fetchedObjects) {
        if ([item.collected boolValue]) {
            item.listed = [NSNumber numberWithBool:NO];
            item.collected = [NSNumber numberWithBool:NO];
            nothingCleared = NO;
        }
    }
    
    if (nothingCleared) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Select items to be removed from the list before pressing Clear" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    [cdh backgroundSaveContext];
}

#pragma mark - SEGUE
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    ItemVC *itemVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemVC"];
    itemVC.selectedItemID = [[[self frcFromTV:tableView] objectAtIndexPath:indexPath] objectID];
    [self.navigationController pushViewController:itemVC animated:YES];
}

#pragma mark - SEARCH
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (searchString.length > 0) {
        NSLog(@"--> Searching for '%@'", searchString);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[ cd] %@ AND listed == YES", searchString];
        
        NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"locationAtShop.aisle" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        [self reloadSearchFRCForPredicate:predicate withEntity:@"Item" inContext:cdh.context withSortDescriptions:sortDescriptors withSectionNameKeyPath:@"locationAtShop.aisle"];
    } else {
        return NO;
    }
    
    return YES;
}

@end
