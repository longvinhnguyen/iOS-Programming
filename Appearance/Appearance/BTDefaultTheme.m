//
//  BTDefaultTheme.m
//  Appearance
//
//  Created by Long Vinh Nguyen on 7/14/13.
//  Copyright (c) 2013 Adam Burkepile. All rights reserved.
//

#import "BTDefaultTheme.h"

@implementation BTDefaultTheme

- (UIColor *)backgroundColor
{
    return [UIColor whiteColor];
}

- (UIImage *)imageForNavigationBar
{
    return nil;
}

- (UIImage *)imageForNavigationBarLandscape
{
    return nil;
}

- (NSDictionary *)navBarTextDictionary
{
    return nil; 
}

- (UIImage *)imageForNavigationBarShadow
{
    return nil;
}

- (UIImage *)imageForBarButtonNormal
{
    return nil;
}

- (UIImage *)imageForBarButtonNormalLandscape
{
    return nil;
}

- (UIImage *)imageForBarButtonHighlighted
{
    return nil;
}

- (UIImage *)imageForBarButtonHighlightedLandscape
{
    return nil;
}

- (UIImage *)imageForBarButtonDoneNormal
{
    return nil;
}

- (UIImage *)imageForBarButtonDoneNormalLandscape
{
    return nil;
}

- (UIImage *)imageForBarButtonDoneHighlighted
{
    return nil;
}

- (UIImage *)imageForBarButtonDoneHighlightedLandscape
{
    return nil;
}

- (NSDictionary *)barButtonTextDictionary
{
    return @{UITextAttributeFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f], UITextAttributeTextColor:[UIColor whiteColor], UITextAttributeTextShadowColor:[UIColor blackColor], UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset: UIOffsetMake(0, -1)]};
}

- (UIColor *)pageTintColor
{
    return [UIColor lightGrayColor];
}

- (UIColor *)pageCurrentTintColor
{
    return [UIColor blackColor];
}

- (UIImage *)imageForStepperSelected
{
    return nil;
}

- (UIImage *)imageForStepperUnselected
{
    return nil;
}

- (UIImage *)imageForStepperIncrement
{
    return nil;
}

- (UIImage *)imageForStepperDecrement
{
    return nil;
}

- (UIImage *)imageForStepperDividerSelected
{
    return nil;
}

- (UIImage *)imageForStepperDividerUnseleted
{
    return nil;
}

- (UIColor *)switchOnTintColor
{
    return nil;
}

- (UIColor *)switchOffTintColor
{
    return nil;
}

- (UIImage *)imageForSwitchOn
{
    return nil;
}

- (UIImage *)imageForSwitchOff
{
    return nil;
}

- (UIColor *)progressBarTintColor
{
    return nil;
}

- (UIColor *)progressBarTrackTintColor
{
    return nil;
}

- (NSDictionary *)labelTextDictionary
{
    return nil;
}

- (NSDictionary *)buttonTextDictionary
{
    return nil;
}

- (UIImage *)imageForButtonNormal
{
    return nil;
}

- (UIImage *)imageForbuttonHighlighted
{
    return nil;
}

- (UIColor *)upperGradient
{
    return [UIColor whiteColor];
}

- (UIColor *)lowerGradient
{
    return [UIColor whiteColor];
}

- (UIColor *)seperatorColor
{
    return [UIColor blackColor];
}

- (Class)gradientLayer
{
    return [BTGradientLayer class];
}

- (NSDictionary *)tableViewCellTextDictionary
{
    return @{
             UITextAttributeFont:[UIFont boldSystemFontOfSize:20.0f]
    };
}



@end

@implementation BTGradientLayer

- (id)init
{
    if (self = [super init]) {
        UIColor *colorOne = [[BTThemeManager sharedTheme] upperGradient];
        UIColor *colorTwo = [[BTThemeManager sharedTheme] lowerGradient];
        UIColor *colorThree = [[BTThemeManager sharedTheme] seperatorColor];
        
        NSArray *colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor, (id)colorThree.CGColor];
        
        self.colors = colors;
        
        NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
        NSNumber *stopTwo = [NSNumber numberWithFloat:0.98];
        NSNumber *stopThree = [NSNumber numberWithFloat:1.0];
        
        NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, nil];
        self.locations = locations;
        
        self.startPoint = CGPointMake(0.5, 0.0);
        self.endPoint = CGPointMake(0.5, 1.0);
    }
    return self;
}

@end
