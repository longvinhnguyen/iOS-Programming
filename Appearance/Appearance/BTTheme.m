//
//  BTTheme.m
//  Appearance
//
//  Created by Long Vinh Nguyen on 7/14/13.
//  Copyright (c) 2013 Adam Burkepile. All rights reserved.
//

#import "BTTheme.h"
#import "BTDefaultTheme.h"

@implementation BTThemeManager
static id<BTTheme> _theme = nil;

+ (id<BTTheme>)sharedTheme
{
    return _theme;
}

+ (void)setSharedTheme:(id<BTTheme>)inTheme
{
    _theme = inTheme;
    [self applyTheme];
}

+ (void)applyTheme
{
    id<BTTheme> theme = [self sharedTheme];
    
    UINavigationBar *NavBarAppearance = [UINavigationBar appearance];
    [NavBarAppearance setBackgroundImage:[theme imageForNavigationBar] forBarMetrics:UIBarMetricsDefault];
    [NavBarAppearance setBackgroundImage:[theme imageForNavigationBarLandscape] forBarMetrics:UIBarMetricsLandscapePhone];
    [NavBarAppearance setTitleTextAttributes:[theme navBarTextDictionary]];
    [NavBarAppearance setShadowImage:[theme imageForNavigationBarShadow]];
    
    UIBarButtonItem *barButton = [UIBarButtonItem appearance];
    [barButton setBackgroundImage:[theme imageForBarButtonNormal] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barButton setBackgroundImage:[theme imageForBarButtonHighlighted] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [barButton setBackgroundImage:[theme imageForBarButtonNormalLandscape] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    [barButton setBackgroundImage:[theme imageForBarButtonHighlightedLandscape] forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];

    [barButton setBackgroundImage:[theme imageForBarButtonDoneNormal] forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
    [barButton setBackgroundImage:[theme imageForBarButtonDoneHighlighted] forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
    [barButton setBackgroundImage:[theme imageForBarButtonDoneNormalLandscape] forState:UIControlStateHighlighted style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsLandscapePhone];
    [barButton setBackgroundImage:[theme imageForBarButtonDoneHighlightedLandscape] forState:UIControlStateHighlighted style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsLandscapePhone];
    
    [barButton setTitleTextAttributes:[theme barButtonTextDictionary] forState:UIControlStateNormal];
    [barButton setTitleTextAttributes:[theme barButtonTextDictionary] forState:UIControlStateHighlighted];
    
    // Page Control View Controller
    UIPageControl *pageAppearance = [UIPageControl appearance];
    [pageAppearance setCurrentPageIndicatorTintColor:[theme pageCurrentTintColor]];
    [pageAppearance setPageIndicatorTintColor:[theme pageTintColor]];
    
    // Stepper Control
    UIStepper *stepperApprance = [UIStepper appearance];
    [stepperApprance setBackgroundImage:[theme imageForStepperUnselected] forState:UIControlStateNormal];
    [stepperApprance setBackgroundImage:[theme imageForStepperSelected] forState:UIControlStateHighlighted];
    [stepperApprance setDividerImage:[theme imageForStepperDividerUnseleted] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal];
    [stepperApprance setDividerImage:[theme imageForStepperDividerSelected] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal];
    [stepperApprance setDividerImage:[theme imageForStepperDividerSelected] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected];
    [stepperApprance setDividerImage:[theme imageForStepperDividerSelected] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected];
    [stepperApprance setIncrementImage:[theme imageForStepperIncrement] forState:UIControlStateNormal];
    [stepperApprance setDecrementImage:[theme imageForStepperDecrement] forState:UIControlStateNormal];
    
    
    // Switch Control
    UISwitch *switchAppearance = [UISwitch appearance];
    [switchAppearance setTintColor:[theme switchOffTintColor]];
    [switchAppearance setOnTintColor:[theme switchOnTintColor]];
    [switchAppearance setOnImage:[theme imageForSwitchOn]];
    [switchAppearance setOffImage:[theme imageForSwitchOff]];
    
    // Progress Bar
    UIProgressView *progressAppearance = [UIProgressView appearance];
    [progressAppearance setProgressTintColor:[theme progressBarTintColor]];
    [progressAppearance setTrackTintColor:[theme progressBarTrackTintColor]];
    
    // Label Text
    UILabel *labelAppearance = [UILabel appearance];
    [labelAppearance setTextColor:[theme labelTextDictionary][UITextAttributeTextColor]];
    [labelAppearance setFont:[theme labelTextDictionary][UITextAttributeFont]];
    
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kThemeChange object:nil]] ;
    
}

+ (void)customizeView:(UIView *)view
{
    id<BTTheme> theme = [self sharedTheme];
    UIColor *backgroundColor = [theme backgroundColor];
    view.backgroundColor = backgroundColor;
}

+ (void)customizeNavigationBar:(UINavigationBar *)navigationBar
{
    id<BTTheme> theme = [self sharedTheme];
    [navigationBar setBackgroundImage:[theme imageForNavigationBar] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setBackgroundImage:[theme imageForNavigationBarLandscape] forBarMetrics:UIBarMetricsLandscapePhone];
    [navigationBar setTitleTextAttributes:[theme navBarTextDictionary]];
    [navigationBar setShadowImage:[theme imageForNavigationBarShadow]];
}

+ (void)customizeButton:(UIButton *)button
{
    id<BTTheme>theme = [self sharedTheme];
    [button setTitleColor:[theme buttonTextDictionary][UITextAttributeTextColor] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[theme buttonTextDictionary][UITextAttributeFont]];
    [button setBackgroundImage:[theme imageForButtonNormal]?[theme imageForButtonNormal]:nil forState:UIControlStateNormal];
    [button setBackgroundImage:[theme imageForbuttonHighlighted]?[theme imageForbuttonHighlighted]:nil forState:UIControlStateHighlighted];
}

+ (void)customizeTableViewCell:(UITableViewCell *)tableViewCell
{
    id<BTTheme>theme = [self sharedTheme];
    [tableViewCell.textLabel setTextColor:[theme tableViewCellTextDictionary][UITextAttributeTextColor]];
    [tableViewCell.textLabel setFont:[theme tableViewCellTextDictionary][UITextAttributeFont]];
}














@end
