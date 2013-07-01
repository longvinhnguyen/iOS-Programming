//
//  FacebookFeedViewController.m
//  iSocial
//
//  Created by Felipe on 9/3/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "FacebookFeedViewController.h"
#import "AppDelegate.h"
#import "PhotoCell.h"
#import "MessageCell.h"
#import "FacebookCell.h"
#import "CommentViewController.h"
#import "WebViewController.h"

@interface FacebookFeedViewController ()

@property (atomic, strong) NSArray *feedArray;
@property (atomic, strong) NSMutableDictionary *imagesDictionary;

@end


@implementation FacebookFeedViewController





- (NSString *)feedString
{
    return @"https://graph.facebook.com/me/home";
}

- (NSString *)titleString
{
    return @"Feed";
}

@end
