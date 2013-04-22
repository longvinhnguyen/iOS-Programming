//
//  ViewController.h
//  CoolButton
//
//  Created by Long Vinh Nguyen on 4/22/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoolButton;

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet CoolButton *coolButton;

- (IBAction)hueValueChanged:(id)sender;
- (IBAction)saturationValueChanged:(id)sender;
- (IBAction)brightnessValueChanged:(id)sender;


@end
