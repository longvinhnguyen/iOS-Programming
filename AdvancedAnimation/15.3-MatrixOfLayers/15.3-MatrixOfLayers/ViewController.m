//
//  ViewController.m
//  15.3-MatrixOfLayers
//
//  Created by Long Vinh Nguyen on 11/16/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

#define WIDTH   10
#define HEIGHT   10
#define DEPTH   10

#define SIZE    100
#define SPACING 150

#define CAMERA_DISTANCE 500

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set content size
    self.scrollView.contentSize = CGSizeMake((WIDTH - 1) * SPACING, (HEIGHT - 1)  * SPACING);
    
    // set up perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / CAMERA_DISTANCE;
    self.scrollView.layer.sublayerTransform = transform;
    
    // create layers
    for (int z = DEPTH - 1; z >= 0; z--) {
        for (int y = 0; y < HEIGHT; y++) {
            for (int x = 0; x < WIDTH; x++) {
                // create layer
                CALayer *layer = [CALayer layer];
                layer.frame = CGRectMake(0, 0, SIZE, SIZE);
                layer.position = CGPointMake(x*SPACING, y*SPACING);
                layer.zPosition = -z*SPACING;
                
                // set background color
                layer.backgroundColor = [UIColor colorWithWhite: 1-z*( 1.0/ DEPTH)alpha:1.0].CGColor;
                [self.scrollView.layer addSublayer:layer];
            }
        }
    }
    
    // log
    NSLog(@"displayed: %i", DEPTH*HEIGHT*WIDTH);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
