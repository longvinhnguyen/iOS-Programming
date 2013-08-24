//
//  ViewController.m
//  CollectionViewTutorial
//
//  Created by VisiKard MacBook Pro on 8/24/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "ViewController.h"
#import "BHAlbumPhotoCell.h"
#import "BHPhotoAlbumLayout.h"

static NSString *const PhotoCellIdentifier = @"PhotoCell";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    [self.collectionView registerClass:[BHAlbumPhotoCell class] forCellWithReuseIdentifier:PhotoCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView datasource & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BHAlbumPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
    return photoCell;
    
}

#pragma mark - View Rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.photoAlbumLayout.numberOfColumns = 3;
        
        CGFloat sizeInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0 ? 45.0f : 25.0f;
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, sizeInset, 22.0f, sizeInset);
    } else {
        self.photoAlbumLayout.numberOfColumns = 2;
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}







@end
