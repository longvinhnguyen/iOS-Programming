//
//  RecipeListViewController.m
//  RecipesKit
//
//  Created by Felipe on 8/6/12.
//  Copyright (c) 2012 Felipe Last Marsetti. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "RecipeListViewController.h"
#import "Recipe.h"
#import "RecipeCell.h"
#import "RecipeCodeCell.h"

@interface RecipeListViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)insertNewObject:(id)sender;

@end

@implementation RecipeListViewController

#pragma mark - Fetched results controller

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - Private Methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Recipe *recipe = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    RecipeCell *recipeCell = (RecipeCell *)cell;
    
    RecipeCodeCell *recipeCell = (RecipeCodeCell *)cell;
    
//    recipeCell.titleLabel.text = recipe.title;
//    recipeCell.subTitleLabel.text = [recipe servingsString];
    
    recipeCell.nameLabel.text = recipe.title;
    recipeCell.servingsLabel.text = [recipe servingsString];
}

#pragma mark - Properties

- (NSFetchedResultsController *)fetchedResultsController
{
    // If we already have created a fetched results controller then return it
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    // Create the fetch request and entity descriptions
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    // Set the fetch request's sort descriptors
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Recipes"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    // NSError object to determine if there was an error during the fetch
	NSError *error = nil;
    
	if (![self.fetchedResultsController performFetch:&error])
    {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    return _fetchedResultsController;
}

#pragma mark - View Lifecycle

- (void)didReceiveMemoryWarning
{
    if ([self.view window] == nil) {
        self.view = nil;
    }
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:RecipeCodeCellSegue])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Recipe *recipe = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        RecipeDetailViewController *recipeDetailViewController = [segue destinationViewController];
        recipeDetailViewController.recipe = recipe;
        recipeDetailViewController.managedObjectContext = self.fetchedResultsController.managedObjectContext;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
//    UINib *cellNib = [UINib nibWithNibName:@"RecipeCell" bundle:[NSBundle mainBundle]];
//    [self.tableView registerNib:cellNib forCellReuseIdentifier:RecipeCellReuseIdentifier];
    [self.tableView registerClass:[RecipeCodeCell class] forCellReuseIdentifier:RecipeCodeCellReuseIdentifier];
}

- (void)insertNewObject:(id)sender
{
    // Get the Managed Object Context where we'll store the new Recipe, create an entity description for a Recipe and insert it into the current context
    NSManagedObjectContext *managedObjectContext = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:managedObjectContext];
    Recipe *newRecipe = [NSEntityDescription insertNewObjectForEntityForName:[entityDescription name] inManagedObjectContext:managedObjectContext];
    
    // After we receive a newly created Recipe object we set up its attributes
    newRecipe.notes = @"How to prepare the recipe...";
    newRecipe.servings = @1;
    newRecipe.title = @"My Recipe";
    
    // Error that will check whether a save of the context was possible or not
    NSError *error = nil;
    
    // Save the changes to the Managed Object Context
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#else

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation *)interfaceOrientation
{
    return YES;
}

#endif

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecipeCellReuseIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecipeCodeCellReuseIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        
        if (![context save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
            abort();
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:RecipeCodeCellSegue sender:self];
}



@end
