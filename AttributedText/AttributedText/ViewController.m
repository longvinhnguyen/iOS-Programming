//
//  ViewController.m
//  AttributedText
//
//  Created by Long Vinh Nguyen on 7/3/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    IBOutlet UILabel *label;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *redAttrs = @{NSForegroundColorAttributeName: [UIColor redColor]};
    
    NSDictionary *greenAttrs = @{NSForegroundColorAttributeName: [UIColor greenColor]};
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:@"Red and Green text"];
    [aString setAttributes:redAttrs range:NSMakeRange(0, 3)];
    [aString setAttributes:greenAttrs range:NSMakeRange(8, 5)];
    
    label.attributedText = aString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
