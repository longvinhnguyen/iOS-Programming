//
//  FileListViewController.m
//  rtf1
//
//  Created by Marin Todorov on 08/08/2012.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import "FileListViewController.h"
#import "ViewController.h"

@interface FileListViewController ()

@end

@implementation FileListViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = @"Notes";

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    //configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
