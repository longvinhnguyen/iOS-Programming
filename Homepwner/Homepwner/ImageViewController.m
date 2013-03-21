//
//  ImageViewController.m
//  Homepwner
//
//  Created by Long Vinh Nguyen on 2/2/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    CGSize sz = [[self image] size];
    [scrollView setContentSize:sz];
    [imageView setFrame:CGRectMake(0, 0, sz.width, sz.height)];
    [imageView setImage:[self image]];
}


@end
