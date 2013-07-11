//
//  FileListViewController.m
//  rtf1
//
//  Created by Marin Todorov on 08/08/2012.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import "FileListViewController.h"
#import "ViewController.h"
#import "AutoCoding.h"


@interface FileListViewController ()
{
    NSMutableDictionary *renderedStrings;
}

@end

@implementation FileListViewController

- (void)viewDidLoad
{
    renderedStrings = [NSMutableDictionary dictionaryWithCapacity:5];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadFileList];
    self.title = [NSString stringWithFormat:@"Fancy Notes (%i)", fileList.count];
    [self.tableView reloadData];

}

- (void)loadFileList
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    fileList = [fm contentsOfDirectoryAtPath:documentDirectory error:nil];
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
    return fileList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = nil;
    cell.imageView.image = renderedStrings[fileList[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileList[indexPath.row]];
    NSAttributedString *contents = [NSAttributedString objectWithContentsOfFile:filePath];
    contents = [contents attributedSubstringFromRange:NSMakeRange(0, MIN(30, contents.length))];
    
    NSMutableAttributedString *mContents = [[NSMutableAttributedString alloc] initWithAttributedString:contents];
    NSAttributedString *dots = [[NSAttributedString alloc] initWithString:@"..."];
    [mContents appendAttributedString:dots];
    
    CGRect bounds = [mContents boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0);
    
    [mContents drawWithRect:bounds options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    UIImage *renderedText = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    renderedStrings[fileList[indexPath.row]] = renderedText;
    return bounds.size.height;
    
    
}

#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    if ([segue.identifier compare:@"AddButton"] == NSOrderedSame) {
        ViewController *screen = (ViewController *)segue.destinationViewController;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        NSString *fileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", dateString]];
        
        screen.fileName = fileName;
    } else if ([segue.identifier compare:@"Edit"] == NSOrderedSame) {
        ViewController *screen = segue.destinationViewController;
        int selectedIndex = [self.tableView indexPathForSelectedRow].row;
        
        NSString *selectedFileName = fileList[selectedIndex];
        screen.fileName = [documentsDirectory stringByAppendingPathComponent:selectedFileName];
        return;
    }
    
}

@end
