//
//  ViewController.m
//  14.5-IONSCache
//
//  Created by Long Vinh Nguyen on 11/14/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *imagePaths;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up data
    self.imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"Vacation Photos"];
    
    // register cell class
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView datasource & delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagePaths.count;
}

- (UIImage *)loadImageAtIndexPath:(NSUInteger)index
{
    // set up cache
    static NSCache *cache = nil;
    
    if (!cache) {
        cache = [[NSCache alloc] init];
    }
    
    // if already cached, returned immediately
    UIImage *image = [cache objectForKey:@(index)];
    if (image) {
        return [image isKindOfClass:[NSNull class]]?nil:image;
    }
    
    // set place holder to avoid reloading imge multiple items
    [cache setObject:[NSNull null] forKey:@(index)];
    
    // switch to background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        // load image
        NSString *imagePath = self.imagePaths[index];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        // redraw image using device context
        UIGraphicsBeginImageContextWithOptions(image.size, YES, 0);
        [image drawAtPoint:CGPointZero];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // cache the image
            [cache setObject:image forKey:@(index)];
            
            // display the image
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            UIImageView *imageView = [cell.contentView.subviews lastObject];
            imageView.image = image;
        });
    });
    
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // dequeue cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    // add image view
    UIImageView *imageView = [cell.contentView.subviews lastObject];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imageView];
    }
    
    // set or load image for index
    imageView.image = [self loadImageAtIndexPath:indexPath.item];
    
    // preload image
    if (indexPath.item < self.imagePaths.count - 1) {
        [self loadImageAtIndexPath:indexPath.item + 1];
    }
    
    if (indexPath.item > 0) {
        [self loadImageAtIndexPath:indexPath.item - 1];
    }
    
    return cell;
    
}

@end
