//
//  FunActivity.m
//  FunFacts
//
//  Created by Long Vinh Nguyen on 6/26/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "FunActivity.h"
#import <QuartzCore/QuartzCore.h>

@implementation FunActivity

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"activity"];
}

- (NSString *)activityTitle
{
    return @"Save Quote To Photos";
}

- (NSString *)activityType
{
   return @"li.iFe.FunFacts.quoteView";
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (int i = 0; i<activityItems.count; i++) {
        id item = activityItems[i];
        if ([item class] == [UIImage class] || [item isKindOfClass:[NSString class]]) {
            //
        } else {
            return NO;
        }
    }
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (int i = 0; i < activityItems.count; i++) {
        id item = activityItems[i];
        
        if ([item class] == [UIImage class]) {
            self.authorImage = item;
        } else if ([item isKindOfClass:[NSString class]]) {
            self.funFactText = item;
        }
    }
}

- (void)performActivity
{
    CGSize quoteSize = CGSizeMake(640, 960);
    UIGraphicsBeginImageContext(quoteSize);
    
    UIView *quoteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, quoteSize.width, quoteSize.height)];
    quoteView.backgroundColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.authorImage];
    imageView.frame = CGRectMake(20, 20, 600, 320);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor clearColor];
    
    [quoteView addSubview:imageView];
    
    UILabel *factLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, 600, 600)];
    factLabel.backgroundColor = [UIColor clearColor];
    factLabel.numberOfLines = 10;
    factLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:44];
    factLabel.textColor = [UIColor whiteColor];
    factLabel.text = self.funFactText;
    factLabel.textAlignment = NSTextAlignmentCenter;
    
    [quoteView addSubview:factLabel];
    
    [quoteView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageToSave = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil);
    [self activityDidFinish:YES];
    
    
}









@end
