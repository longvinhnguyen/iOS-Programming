//
//  BullsEyeViewController.m
//  BullsEye
//
//  Created by Long Vinh Nguyen on 4/15/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "BullsEyeViewController.h"
#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BullsEyeViewController ()
{
    int currentValue;
    int targetValue;
    int score;
    int round;
}

@end

@implementation BullsEyeViewController

-(void)updateLabels
{
    self.targetLabel.text =[NSString stringWithFormat:@"%d",targetValue];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    self.roundLabel.text = [NSString stringWithFormat:@"%d",round];
}

- (void)startNewRound
{
    round ++;
    targetValue = 1 + (arc4random() % 100);
    currentValue = 50;
    self.slider.value = currentValue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self startNewGame];
    [self updateLabels];
    
    // Customize slider's appearance
    UIImage  *thumbImageNormal = [UIImage imageNamed:@"SliderThumb-Normal"];
    [self.slider setThumbImage:thumbImageNormal forState:UIControlStateNormal];
    
    UIImage *thumbImageHightlighted = [UIImage imageNamed:@"SliderThumb-Highlighted"];
    [self.slider setThumbImage:thumbImageHightlighted forState:UIControlStateHighlighted];
    
    UIImage *trackLeftImage = [[UIImage imageNamed:@"SliderTrackLeft"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    [self.slider setMinimumTrackImage:trackLeftImage forState:UIControlStateNormal];
    
    UIImage *trackRightImage = [[UIImage imageNamed:@"SliderTrackRight"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    [self.slider setMaximumTrackImage:trackRightImage forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert
{
    int difference = abs(currentValue - targetValue);
    int points = 100 - difference;
    NSString *title;

    if (difference == 0) {
        title = @"Perfect";
        points += 100;
    } else if (difference < 5) {
        if (difference == 1) {
            points += 50;
        }
        title = @"You almost got it";
    } else if (difference < 10) {
        title = @"Pretty good";
    } else {
        title = @"Not even close...";
    }
    
    score += points;
    NSString *message = [NSString stringWithFormat:@"You scored %d points", points];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Awesome" otherButtonTitles: nil];
    [alertView show];

}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)sliderMoved:(UISlider *)sender
{
    currentValue = lroundf(sender.value);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self startNewRound];
    [self updateLabels];
}

- (void)startNewGame{
    score = 0;
    round = 0;
    [self startNewRound];
}

- (void)startOver;
{
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self startNewGame];
    [self updateLabels];
    [self.view.layer addAnimation:transition forKey:nil];
}

- (void)showInfo:(id)sender
{
    AboutViewController *controller = [[AboutViewController alloc] init];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}







@end
