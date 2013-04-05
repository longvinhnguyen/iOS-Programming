//
//  FlickrPhotoViewController.h
//  FlickSearch
//
//  Created by VisiKard MacBook Pro on 4/5/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlickrPhoto;


@interface FlickrPhotoViewController : UIViewController

@property (nonatomic, strong) FlickrPhoto *photo;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
- (IBAction)done:(id)sender;

- (id)initWithPhoto:(FlickrPhoto *) pt;

@end
