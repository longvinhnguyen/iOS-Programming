//
//  ViewController.m
//  CollectionViewTutorial
//
//  Created by VisiKard MacBook Pro on 8/24/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "ViewController.h"
#import "BHAlbumPhotoCell.h"
#import "BHAlbumTitleReusableView.h"
#import "BHPhotoAlbumLayout.h"
#import "BHAlbum.h"
#import "BHPhoto.h"
#import "BHEmblemView.h"

static NSString *const PhotoCellIdentifier = @"PhotoCell";
static NSString *const AlbumTitleIdentifier = @"AlbumTitle";
static NSString *const EmblemIdentifier = @"AlbumTitle";

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    [self.collectionView registerClass:[BHAlbumPhotoCell class] forCellWithReuseIdentifier:PhotoCellIdentifier];
    [self.collectionView registerClass:[BHAlbumTitleReusableView class]
            forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind
                   withReuseIdentifier:AlbumTitleIdentifier];
    [self.collectionView registerClass:[BHEmblemView class] forSupplementaryViewOfKind:@"Emblem" withReuseIdentifier:EmblemIdentifier];
    
    self.albums = [NSMutableArray new];
    
    NSURL *urlPrefix = [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
    NSInteger photoIndex = 0;
    
    for (NSInteger a = 0; a < 12; a++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        album.name = [NSString stringWithFormat:@"Photo Album %d", a + 1];
        
        NSUInteger photoCount = arc4random() % 4 + 2;
        for (NSInteger i = 0; i < photoCount; i++) {
            NSString *photoFileName = [NSString stringWithFormat:@"thumbnail%d.jpg", photoIndex%25];
            NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFileName];
            BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
            [album addPhoto:photo];
            
            photoIndex ++;
        }
        [self.albums addObject:album];
    }
    
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView datasource & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.albums.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    BHAlbum *album = self.albums[section];
    return album.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BHAlbumPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
    
    //
    BHAlbum *album = self.albums[indexPath.section];
    BHPhoto *photo = album.photos[indexPath.item];
    
    // load PhotoImage in the background
    __weak ViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [photo image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // then set them via main queue if the cell is still visible
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                BHAlbumPhotoCell *cell = (BHAlbumPhotoCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
                
            }
        });
    }];
    operation.queuePriority = (indexPath.item == 0)?NSOperationQueuePriorityHigh:NSOperationQueuePriorityNormal;
    [self.thumbnailQueue addOperation:operation];
    
    return photoCell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *titleView;
    if (kind == BHPhotoAlbumLayoutAlbumTitleKind) {
        BHAlbumTitleReusableView *albumTitleView = [collectionView dequeueReusableSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind withReuseIdentifier:AlbumTitleIdentifier forIndexPath:indexPath];
        BHAlbum *album = self.albums[indexPath.section];
        albumTitleView.titleLabel.text = album.name;
        titleView =  albumTitleView;
    } else {
        BHEmblemView *decorationView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
        titleView = decorationView;
    }

    
    return titleView;
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
