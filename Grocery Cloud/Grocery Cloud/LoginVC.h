//
//  LoginVC.h
//  Grocery Cloud
//
//  Created by Long Vinh Nguyen on 1/4/14.
//  Copyright (c) 2014 Tim Roadley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIView *activityIndicatorBackground;

- (IBAction)create:(id)sender;
- (IBAction)authenticate:(id)sender;

@end
