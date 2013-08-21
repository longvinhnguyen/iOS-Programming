//
//  GalleryViewController.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 8/21/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "GalleryViewController.h"
#import "PictureViewCell.h"
#import "GalleryCollectionFlowLayout.h"
#import <QuartzCore/QuartzCore.h>

#define CElL_SIZE   150
#define kPictureCell    @"PICTURE_CELL"

@interface GalleryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *galleryView;

@end

@implementation GalleryViewController
{
    NSArray *pictures;
    IBOutlet GalleryCollectionFlowLayout *galleryLayout;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < 15; i++) {
        [temp addObject:[UIImage imageNamed:@"rex_hotel.jpg"]];
    }
    pictures = temp;
    
    UINib *nib = [UINib nibWithNibName:[PictureViewCell.class description] bundle:nil];
    [_galleryView registerNib:nib forCellWithReuseIdentifier:kPictureCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView delegate & datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return pictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPictureCell forIndexPath:indexPath];
    cell.layer.masksToBounds = NO;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.shadowRadius = 1.0f;
    
    
    UIImage *picture = pictures[indexPath.row];
    cell.imageView.image = picture;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CElL_SIZE, CElL_SIZE);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15.0f, 10.0f, 0, 10.0f);
}

@end
