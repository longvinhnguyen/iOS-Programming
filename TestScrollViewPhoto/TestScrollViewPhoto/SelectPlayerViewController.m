//
//  SelectPlayerViewController.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 7/11/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "SelectPlayerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SelectPlayerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView1;
@property (nonatomic, weak) IBOutlet UIImageView *imageView2;
@property (nonatomic, weak) IBOutlet UIImageView *imageView3;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation SelectPlayerViewController
{
    ALAssetsLibrary *library;
    NSMutableArray *myPhotos;
    UITapGestureRecognizer *tap;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myPhotos = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (index != NSNotFound) {
                UIImage *myImage = [UIImage imageWithCGImage:[result thumbnail]];
                if (myImage) {
                    [myPhotos addObject:myImage];
                    if (myPhotos.count > 5) {
                        *stop = YES;
                    }
                }
                NSLog(@"%d", myPhotos.count);
            }
        }];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error %@", error.localizedDescription);
    }];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnTableView:)];
    [_tableView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView datasource & delegate;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myPhotos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const CELL_ID = @"PLAYER_CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.image = myPhotos[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Photo %i", indexPath.row + 1];
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - SelectPlayerViewController actions
- (IBAction)exitButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapOnTableView:(UITapGestureRecognizer *)tapGesture
{
    CGPoint currentPoint = [tapGesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:currentPoint];
    NSLog(@"IndexPath :%@", indexPath);
}

@end
