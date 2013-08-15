//
//  PhotoViewController.h
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 7/31/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoViewControllerDelegate<NSObject>

- (void)photoViewControllerDidChangePhotoEffect:(UIImage *)image;

@end

@interface PhotoViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *photo;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *effectButton;
@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) NSString *photoURL;

@end
