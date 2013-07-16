//
//  BTPrettyPinkTheme.m
//  Appearance
//
//  Created by Long Vinh Nguyen on 7/16/13.
//  Copyright (c) 2013 Adam Burkepile. All rights reserved.
//

#import "BTPrettyPinkTheme.h"

@implementation BTPrettyPinkTheme
- (UIColor *)backgroundColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_prettyinpink"]];
}

- (UIColor *)upperGradient
{
    return [UIColor colorWithRed:0.961 green:0.878 blue:0.961 alpha:1.0];
}

- (UIColor *)lowerGradient
{
    return [UIColor colorWithRed:0.906 green:0.827 blue:0.906 alpha:1.0];
}

- (UIColor *)seperatorColor
{
    return [UIColor colorWithRed:0.871 green:0.741 blue:0.878 alpha:1.0];
}

- (UIColor *)progressBarTintColor
{
    return [UIColor colorWithRed:0.6 green:0.416 blue:0.612 alpha:1.0];
}

- (UIColor *)progressBarTrackTintColor
{
    return [UIColor colorWithRed:0.749 green:0.561 blue:757 alpha:1.0];
}

- (UIColor *)switchOnTintColor
{
    return [UIColor colorWithRed:0.749 green:0.561 blue:0.757 alpha:1.0];
}

- (UIColor *)switchOffTintColor
{
    return [UIColor colorWithRed:0.918 green:0.839 blue:0.922 alpha:1.0];
}

- (UIColor *)pageTintColor
{
    return [UIColor colorWithRed:0.29 green:0.051 blue:0.302 alpha:1.0];
}

- (UIColor *)pageCurrentTintColor
{
    return [UIColor colorWithRed:0.749 green:0.561 blue:0.757 alpha:1.0];
}

- (UIImage *)imageForBarButtonNormal
{
    return [[UIImage imageNamed:@"bar_button_pretty_uns"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 9, 0, 9)];
}

- (UIImage *)imageForBarButtonHighlighted
{
    return [[UIImage imageNamed:@"bar_button_pretty_sel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 9, 0, 9)];
}

- (UIImage *)imageForBarButtonDoneNormal
{
    return [[UIImage imageNamed:@"barbutton_pretty_done_uns.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 9, 0, 9)];
}

- (UIImage *)imageForBarButtonDoneHighlighted
{
    return [[UIImage imageNamed:@"barbutton_pretty_done_sel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 9, 0, 9)];
}

- (UIImage *)imageForBarButtonNormalLandscape
{
    return [[UIImage imageNamed:@"barbutton_pretty_landscape_uns"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
}

- (UIImage *)imageForBarButtonHighlightedLandscape
{
    return [[UIImage imageNamed:@"barbutton_pretty_landscape_sel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
}

- (UIImage *)imageForBarButtonDoneNormalLandscape
{
    return [[UIImage imageNamed:@"barbutton_pretty_done_landscape_uns"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
}

- (UIImage *)imageForBarButtonDoneHighlightedLandscape
{
    return [[UIImage imageNamed:@"barbutton_pretty_done_landscape_sel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
}

- (UIImage *)imageForButtonNormal
{
    return [[UIImage imageNamed:@"button_pretty_uns"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)];
}

- (UIImage *)imageForbuttonHighlighted
{
    return [[UIImage imageNamed:@"button_pretty_sel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)];
}

- (UIImage *)imageForNavigationBar
{
    return [[UIImage imageNamed:@"nav_pretty_portrait"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
}

- (UIImage *)imageForNavigationBarLandscape
{
    return [[UIImage imageNamed:@"nav_pretty_landscape"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
}

- (UIImage *)imageForNavigationBarShadow
{
    return [UIImage imageNamed:@"topShadow_pretty"];
}

- (UIImage *)imageForSwitchOn
{
    return [UIImage imageNamed:@"floweron"];
}


- (UIImage *)imageForSwitchOff
{
    return [UIImage imageNamed:@"floweroff"];
}

- (UIImage *)imageForStepperUnselected
{
    return [UIImage imageNamed:@"stepper_pretty_bg_uns"];
}

- (UIImage *)imageForStepperSelected
{
    return [UIImage imageNamed:@"stepper_pretty_bg_sel"];
}

- (UIImage *)imageForStepperDecrement
{
    return [UIImage imageNamed:@"stepper_pretty_decrement"];
}

- (UIImage *)imageForStepperIncrement
{
    return [UIImage imageNamed:@"stepper_pretty_increment"];
}

- (UIImage *)imageForStepperDividerUnseleted
{
    return [UIImage imageNamed:@"stepper_pretty_divider_uns"];
}

- (UIImage *)imageForStepperDividerSelected
{
    return [UIImage imageNamed:@"stepper_pretty_divider_sel"];
}

- (NSDictionary *)navBarTextDictionary
{
    return @{
             UITextAttributeTextColor: [UIColor colorWithRed:0.290 green:0.051 blue:0.302 alpha:1.0],
             UITextAttributeTextShadowColor: [UIColor colorWithRed:0.965 green:0.945 blue:0.965 alpha:1.0],
             UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]
             };
}

- (NSDictionary *)barButtonTextDictionary
{
    return @{
             UITextAttributeTextColor: [UIColor colorWithRed:0.506 green:0.314 blue:0.510 alpha:1.0],
             UITextAttributeFont: [UIFont fontWithName:@"Arial Rounded MT Bold" size:15.0],
             UITextAttributeTextShadowColor: [UIColor colorWithRed:0.965 green:0.945 blue:0.965 alpha:1.0],
             UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]
             };
}


- (NSDictionary *)buttonTextDictionary
{
    return @{
             UITextAttributeFont: [UIFont fontWithName:@"Arial Rounded MT Bold" size:18.0],
             UITextAttributeTextColor: [UIColor colorWithRed:0.29 green:0.061 blue:0.302 alpha:1.0],
             UITextAttributeTextShadowColor: [UIColor colorWithRed:0.965 green:0.945 blue:0.965 alpha:1.0],
             UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]
             };
}

- (NSDictionary *)labelTextDictionary
{
    return @{
             UITextAttributeFont: [UIFont fontWithName:@"Arial Rounded MT Bold" size:18.0],
             UITextAttributeTextColor: [UIColor colorWithRed:0.29 green:0.061 blue:0.302 alpha:1.0],
             UITextAttributeTextShadowColor: [UIColor colorWithRed:0.965 green:0.945 blue:0.965 alpha:1.0],
             UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]
             };
}

- (NSDictionary *)tableViewCellTextDictionary
{
    return @{
             UITextAttributeFont: [UIFont fontWithName:@"Arial Rounded MT Bold" size:18.0],
             UITextAttributeTextColor: [UIColor colorWithRed:0.29 green:0.061 blue:0.302 alpha:1.0],
             UITextAttributeTextShadowColor: [UIColor colorWithRed:0.965 green:0.945 blue:0.965 alpha:1.0],
             UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]
             };
}

























@end
