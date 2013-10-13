//
//  ViewController.m
//  6.12-CATileLayer
//
//  Created by Long Vinh Nguyen on 10/13/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add the tiled layer
    CATiledLayer *tileLayer = [CATiledLayer layer];
    tileLayer.frame = CGRectMake(0, 0, 2048, 2048);
    tileLayer.contentsScale = [UIScreen mainScreen].scale;
    tileLayer.delegate = self;
    [self.scrollView.layer addSublayer:tileLayer];
    self.scrollView.contentSize = tileLayer.frame.size;
    
    // draw layer
    [tileLayer setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx
{
    // determine tile coordinate
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    CGFloat scale = [UIScreen mainScreen].scale;
    NSInteger x = floor(bounds.origin.x / layer.tileSize.width * scale);
    NSInteger y = floor(bounds.origin.y / layer.tileSize.height * scale);
    
    // loading image
    NSString *imageName = [NSString stringWithFormat:@"Snowman_%02i_%02i", x, y];
    NSString *pathImage = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    UIImage *tileImage = [UIImage imageWithContentsOfFile:pathImage];
    
    // draw tile
    UIGraphicsPushContext(ctx);
    [tileImage drawInRect:bounds];
    UIGraphicsPopContext();
}

@end
