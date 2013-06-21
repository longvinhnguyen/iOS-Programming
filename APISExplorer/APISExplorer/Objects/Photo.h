//
//  Photo.h
//  APISExplorer
//
//  Created by Long Vinh Nguyen on 6/21/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) NSString *photoID;
@property (nonatomic, copy) NSURL *photoURL;

- (void)loadPhotoFromFlickr:(NSDictionary *)data;

@end
