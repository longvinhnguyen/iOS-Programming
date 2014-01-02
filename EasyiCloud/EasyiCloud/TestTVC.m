//
//  TestTVC.m
//  EasyiCloud
//
//  Created by Long Vinh Nguyen on 1/2/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import "TestTVC.h"

@interface TestTVC ()

@end

@implementation TestTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - VIEW
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    // Respond to changes underlying store
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SomethingChanged" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CoreDataHelper *cdh = [CoreDataHelper sharedHelper];
    
    [Deduplicator deDuplicateEntityWithName:@"Test" withUniqueAttributeName:@"someValue" withImportContext:cdh.importContext];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Test *test = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"From: %@", test.device];
    cell.detailTextLabel.text = test.someValue;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *deletedTarget = [self.frc objectAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.frc.managedObjectContext deleteObject:deletedTarget];
    }
    CoreDataHelper *cdh = [CoreDataHelper sharedHelper];
    [cdh backgroundSaveContext];
}

#pragma mark - DATA
- (void)configureFetch
{
    CoreDataHelper *cdh = [CoreDataHelper sharedHelper];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Test"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modified" ascending:NO]];
    request.fetchBatchSize = 15;
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
}

#pragma mark - INTERACTION
- (IBAction)add:(id)sender
{
    CoreDataHelper *cdh = [CoreDataHelper sharedHelper];
    Test *object = [NSEntityDescription insertNewObjectForEntityForName:@"Test" inManagedObjectContext:cdh.context];
    NSError *error = nil;
    if (![cdh.context obtainPermanentIDsForObjects:@[object] error:&error]) {
        NSLog(@"Couldn't obtain a permanent ID for object %@", error);
    }
    
    UIDevice *thisDevice = [UIDevice new];
    object.device = thisDevice.name;
    object.modified = [NSDate date];
    object.someValue = [NSString stringWithFormat:@"Test: %@", [[NSUUID UUID] UUIDString]];
    [cdh backgroundSaveContext];
}

@end
