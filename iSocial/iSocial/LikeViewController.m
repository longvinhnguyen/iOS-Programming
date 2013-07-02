//
//  LikeViewController.m
//  iSocial
//
//  Created by Felipe on 9/3/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "LikeViewController.h"
#import "AppDelegate.h"


#define PhotoGraphURL   @"https://graph.facebook.com/167357120105659/likes"
#define PhotoURL    @"http://www.chrissycostanza.net/wp-content/uploads/2013/02/Chrissy+Costanza+Bio-668x351.jpg"

@interface LikeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) BOOL userLikesPhoto;


- (IBAction)likeTapped;

@end

@implementation LikeViewController


#pragma mark - LikeViewController lifecycle
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *imageURL = [NSURL URLWithString:PhotoURL];
        
        __block NSData *imageData;
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.coverImageView.image = [UIImage imageWithData:imageData];
            });
        });
    });
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://graph.facebook.com/me"] parameters:nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    request.account = appDelegate.facebookAccount;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error getting the user's ID. %@", error.localizedDescription]];
        } else {
            NSError *jsonError;
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
            if (jsonError) {
                [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error reading the user's ID. %@", error.localizedDescription]];
            } else {
                if (responseJSON[@"error"]) {
                    [appDelegate renewFacebookAccount];
                    [appDelegate presentErrorWithMessage:@"Your facebook account has been renewed. Please try again."];
                } else {
                    self.userID = responseJSON[@"id"];
                }
            }
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePhotoStatus) name:AccountFacebookAccountAccessGranted object:nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (appDelegate.facebookAccount) {
        [self updatePhotoStatus];
    } else {
        self.likeButton.enabled = NO;
        
        [appDelegate getFacebookAccount];
    }
}

- (void)updatePhotoStatus
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:PhotoGraphURL] parameters:nil];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error getting the status of the photo's likes. %@", error.localizedDescription]];
        } else {
            NSError *jsonError;
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            if (jsonError) {
                [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error reading the photo's status. %@", error.localizedDescription]];
                
            }
            NSString *userID = self.userID;
            NSArray *likes = responseJSON[@"data"];
            
            for (NSDictionary *user in likes) {
                if ([user[@"id"] isEqualToString:userID]) {
                    self.userLikesPhoto = YES;
                    break;
                }
            }
            
            self.likeButton.enabled = YES;
            
            if (self.userLikesPhoto) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.infoLabel.text = @"You have already liked this picture.";
                    [self.likeButton setTitle:@"Unlike this photo" forState:UIControlStateNormal];
                    
                });
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.infoLabel.text = @"You haven't liked this photo. Tap the button to like it.";
                    [self.likeButton setTitle:@"Like this Photo" forState:UIControlStateNormal];
                    
                });
            }
        }
    }];
    
}

#pragma mark - IBActions

- (IBAction)likeTapped
{
    self.likeButton.enabled = NO;
    if (self.userLikesPhoto) {
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodDELETE URL:[NSURL URLWithString:PhotoGraphURL] parameters:nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        request.account = appDelegate.facebookAccount;
        

        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.likeButton.enabled = YES;
            });
            if (error) {
                [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error unliking the photo. %@", error.localizedDescription]];
                
            } else {
                NSError *jsonError;
                id responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                
                if (jsonError) {
                    [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error unliking the photo. %@", error.localizedDescription]];
                } else {
                    VLog(@"responseJOSN %@", responseJSON);
                    if ([responseJSON intValue] == 1) {
                        self.userLikesPhoto = NO;
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            self.infoLabel.text = @"You haven't liked the picture. Tap the button to like it.";
                            [self.likeButton setTitle:@"Like this photo" forState:UIControlStateNormal];
                        });
                        
                    }
                }
            }
        }];
    } else {
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:PhotoGraphURL] parameters:nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        request.account = appDelegate.facebookAccount;
        
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (error) {
                [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error liking the photo. %@", error.localizedDescription]];
                
            } else {
                NSError *jsonError;
                id responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                VLog(@"responseJOSN SLRequestMethodPOST %@", responseJSON);
                if ([responseJSON intValue] == 1) {
                    self.userLikesPhoto = YES;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.infoLabel.text = @"You have already liked this photo";
                        [self.likeButton setTitle:@"Unlike this photo" forState:UIControlStateNormal];
                    });
                }
            }
        }];
    }
}

@end
