//
//  AboutViewController.h
//  BullsEye
//
//  Created by Long Vinh Nguyen on 4/15/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;

- (IBAction)close:(id)sender;

@end
