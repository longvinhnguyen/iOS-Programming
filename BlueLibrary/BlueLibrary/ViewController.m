//
//  ViewController.m
//  BlueLibrary
//
//  Created by Eli Ganem on 31/7/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "ViewController.h"
#import "LibraryAPI.h"
#import "Album+TableRepresentation.h"
#import "HorizontalScroller.h"
#import "AlbumView.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, HorizontalScrollerDelegate>
{
    UITableView *dataTable;
    NSArray *allAbums;
    NSDictionary *currentAlbumData;
    int currentAlbumIndex;
    HorizontalScroller *scroller;
    
    UIToolbar *toolbar;
    NSMutableArray *undoStack;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.76 green:0.81 blue:0.87 alpha:1];
    currentAlbumIndex = 0;
    
    allAbums = [[LibraryAPI shareInstance] getAlbums];
    
    dataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height - 120) style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.backgroundView = nil;
    [self.view addSubview:dataTable];
    
    [self loadPreviousState];
    
    scroller = [[HorizontalScroller alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    scroller.backgroundColor = [UIColor colorWithRed:0.24 green:0.35 blue:0.49 alpha:1.0f];
    scroller.delegate = self;
    [self.view addSubview:scroller];
    
    [self reloadScroller];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    toolbar = [[UIToolbar alloc] init];
    UIBarButtonItem *undoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoAction)];
    undoItem.enabled = NO;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAlbum)];
    [toolbar setItems:@[undoItem,space,delete]];
    [self.view addSubview:toolbar];
    undoStack = [[NSMutableArray alloc] init];
    
}


- (void)viewWillLayoutSubviews
{
    toolbar.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
    dataTable.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height - 200);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDataForAlbumAtIndex:(int)albumIndex
{
    if (albumIndex < allAbums.count) {
        // fetch the album
        Album *album = allAbums[albumIndex];
        currentAlbumData = [album tr_tableReprentation];
    } else {
        currentAlbumData = nil;
    }
    
    [dataTable reloadData];
}

- (void)reloadScroller
{
    allAbums = [[LibraryAPI shareInstance] getAlbums];
    if (currentAlbumIndex < 0) {
        currentAlbumIndex = 0;
    } else if (currentAlbumIndex >= allAbums.count) {
        currentAlbumIndex = allAbums.count - 1;
    }
    [scroller reload];
    
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}

- (void)saveCurrentState
{
    [[NSUserDefaults standardUserDefaults] setInteger:currentAlbumIndex forKey:@"currentAlbumIndex"];
    [[LibraryAPI shareInstance] saveAlbums];
}

- (void)loadPreviousState
{
    currentAlbumIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentAlbumIndex"];
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}

#pragma mark - Action methods
- (void)addAlbum:(Album *)album atIndex:(int)index
{
    [[LibraryAPI shareInstance] addAlbum:album atIndex:index];
    currentAlbumIndex = index;
    [self reloadScroller];
}

- (void)deleteAlbum
{
    Album *deletedAlbum = allAbums[currentAlbumIndex];
    
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(addAlbum:atIndex:)];
    NSInvocation *undoAction = [NSInvocation invocationWithMethodSignature:sig];
    
    [undoAction setTarget:self];
    [undoAction setSelector:@selector(addAlbum:atIndex:)];
    [undoAction setArgument:&deletedAlbum atIndex:2];
    [undoAction setArgument:&currentAlbumIndex atIndex:3];
    [undoAction retainArguments];
    
    [undoStack addObject:undoAction];
    
    [[LibraryAPI shareInstance] deleteAlbumAtIndex:currentAlbumIndex];
    [self reloadScroller];
    
    [toolbar.items[0] setEnabled:YES];
}

- (void)undoAction
{
    if (undoStack.count > 0) {
        NSInvocation *undoAction = [undoStack lastObject];
        [undoStack removeLastObject];
        [undoAction invoke];
    }
    
    if (undoStack.count == 0) {
        [toolbar.items[0] setEnabled:NO];
    }
}

#pragma mark - UITableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentAlbumData[@"titles"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = currentAlbumData[@"titles"][indexPath.row];
    cell.detailTextLabel.text = currentAlbumData[@"values"][indexPath.row];
    
    return cell;
}

#pragma mark - HorizontalScrollerDelegate methods
- (void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index
{
    currentAlbumIndex = index;
    [self showDataForAlbumAtIndex:index];
}

- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller *)scroller
{
    return allAbums.count;
}

- (UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index
{
    Album *album = allAbums[index];
    return [[AlbumView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) albumCover:album.coverUrl];
}

- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller *)scroller
{
    return currentAlbumIndex;
}


@end
