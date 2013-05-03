//
//  HUDView.m
//  Weather
//
//  Created by VisiKard MacBook Pro on 5/3/13.
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import "HUDView.h"

@implementation HUDView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (HUDView *)sharedHUD:(UIView *)view
{
    static HUDView* sharedView = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedView = [[self alloc] init];
    });
    sharedView.frame = view.bounds;
    UIColor *backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3];
    sharedView.backgroundColor = backgroundColor;
    
    [view addSubview:sharedView];
    [view bringSubviewToFront:sharedView];
    view.userInteractionEnabled = NO;
    
    return sharedView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
