//
//  AppDelegate.m
//  iSocial
//
//  Created by Felipe on 9/3/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

#pragma mark - App Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.accountStore = [[ACAccountStore alloc] init];
    
    
    return YES;
}


#pragma mark
#pragma mark - Social Framework Methods
- (void)getFacebookAccount
{
    ACAccountType *facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *facebokOptions = @{ACFacebookAppIdKey: FACEBOOK_APP_ID_KEY, ACFacebookPermissionsKey:@[@"email", @"read_stream", @"user_relationships", @"user_likes", @"user_website"], ACFacebookAudienceKey: ACFacebookAudienceEveryone};
        
        [self.accountStore requestAccessToAccountsWithType:facebookAccountType options:facebokOptions completion:^(BOOL granted, NSError *error) {
            if (granted) {
                [self getPublishStream];
            } else {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook" message:[NSString stringWithFormat:@"There was an error retrieving your facebook account, make sure you have an account setup in Settings and that access is granted for iSocial %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                        [alertView show];
                    });
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Access to Facebook was not granted. Please go to the device settings and allow access for iSocial" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }];
        
    });
}


- (void)getPublishStream
{
    ACAccountType *facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *facebookOptions = @{ACFacebookAppIdKey: FACEBOOK_APP_ID_KEY, ACFacebookPermissionsKey:@[@"publish_actions"], ACFacebookAudienceKey: ACFacebookAudienceEveryone};
        [self.accountStore requestAccessToAccountsWithType:facebookAccountType options:facebookOptions completion:^(BOOL granted, NSError *error) {
            if (granted) {
                self.facebookAccount = [[self.accountStore accountsWithAccountType:facebookAccountType] lastObject];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:AccountFacebookAccountAccessGranted object:nil];
                });
            } else {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"There was an error retrieving your Facebook account, make sure you have an account setup in Settings and that access is granted for iSocial" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                        [alertView show];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Access to Facebook was not granted. Please go to the device settings and allow access for iSocial" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                        [alertView show];
                    });
                }
            }
        }];
    });
}

- (void)getTwitterAccount
{
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
            if (granted) {
                NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
                NSString *twitterAccountIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:AccountTwitterSelectedAccountIdentifier];
                self.twitterAccount = [self.accountStore accountWithIdentifier:twitterAccountIdentifier];
                
                if (self.twitterAccount) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:AccountTwitterAccountAccessGranted object:nil];
                    });
                } else {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AccountTwitterSelectedAccountIdentifier];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    if (twitterAccounts.count > 1) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Select one of your Twitter Accounts" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                        
                        for (ACAccount *account in twitterAccounts) {
                            [alertView addButtonWithTitle:account.accountDescription];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [alertView show];
                        });
                    } else {
                        self.twitterAccount = [twitterAccounts lastObject];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:AccountTwitterAccountAccessGranted object:nil];
                        });
                    }
                }
            } else {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"There was an error retrieving your Twitter account, make sure you have an account setup in Settings and that access is granted for iSocial" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                        [alertView show];
                    });
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Access to Twitter was not granted. Please go to the device settings and allow access for iSocial" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }];
    });
}

#pragma mark
#pragma mark - UIAlertView delegate & Helper
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
        
        self.twitterAccount = twitterAccounts[buttonIndex - 1];
        [[NSUserDefaults standardUserDefaults] setObject:self.twitterAccount.identifier forKey:AccountTwitterSelectedAccountIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AccountTwitterAccountAccessGranted object:nil];
        
    }
}

- (void)presentErrorWithMessage:(NSString *)errorMessage
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alertView show];
    });

}







@end
