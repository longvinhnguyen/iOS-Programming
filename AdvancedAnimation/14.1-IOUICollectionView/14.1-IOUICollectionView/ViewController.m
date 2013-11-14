//
//  ViewController.m
//  14.1-IOUICollectionView
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

#pragma mark - UICollectionView delegate & datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagePaths.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // dequeue cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    // add image view
    const NSInteger imageTag = 99;
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:imageTag];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.tag = imageTag;
        [cell.contentView addSubview:imageView];
    }
    
    // clear image
    cell.tag = indexPath.row;
    imageView.image = nil;
    
    // switch to background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // load image
        NSInteger index = indexPath.row;
//        NSURL *imageURL = [NSURL fileURLWithPath:self.imagePaths[index]];
//        NSDictionary *options = @{(__bridge id)kCGImageSourceShouldCache: @YES};
//        CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
//        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, (__bridge CFDictionaryRef)options);
//        UIImage *image =  [UIImage imageWithCGImage:imageRef];
        NSString *imagePath = self.imagePaths[index];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        // redraw image using device context
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, YES, 0);
        [image drawInRect:imageView.bounds];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // set image on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (index == cell.tag) {
                imageView.image = image;
            }
        });
    });
    
    return cell;
}

@end
