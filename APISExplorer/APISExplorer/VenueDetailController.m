//
//  VenueDetailControllerViewController.m
//  APISExplorer
//
//  Created by Long Vinh Nguyen on 6/17/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "VenueDetailController.h"
#import "Venue.h"
#import <AFNetworking/AFNetworking.h>

@interface VenueDetailController ()

@end

@implementation VenueDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _name.text = _venue.title;
    _address.text = _venue.detailTitle;
    _phoneNumber.text = _venue.phoneNumber;
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:STRING_ROOT_URL_REQUEST_GOOLGE_PLACES]];
//    [client setDefaultHeader:@"Accept" value:@"image/jpg"];

    
    if (self.venue.photoImageRef.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:_venue.photoImageRef forKey:@"photoreference"];
        [params setValue:@"300" forKey:@"maxwidth"];
        [params setValue:@"true" forKey:@"sensor"];
        [params setValue:GOOGLE_MAP_API_KEY forKey:@"key"];



        [client getPath:@"photo" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIImage *image = [UIImage imageWithData:responseObject];
            self.imageView.image = image;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (error) {
                VLog(@"%@ %@", error.localizedDescription, operation.request.URL);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonTapped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonTapped:(id)sender {
    VLog(@"Save button tapped");
}
@end
