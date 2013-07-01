//
//  ProfileViewController.m
//  iSocial
//
//  Created by Felipe on 9/3/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "WebViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *hometownLabel;
@property (weak, nonatomic) IBOutlet UILabel *languagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *relationshipStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;

@property (nonatomic, strong) NSDictionary *profileDictionary;

- (IBAction)viewOnFacebookTapped;
- (IBAction)viewWebsiteTapped;

@end

@implementation ProfileViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProfile) name:AccountFacebookAccountAccessGranted object:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.facebookAccount) {
        [self reloadProfile];
    } else {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate getFacebookAccount];
    }
    
}

- (void)reloadProfile
{
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://graph.facebook.com/me"] parameters:[NSDictionary dictionaryWithObject:@"bio, birthday, cover, email, first_name, gender, hometown, languages, last_name, link, location, picture, relationship_status, security_settings, username, website" forKey:@"fields"]];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    request.account = appDelegate.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error reading your facebook feed. %@", error.localizedDescription]];
         } else {
             NSError *jsonError;
             NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
             
             VLog(@"reloadProfile ======> %@", responseJSON);
             
             if (jsonError) {
                 AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                 [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error reading your facebook feed. %@", error.localizedDescription]];
             } else {
                 self.profileDictionary = responseJSON;
                 [self getPictures];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.bioTextView.text = self.profileDictionary[@"bio"];
                     self.birthdayLabel.text = self.profileDictionary[@"birthday"];
                     self.emailLabel.text = self.profileDictionary[@"email"];
                     self.genderLabel.text = self.profileDictionary[@"gender"];
                     self.hometownLabel.text = self.profileDictionary[@"hometown"][@"name"];
                     
                     NSArray *languages = self.profileDictionary[@"languages"];
                     NSMutableString *languagesString = [NSMutableString stringWithString:@""];
                     
                     for (int i = 0; i<languages.count; i++) {
                         NSDictionary *language = languages[i];
                         
                         [languagesString appendString:language[@"name"]];
                         
                         if (i < languages.count - 1) {
                             [languagesString appendString:@", "];
                         }
                     }
                     self.languagesLabel.text = languagesString;
                     
                     self.locationLabel.text = self.profileDictionary[@"location"][@"name"];
                     self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.profileDictionary[@"first_name"], self.profileDictionary[@"last_name"]];
                     self.usernameLabel.text = self.profileDictionary[@"username"];
                     self.relationshipStatusLabel.text = self.profileDictionary[@"relationship_status"];
                     
                     if (!self.profileDictionary[@"website"]) {
                         self.websiteButton.hidden = YES;
                     } else {
                         self.websiteButton.hidden = NO;
                     }
                     
                     self.facebookButton.hidden = NO;
                     
                 });
             }
         }
    }];
}

- (void)getPictures
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *pictureString = self.profileDictionary[@"picture"][@"data"][@"url"];
        NSURL *pictureURL = [NSURL URLWithString:pictureString];
        
        __block NSData *pictureData;
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            pictureData = [NSData dataWithContentsOfURL:pictureURL];
            UIImage *pictureImage = [UIImage imageWithData:pictureData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pictureImageView.image = pictureImage;
            });
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *coverURLString = self.profileDictionary[@"cover"][@"source"];
        NSURL *coverURL = [NSURL URLWithString:coverURLString];
        
        __block NSData *coverData;
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            coverData = [NSData dataWithContentsOfURL:coverURL];
            UIImage *coverImage = [UIImage imageWithData:coverData];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.coverImageView.image = coverImage;
            });
        });
    });
}

#pragma mark - IBActions

- (IBAction)viewOnFacebookTapped
{
    NSString *urlString = self.profileDictionary[@"link"];
    
    WebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:WebViewControllerIdentifier];
    webViewController.initialURLString = urlString;
    
    [self presentViewController:webViewController animated:YES completion:nil];
}

- (IBAction)viewWebsiteTapped
{
    NSString *urlString = self.profileDictionary[@"website"];
    
    WebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:WebViewControllerIdentifier];
    webViewController.initialURLString = urlString;
    
    [self presentViewController:webViewController animated:YES completion:nil];
}

@end
