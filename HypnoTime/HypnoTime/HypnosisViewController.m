//
//  HypnosisViewController.m
//  HypnoTime
//
//  Created by Long Vinh Nguyen on 1/27/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"

@implementation HypnosisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Get the tab bar item
        UITabBarItem *tbi = [self tabBarItem];
        
        // Give it a label
        [tbi setTitle:@"Hypnosis"];
        
        UIImage *i = [ UIImage imageNamed:@"Time.png"];
        [tbi setImage:i];
    }
    return self;
}

- (void)loadView
{
    // Create a view
    CGRect frame = [[UIScreen mainScreen] bounds];
    HypnosisView *v = [[HypnosisView alloc] initWithFrame:frame];
    
    // Set it as the view of this view controller
    [self setView:v];
}

-(void)viewDidLoad
{
    // Always call the super implementation of viewDidLoad
    [super viewDidLoad];
    
    NSLog(@"HypnosisViewController loaded its view.");
}

@end
