//
//  AppDelegate.h
//  iSocial
//
//  Created by Felipe on 9/3/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccount *facebookAccount;
@property (nonatomic, strong) ACAccount *twitterAccount;

- (void)getFacebookAccount;
- (void)getTwitterAccount;

- (void)presentErrorWithMessage:(NSString *)errorMessage;

@end
