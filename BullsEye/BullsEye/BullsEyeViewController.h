//
//  BullsEyeViewController.h
//  BullsEye
//
//  Created by Long Vinh Nguyen on 4/15/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BullsEyeViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UILabel *targetLabel;
@property (nonatomic, strong) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) IBOutlet UILabel *roundLabel;

- (IBAction)showAlert;
- (IBAction)sliderMoved:(UISlider *)sender;
- (IBAction)startOver;
- (IBAction)showInfo:(id)sender;

@end
