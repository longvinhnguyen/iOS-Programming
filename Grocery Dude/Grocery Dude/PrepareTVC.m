//
//  PrepareTVC.m
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/12/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "PrepareTVC.h"
#import "AppDelegate.h"
#import "CoreDataHelper.h"
#import "Item.h"
#import "Unit.h"
#import "ItemVC.h"
#import "Thumbnailer.h"
#import "Deduplicator.h"

#define debug 0

@interface PrepareTVC ()

@end

@implementation PrepareTVC

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
    self.clearConfirmActionSheet.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [super viewDidAppear:animated];
    
    // Create missing thumbnails
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"locationAtHome.storedIn" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    [Thumbnailer createMissingThumbnailsForEntityName:@"Item" withThumbnailAttributeName:@"thumbnail" withPhotoRelationshipName:@"photo" withPhotoAttributeName:@"data" withSortDescriptors:sortDescriptors withImportContext:cdh.importContext];
    [cdh.context performBlock:^{
        [Deduplicator deDuplicateEntityWithName:@"Item" withUniqueAttributeName:@"name" withImportContext:cdh.importContext];
        [Deduplicator deDuplicateEntityWithName:@"Unit" withUniqueAttributeName:@"name" withImportContext:cdh.importContext];
        [Deduplicator deDuplicateEntityWithName:@"LocationAtHome" withUniqueAttributeName:@"storedIn" withImportContext:cdh.importContext];
        [Deduplicator deDuplicateEntityWithName:@"LocationAtShop" withUniqueAttributeName:@"aisle" withImportContext:cdh.importContext];
    }];
                            
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    static NSString *cellIdentifier = @"Item Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    Item *item = [[self frcFromTV:tableView] objectAtIndexPath:indexPath];
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@%@ %@", item.quantity, item.unit.name, item.name];
    [title replaceOccurrencesOfString:@"(null)" withString:@"" options:0 range:NSMakeRange(0, title.length)];
    cell.textLabel.text = title;
    
    // make selected item orange
    if ([item.listed boolValue]) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        cell.textLabel.textColor = [UIColor orangeColor];
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    cell.imageView.image = [UIImage imageWithData:item.thumbnail];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSFetchedResultsController *frc = [self frcFromTV:tableView];
        Item *deleteTarget = [self.frc objectAtIndexPath:indexPath];
        [frc.managedObjectContext deleteObject:deleteTarget];
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        [cdh backgroundSaveContext];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSManagedObjectID *itemid = [[[self frcFromTV:tableView] objectAtIndexPath:indexPath] objectID];
    
    Item *item = (Item *)[[self frcFromTV:tableView].managedObjectContext existingObjectWithID:itemid error:nil];
    
    if ([item.listed boolValue]) {
        item.listed = @(NO);
    } else {
        item.listed = @(YES);
        item.collected = @(NO);
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

#pragma mark - DATA
- (void)configureFetch
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"locationAtHome.storedIn" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    [request setFetchBatchSize:15];
//    [request setFetchLimit:20];
//    [request setFetchOffset:50];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"locationAtHome.storedIn" cacheName:nil];
    self.frc.delegate = self;
}

#pragma mark - INTERACTION
- (IBAction)clear:(id)sender
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    NSFetchRequest *request = [cdh.model fetchRequestTemplateForName:@"ShoppingList"];
    NSArray *shoppingList = [cdh.context executeFetchRequest:request error:nil];
    if (shoppingList.count > 0) {
        self.clearConfirmActionSheet = [[UIActionSheet alloc] initWithTitle:@"Clear Entire Shopping List?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear" otherButtonTitles:nil];
        [self.clearConfirmActionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing to clear" message:@"Add items to Shop tab by tapping them on the Prepare tab. Remove all items from the Shop tab by clicking Clear on the Prepare tab" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    shoppingList = nil;
    [cdh backgroundSaveContext];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.clearConfirmActionSheet) {
        if (buttonIndex == [actionSheet destructiveButtonIndex]) {
            [self performSelector:@selector(clearList)];
        } else if (buttonIndex == [actionSheet cancelButtonIndex]) {
            [actionSheet dismissWithClickedButtonIndex:[actionSheet cancelButtonIndex] animated:YES];
        }
    }
}

- (void)clearList
{
    if (debug == 1) {
       NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    NSFetchRequest *request = [cdh.model fetchRequestTemplateForName:@"ShoppingList"];
    NSArray *shoppingList = [cdh.context executeFetchRequest:request error:nil];
    for (Item *item in shoppingList) {
        item.listed = @(NO);
    }
    [cdh backgroundSaveContext];
}

#pragma mark - SEGUE
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    ItemVC *itemVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"Add Item Segue"]) {
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:cdh.context];
        NSError *error = nil;
        if (![cdh.context obtainPermanentIDsForObjects:@[newItem] error:&error]) {
            NSLog(@"Couldn't obtain a permanent ID for object %@", error);
        }
        itemVC.selectedItemID = newItem.objectID;
    } else {
        NSLog(@"Unidentified Segue Attempted");
    }
}

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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[ cd] %@", searchString];
        
        NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"locationAtHome.storedIn" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        [self reloadSearchFRCForPredicate:predicate withEntity:@"Item" inContext:cdh.context withSortDescriptions:sortDescriptors withSectionNameKeyPath:@"locationAtHome.storedIn"];
    } else {
        return NO;
    }
    
    return YES;
}
@end
