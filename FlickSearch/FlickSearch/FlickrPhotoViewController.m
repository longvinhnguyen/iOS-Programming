//
//  FlickrPhotoViewController.m
//  FlickSearch
//
//  Created by VisiKard MacBook Pro on 4/5/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "FlickrPhotoViewController.h"
#import "Flickr.h"
#import "FlickrPhoto.h"


@implementation FlickrPhotoViewController

- (id)initWithPhoto:(FlickrPhoto *)pt
{
    self = [super init];
    if (self) {
        _photo = pt;
    }
    return self;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.photo.largeImage) {
        self.imageView.image = self.photo.largeImage;
    } else {
        self.imageView.image = self.photo.thumbnail;
        [Flickr loadImageForPhoto:self.photo thumbnail:NO completionBlock:^(UIImage *photoImage, NSError *error){
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = self.photo.largeImage;
                });
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}







@end
