//
//  ViewController.m
//  6.3-CATextLayer
//
//  Created by Long Vinh Nguyen on 10/6/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *labelView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = self.labelView.bounds;
    NSLog(@"bound: %f %f", self.labelView.frame.size.width, self.labelView.frame.size.height);
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.labelView.layer addSublayer:textLayer];
    
    // set text attributes
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, libero ut porttitor dictum, diam odio congue lacus, vel fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet lobortis";
    
    // create attributed string
    NSMutableAttributedString *string = nil;
    string = [[NSMutableAttributedString alloc] initWithString:text];
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    
    // set text attributes
    NSDictionary *attrs = @{(__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor, (__bridge id)kCTFontAttributeName:(__bridge id)fontRef};
    
    [string setAttributes:attrs range:NSMakeRange(0, [text length])];
    
    attrs = @{(__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor redColor].CGColor, (__bridge id)kCTFontAttributeName:(__bridge id)fontRef, (__bridge id)kCTUnderlineStyleAttributeName:@(kCTUnderlineStyleSingle)};
    [string setAttributes:attrs range:NSMakeRange(6, 5)];
    
    CFRelease(fontRef);
    
    textLayer.string = string;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
