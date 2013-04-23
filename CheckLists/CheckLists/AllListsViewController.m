//
//  AllListsViewController.m
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/21/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "AllListsViewController.h"
#import "CheckList.h"
#import "CheckListViewController.h"
#import "ListDetailViewController.h"
#import "CheckListItem.h"
#import "DataModel.h"

@implementation AllListsViewController



- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _dataModel = [[DataModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
    
    int index = self.dataModel.indexOfSelectedChecklist;
    if (index >= 0 && index < self.dataModel.lists.count) {
        CheckList *checkList = _dataModel.lists[index];
        [self performSegueWithIdentifier:@"ShowCheckList" sender:checkList];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataModel.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    CheckList *list = _dataModel.lists[indexPath.row];
    
    cell.textLabel.text = list.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    int count = [list countUncheckedItems];
    if (list.items.count == 0) {
        cell.detailTextLabel.text = @"No Items";
    } else if (count == 0) {
        cell.detailTextLabel.text = @"All Done";
    } else
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Remaining %d",count];

    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_dataModel.lists removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataModel setIndexOfSelectedChecklist:indexPath.row];
    CheckList *checkList = [_dataModel.lists objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ShowCheckList" sender:checkList];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowCheckList"]) {
        CheckListViewController *controller = (CheckListViewController *)segue.destinationViewController;
        controller.checkList = sender;
    } else if ([segue.identifier isEqualToString:@"AddChecklist"]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        ListDetailViewController *controller = (ListDetailViewController *)navController.topViewController;
        controller.delegate = self;
        controller.checkListToEdit = nil;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
    ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
    controller.delegate = self;
    CheckList *checkList = [_dataModel.lists objectAtIndex:indexPath.row];
    controller.checkListToEdit = checkList;
    [self presentViewController:navigationController animated:YES completion:nil];
}




- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingCheckList:(CheckList *)checkList
{
    [_dataModel.lists addObject:checkList];
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingCheckList:(CheckList *)checkList
{
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self) {
//        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"ChecklistIndex"];
       [self.dataModel setIndexOfSelectedChecklist:-1];
    }
}










@end
