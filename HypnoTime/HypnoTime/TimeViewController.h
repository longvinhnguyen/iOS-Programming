//
//  TimeViewController.h
//  HypnoTime
//
//  Created by Long Vinh Nguyen on 1/27/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeViewController : UIViewController
{
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UIButton *timeButton;
    
}

- (IBAction)showCurrentTime:(id)sender;
- (void) spinTimeLabel;
- (void) bounceTimeLabel;
- (void) slideTimeButton;

@end
