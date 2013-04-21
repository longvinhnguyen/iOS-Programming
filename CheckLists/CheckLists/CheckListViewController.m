//
//  CheckListsViewController.m
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/19/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CheckListViewController.h"
#import "CheckListItem.h"
#import "CheckList.h"


@implementation CheckListViewController


#pragma mark - CheckListViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = _checkList.name;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"EditItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.itemToEdit = sender;
    }
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell withCheckListItem: (CheckListItem *)item
{
    UILabel *label = (UILabel *)[cell viewWithTag:1010];
    if (item.checked) {
        label.text = @"√";
    } else {
        label.text = @"";
    }
}

- (void)configureLabelTextForCell:(UITableViewCell *)cell withCheckListItem:(CheckListItem *)item
{
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = item.text;
}

#pragma mark - CheckListViewController actions




#pragma mark - UITableView Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.checkList.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckListItem"];
    
    CheckListItem *item = self.checkList.items[indexPath.row];
    
    [self configureCheckmarkForCell:cell withCheckListItem:item];
    [self configureLabelTextForCell:cell withCheckListItem:item];
    
    
    return cell;
}


#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    CheckListItem *item = [self.checkList.items objectAtIndex:indexPath.row];
    [item toggleChecked];
    
    [self configureCheckmarkForCell:cell withCheckListItem:item];

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.checkList.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

 - (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    CheckListItem *editingItem = [self.checkList.items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"EditItem" sender:editingItem];
}



#pragma mark - AddViewController Delegate
- (void)itemViewContronllerDidCancel:(ItemDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemViewController:(ItemDetailViewController *)controller didFinishAddingItem:(CheckListItem *)item
{
    int newRowIndex = [self.checkList.items count];
    [self.checkList.items addObject:item];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newRowIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemViewController:(ItemDetailViewController *)controller didFinishEditingItem:(CheckListItem *)item
{
    int index = [self.checkList.items indexOfObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configureLabelTextForCell:cell withCheckListItem:item];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
















@end
