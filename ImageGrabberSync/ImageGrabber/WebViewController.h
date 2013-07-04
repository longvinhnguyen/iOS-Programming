//
//  WebViewController.h
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageListViewController;

@interface WebViewController : UIViewController <UIWebViewDelegate> {    
    UIToolbar *toolbar;
    UIWebView *webView;
    int numLoads;
    UIBarButtonItem *grabButton;
}

@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (strong) ImageListViewController *imageListViewController;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *grabButton;
- (IBAction)grabTapped:(id)sender;

@end
