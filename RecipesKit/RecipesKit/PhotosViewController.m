//
//  PhotosViewController.m
//  RecipesKit
//
//  Created by Long Vinh Nguyen on 7/12/13.
//  Copyright (c) 2013 Felipe Last Marsetti. All rights reserved.
//

#import "PhotosViewController.h"

@interface PhotosViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation PhotosViewController

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
    self.imageView.image = _image;
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil) {
        _image = nil;
        _imageView = nil;
        self.view = nil;
    }
    [super didReceiveMemoryWarning];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


@end
