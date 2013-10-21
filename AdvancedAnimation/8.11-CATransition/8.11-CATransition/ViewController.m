//
//  ViewController.m
//  8.11-CATransition
//
//  Created by Long Vinh Nguyen on 10/21/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageview;
@property (nonatomic, copy) NSArray *images;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set up images
    self.images = @[[UIImage imageNamed:@"Anchor"],
                    [UIImage imageNamed:@"Cone"],
                    [UIImage imageNamed:@"Igloo"],
                    [UIImage imageNamed:@"Spaceship"]];
    
}

- (IBAction)switchImage
{
    // set up cross fade transition
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    
    //
    [self.imageview.layer addAnimation:transition forKey:nil];
    
    //
    UIImage *currentImage = self.imageview.image;
    NSUInteger index = [self.images indexOfObject:currentImage];
    index = (index + 1) % self.images.count;
    self.imageview.image = self.images[index];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
