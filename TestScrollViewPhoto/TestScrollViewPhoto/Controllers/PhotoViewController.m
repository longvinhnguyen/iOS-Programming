//
//  PhotoViewController.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 7/31/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!self.photo.image) {
        [self.photo setImageWithURL:[NSURL URLWithString:_photoURL]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)filterImage:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = UIImageJPEGRepresentation(self.photo.image, 1.0f);
        UIImage *testImage = [UIImage imageWithData:data];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *image = [CIImage imageWithCGImage:testImage.CGImage];
        CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, image, @"inputRadius", [NSNumber numberWithFloat:5.0f], nil];
        CIFilter *spetialFilter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey, image, @"inputIntensity", [NSNumber numberWithFloat:0.8f], nil];
        CIImage *ciImage = [blurFilter outputImage];
        
        CGImageRef imageRef = [context createCGImage: ciImage fromRect:ciImage.extent];
        UIImage *blurImage = [UIImage imageWithCGImage:imageRef];

        self.photo.image = blurImage;

        CGImageRelease(imageRef);
        
    });
}

@end
