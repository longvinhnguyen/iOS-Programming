//
//  ViewController.h
//  CocoaPodsExample
//
//  Created by Long Vinh Nguyen on 5/6/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,weak) IBOutlet UIScrollView *showScrollView;
@property (nonatomic,weak) IBOutlet UIPageControl *showPageControl;

- (IBAction)pageChanged:(id)sender;

@end
