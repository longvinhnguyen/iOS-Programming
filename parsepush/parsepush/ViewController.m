//
//  ViewController.m
//  parsepush
//
//  Created by Long Vinh Nguyen on 8/4/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//
#import <Parse/Parse.h>

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

- (IBAction)sendMessage:(id)sender
{
    PFQuery *pushQuery = [PFInstallation query];
    if ([[UIDevice currentDevice].model rangeOfString:@"iPad"].length == 0) {
        [pushQuery whereKey:@"deviceToken" equalTo:@"d0d86fd0cb6be314ca2c5dcf2885fc93e69c28ec8a1ea16fc96209c0a572ab7c"];
    } else {
        [pushQuery whereKey:@"deviceToken" equalTo:@"e7d86db3d69cc37da7d164e37f7ef6eebcb3f062ab42372e4d687c054a03d85c"];
    }
    [PFPush sendPushMessageToQueryInBackground:pushQuery withMessage:@"Hello Parse!!! I am going to build an innovative Push Message App" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Your message has been sent successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        } else {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
        }
    }];
    
}

@end
