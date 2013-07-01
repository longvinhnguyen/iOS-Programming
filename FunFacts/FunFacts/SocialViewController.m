//
//  ViewController.m
//  FunFacts
//
//  Created by Long Vinh Nguyen on 6/25/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "SocialViewController.h"
#import "FunActivity.h"
#import <QuartzCore/QuartzCore.h>

#define AUTHOR_FACTS_KEY    @"facts"
#define AUTHOR_IMAGE_KEY    @"image"
#define AUTHOR_NAME_KEY     @"name"
#define AUTHOR_TWITTER_KEY  @"twitter"

typedef enum
{
    SocicalButtonTagFacebook = 1010,
    SocicalButtonTagSinaWeibo= 1020,
    SocicalButtonTagTwitter = 1000
} SocicalButtonTags;

@interface SocialViewController ()

@property (nonatomic, weak) IBOutlet UIButton *actionButton;
@property (nonatomic, weak) IBOutlet UIButton *facebookButton;
@property (nonatomic, weak) IBOutlet UIView *authorBackgroundView;
@property (nonatomic, weak) IBOutlet UIImageView *authorImageView;

@property (nonatomic, weak) IBOutlet UITextView *faceTextView;
@property (nonatomic, weak) IBOutlet UILabel *factTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIButton *twitterButton;
@property (nonatomic, weak) IBOutlet UILabel *twitterLabel;
@property (nonatomic, weak) IBOutlet UIButton *weiboButton;

@property (nonatomic, strong) NSArray *authorsArray;
@property (nonatomic, assign) BOOL deviceWasShaken;

@end

@implementation SocialViewController

#pragma mark - SocicalViewController lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    VLog(@"Authors Array = %@",self.authorsArray);
    
    self.authorBackgroundView.layer.borderWidth = 1.0f;
    self.authorBackgroundView.layer.borderColor = [[UIColor colorWithWhite:0.2f alpha:1.0] CGColor];
    self.authorBackgroundView.layer.cornerRadius = 10.0f;
    self.authorBackgroundView.layer.masksToBounds = YES;
    
    self.authorImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.authorImageView.image = [UIImage imageNamed:@"funfacts"];
    self.authorImageView.layer.borderWidth = 1.0f;
    self.authorImageView.layer.borderColor = [[UIColor colorWithWhite:0.2f alpha:1.0f] CGColor];
    self.authorImageView.layer.shadowColor = [[UIColor colorWithWhite:0.75 alpha:1.0] CGColor];
    self.authorImageView.layer.shadowOffset = CGSizeMake(-1.0f, -1.0f);
    self.authorImageView.layer.opacity = 0.5f;
    
    self.faceTextView.text = @"Shake to get a Fun Fact from random iOS 6 Tutorials author and editor";
    self.faceTextView.layer.borderWidth = 1.0f;
    self.faceTextView.layer.borderColor = [[UIColor colorWithWhite:02.f alpha:1.0f] CGColor];
    self.faceTextView.layer.cornerRadius = 10.0f;
    self.faceTextView.layer.masksToBounds = YES;
    self.faceTextView.layer.shadowColor = [[UIColor colorWithWhite:0.75f alpha:1.0f] CGColor];
    self.faceTextView.layer.shadowOffset =  CGSizeMake(-1.0f, -1.0f);
    self.faceTextView.layer.opacity = 0.5f;
    
    self.factTitleLabel.hidden = YES;
    
    self.nameLabel.text = self.twitterLabel.text = @"";
    
    [self.actionButton setBackgroundImage:[[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)] forState:UIControlStateNormal];
    [self.twitterButton setBackgroundImage:[[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)] forState:UIControlStateNormal];
    [self.facebookButton setBackgroundImage:[[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)] forState:UIControlStateNormal];
    [self.weiboButton setBackgroundImage:[[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)] forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        _deviceWasShaken = YES;
        
        //1
        NSUInteger authorRandSize = self.authorsArray.count;
        NSUInteger authorRandIndex = (arc4random() % (unsigned)authorRandSize);
        
        //2
        NSDictionary *authorDictionary = self.authorsArray[authorRandIndex];
        
        //3
        NSArray *facts = authorDictionary[AUTHOR_FACTS_KEY];
        NSString *image = authorDictionary[AUTHOR_IMAGE_KEY];
        NSString *name = authorDictionary[AUTHOR_NAME_KEY];
        NSString *twitter = authorDictionary[AUTHOR_TWITTER_KEY];
        
        //4
        NSUInteger factsRandSize = facts.count;
        NSUInteger factsRandIndex = (arc4random() % (unsigned)factsRandSize);
        
        //5
        self.factTitleLabel.hidden = NO;
        self.faceTextView.text = facts[factsRandIndex];
        self.nameLabel.text = name;
        self.twitterLabel.text = twitter;
        self.authorImageView.image = [UIImage imageNamed:image];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
}

#pragma mark -SVC accessors
- (NSArray *)authorsArray
{
    if (!_authorsArray) {
        NSString *authorsArrayPath = [[NSBundle mainBundle] pathForResource:@"FactsList" ofType:@"plist"];
        _authorsArray = [NSArray arrayWithContentsOfFile:authorsArrayPath];
    }
    return _authorsArray;
}




#pragma mark - SocialViewController actions
- (IBAction)actionTapped
{
    if (self.deviceWasShaken) {
        FunActivity *funActivity = [[FunActivity alloc] init];
        NSString *initialTextString = [NSString stringWithFormat:@"Fun Fact: %@", self.faceTextView.text];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[initialTextString, self.authorImageView.image] applicationActivities:@[funActivity]];
        [self presentViewController:activityViewController animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Shake" message:@"Before you can share, please shake the device in order to get a random fun fact" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)socialTapped:(id)sender
{
    //1
    NSString *serviceType = @"";
    if (self.deviceWasShaken) {
        switch (((UIButton *)sender).tag) {
            case SocicalButtonTagFacebook:
                serviceType = SLServiceTypeFacebook;
                break;
            case SocicalButtonTagSinaWeibo:
                serviceType = SLServiceTypeSinaWeibo;
                break;
            case SocicalButtonTagTwitter:
                serviceType = SLServiceTypeTwitter;
                break;
                
            default:
                break;
        }
        
        if (![SLComposeViewController isAvailableForServiceType:serviceType]) {
            [self showUnavailableForServiceType:serviceType];
        } else {
            SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:serviceType];
            [composeViewController addImage:self.authorImageView.image];
            NSString *initialTextString = [NSString stringWithFormat:@"%@",self.faceTextView.text];
            [composeViewController setInitialText:initialTextString];
            [self presentViewController:composeViewController animated:YES completion:nil];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Shake" message:@"Before you can share, please shake the device in order to get a random fun fact" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)showUnavailableForServiceType:(NSString *)serviceType
{
    NSString *serviceName = @"";
    if (serviceType == SLServiceTypeFacebook) {
        serviceName = @"Facebook";
    } else if (serviceType == SLServiceTypeSinaWeibo) {
        serviceName = @"SinaWeibo";
    } else if (serviceType == SLServiceTypeTwitter) {
        serviceName = @"Twitter";
    }

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Account" message:[NSString stringWithFormat:@"Please go to the device settings and add %@ account in order to share through that service.", serviceName]  delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alertView show];

}

@end
