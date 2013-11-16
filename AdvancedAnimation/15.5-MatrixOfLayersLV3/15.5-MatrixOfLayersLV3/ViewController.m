//
//  ViewController.m
//  15.5-MatrixOfLayersLV3
//
//  Created by Long Vinh Nguyen on 11/16/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

#define WIDTH 100
#define HEIGHT 100
#define DEPTH 10

#define SIZE 100
#define SPACING 150

#define CAMERA_DISTANCE 500
#define PERSPECTIVE(z) (float)CAMERA_DISTANCE/(z + CAMERA_DISTANCE)

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableSet *recyclePool;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create recyclePool
    self.recyclePool = [NSMutableSet set];
    
    // set content size
    self.scrollView.contentSize = CGSizeMake((WIDTH - 1) * SPACING, (HEIGHT - 1) *SPACING);
    
    // set up perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / CAMERA_DISTANCE;
    
    self.scrollView.layer.sublayerTransform = transform;
}

- (void)viewDidLayoutSubviews
{
    [self updateLayers];
}

- (void)updateLayers
{
    // calculate clipping bounds
    CGRect bounds = self.scrollView.bounds;
    bounds.origin = self.scrollView.contentOffset;
    bounds = CGRectInset(bounds, -SIZE/2, -SIZE/2);
    
    // add existing layer to the pool
    [self.recyclePool addObjectsFromArray:self.scrollView.layer.sublayers];
    
    
    // disable animation
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    // create layers
    NSInteger recycled = 0;
    
    NSMutableArray *visibleLayers = [NSMutableArray new];
    
    for (int z = DEPTH - 1; z >= 0; z--) {
        // increase bounds size to compensate for perspective
        CGRect adjusted = bounds;
        adjusted.size.width /= PERSPECTIVE(z*SPACING);
        adjusted.size.height /= PERSPECTIVE(z*SPACING);
        adjusted.origin.x -= (adjusted.size.width - bounds.size.width) / 2;
        adjusted.origin.y -= (adjusted.size.height - bounds.size.height) / 2;
        
        for (int y = 0; y < HEIGHT; y++) {
            // check if vertically outside visible rect
            if (y*SPACING < adjusted.origin.y || y*SPACING >= adjusted.origin.y + adjusted.size.height) {
                continue;
            }
            
            for (int x = 0; x < WIDTH; x++) {
                if (x*SPACING < adjusted.origin.x || x*SPACING >= adjusted.origin.x + adjusted.size.width) {
                    continue;
                }
                
                
                // Recyle layer if available
                CALayer *layer = [self.recyclePool anyObject];
                if (layer) {
                    recycled ++;
                    [self.recyclePool removeObject:layer];
                } else {
                    // other wise create a new one
                    layer = [CALayer layer];
                    layer.frame = CGRectMake(0, 0, SIZE, SIZE);
                }
                
                // set position
                layer.position = CGPointMake(x*SPACING, y*SPACING);
                layer.zPosition = -z*SPACING;
                layer.backgroundColor = [UIColor colorWithWhite:1-z*(1.0/DEPTH) alpha:1.0f].CGColor;
                
                [visibleLayers addObject:layer];
            }
        }
    }
    
    [CATransaction commit];
    
    // udpate layers
    self.scrollView.layer.sublayers = visibleLayers;
    
    // log
    NSLog(@"displayed: %i/%i recycled: %i", [visibleLayers count], DEPTH*WIDTH*HEIGHT, recycled);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateLayers];
}

@end
