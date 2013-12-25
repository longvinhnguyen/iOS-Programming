//
//  CoreDataTVC.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/12/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@interface CoreDataTVC : UITableViewController<NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) NSFetchedResultsController *searchFRC;
@property (nonatomic, strong) UISearchDisplayController *searchDC;

- (NSFetchedResultsController *)frcFromTV:(UITableView *)tableView;
- (UITableView *)TVFromFRC:(NSFetchedResultsController *)frc;
- (void)performFetch;
- (void)reloadSearchFRCForPredicate:(NSPredicate *)predicate withEntity:(NSString *)entity inContext:(NSManagedObjectContext *)context withSortDescriptions:(NSArray *)sortDescriptions withSectionNameKeyPath:(NSString *)sectionNameKeyPath;
- (void)configureSearch;

@end
