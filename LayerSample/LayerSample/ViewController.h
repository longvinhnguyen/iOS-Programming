//
//  ViewController.h
//  LayerSample
//
//  Created by VisiKard MacBook Pro on 9/30/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *layerView;
@property (nonatomic, weak) IBOutlet UIView *redView;
@property (nonatomic, weak) IBOutlet UIView *greenView;

@end