//
//  CVViewController.h
//  FlickSearch
//
//  Created by Long Vinh Nguyen on 4/3/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flickr.h"
#import "FlickrPhoto.h"
#import <MessageUI/MessageUI.h>
@class SimpleFlowLayout;
@class FlickrPhotoHeaderView;

@interface CVViewController : UIViewController  <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate>

@property(nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) UICollectionView *currentPinchCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout1;
@property (nonatomic, strong) SimpleFlowLayout *layout2;


@property (nonatomic) BOOL sharing;

@property (nonatomic, strong) NSMutableDictionary *searchResults;
@property (nonatomic, strong) NSMutableArray *searches;
@property (nonatomic, strong) Flickr *flick;

-(IBAction)shareButtonTapped:(id)sender;

-(void)showMailComposerAndSend;
- (IBAction)layoutSelectionTapped:(id)sender;

@end
