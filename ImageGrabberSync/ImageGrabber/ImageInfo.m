//
//  ImageInfo.m
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "ImageInfo.h"
#import "ASIHTTPRequest.h"

@implementation ImageInfo
@synthesize sourceURL, imageName, image;


- (id)initWithSourceURL:(NSURL *)URL {
    if ((self = [super init])) {
        sourceURL = URL;
        imageName = [[URL lastPathComponent] retain];
        [self getImage];
    }
    return self;
}

- (id)initWithSourceURL:(NSURL *)URL imageName:(NSString *)name image:(UIImage *)i {
    if ((self = [super init])) {
        sourceURL = URL;
        imageName = name;
        image = i;
    }
    return self;
}


- (void)getImage {
    
    NSLog(@"Getting %@...", sourceURL);
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:sourceURL];
    [request setCompletionBlock:^{
        NSLog(@"Image downloaded.");
        NSData *data = [request responseData];
        image = [[UIImage imageWithData:data] retain];
        [[NSNotificationCenter defaultCenter] postNotificationName:STRING_POST_NOTIFICATION_IMAGE_UPDATED object:self];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error downloading image: %@", error.localizedDescription);
    }];
    
    [request startAsynchronous];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Image Info: %@", sourceURL];
}

@end
