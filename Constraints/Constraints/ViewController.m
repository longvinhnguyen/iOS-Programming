//
//  ViewController.m
//  Constraints
//
//  Created by Long Vinh Nguyen on 7/18/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonTapped:(id)sender
{
    static NSArray *artists;
    if (!artists) {
        artists = @[@"Thelonious Monk", @"Miles Davis", @"Louis Jordan & His Tympany Five", @"Charlie 'Bird' Parker", @"Chet Parker"];
    }
    
    static int index = 0;
    self.artistNameLabel.text = artists[index%5];
    index ++;
}

@end
