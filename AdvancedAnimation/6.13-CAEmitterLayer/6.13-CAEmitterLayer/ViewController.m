//
//  ViewController.m
//  6.13-CAEmitterLayer
//
//  Created by Long Vinh Nguyen on 10/13/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create particle emitter layer
//    self.containerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:emitter];
    
    // configure emitter
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.anchorPoint = CGPointMake(0.5, 0.5);
    
    // create a particle template
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"Spark.png"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = 5.0f;
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocity = 50;
    cell.emissionRange = M_PI * 2;
    
    emitter.emitterCells = @[cell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
