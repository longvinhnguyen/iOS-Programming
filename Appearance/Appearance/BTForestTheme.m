//
//  BTForestTheme.m
//  Appearance
//
//  Created by Long Vinh Nguyen on 7/14/13.
//  Copyright (c) 2013 Adam Burkepile. All rights reserved.
//

#import "BTForestTheme.h"

@implementation BTForestTheme

- (UIColor *)backgroundColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_forest"]];
}

#pragma mark - NavigationBar customization
- (UIImage *)imageForNavigationBar
{
    return [[UIImage imageNamed:@"nav_forest_portrait"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 100.0, 0, 100.0)];
}

- (UIImage *)imageForNavigationBarLandscape
{
    return [[UIImage imageNamed:@"nav_forest_landscape"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 100.0, 0.0, 100.0)];
}

- (NSDictionary *)navBarTextDictionary
{
    return @{UITextAttributeFont:[UIFont fontWithName:@"Optima" size:24.0], UITextAttributeTextColor:[UIColor colorWithRed:0.910 green:0.914 blue:0.824 alpha:1.0], UITextAttributeTextShadowColor:[UIColor colorWithRed:0.224 green:0.173 blue:0.114 alpha:1.0], UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, -1)]};
}

- (UIImage *)imageForNavigationBarShadow
{
    return [UIImage imageNamed:@"topShadow_forest"];
}

#pragma mark - BarButton customization

- (UIImage *)imageForBarButtonNormal
{
    return [[UIImage imageNamed:@"barbutton_forest_uns"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    
}

- (UIImage *)imageForBarButtonHighlighted
{
    return [[UIImage imageNamed:@"barbutton_forest_sel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
}

- (UIImage *)imageForBarButtonDoneNormal
{
    return [[UIImage imageNamed:@"barbutton_forest_done_uns"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
}

- (UIImage *)imageForBarButtonDoneHighlighted
{
    return [[UIImage imageNamed:@"barbutton_forest_done_sel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
}


- (UIImage *)imageForBarButtonNormalLandscape
{
    return [[UIImage imageNamed:@"barbutton_forest_landscape_uns"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
}

- (UIImage *)imageForBarButtonHighlightedLandscape
{
    return [[UIImage imageNamed:@"barbutton_forest_landscape_sel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
}

- (UIImage *)imageForBarButtonDoneNormalLandscape
{
    return [[UIImage imageNamed:@"barbutton_forest_done_landscape_uns"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
}

- (UIImage *)imageForBarButtonDoneHighlightedLandscape
{
    return [[UIImage imageNamed:@"barbutton_forest_done_landscape_sel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
}

- (NSDictionary *)barButtonTextDictionary
{
    return @{UITextAttributeFont: [UIFont fontWithName:@"Optima" size:18.0],
      UITextAttributeTextColor: [UIColor colorWithRed:0.965 green:0.976 blue:0.875 alpha:1.0],
      UITextAttributeTextShadowColor: [UIColor colorWithRed:0.224 green:0.173 blue:0.114 alpha:1.0],
      UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]};
}

#pragma mark - PageControl customization

- (UIColor *)pageTintColor
{
    return [UIColor colorWithRed:0.973 green:0.984 blue:0.875 alpha:1.0];
}

- (UIColor *)pageCurrentTintColor
{
    return [UIColor colorWithRed:0.63 green:0.169 blue:0.071 alpha:1.0];
}


#pragma mark - Stepper customization
- (UIImage *)imageForStepperSelected
{
    return [UIImage imageNamed:@"stepper_forest_bg_sel"];
}

- (UIImage *)imageForStepperUnselected
{
    return [UIImage imageNamed:@"stepper_forest_bg_uns"];
}

- (UIImage *)imageForStepperDecrement
{
    return [UIImage imageNamed:@"stepper_forest_decrement"];
}

- (UIImage *)imageForStepperIncrement
{
    return [UIImage imageNamed:@"stepper_forest_increment"];
}

- (UIImage *)imageForStepperDividerUnseleted
{
    return [UIImage imageNamed:@"stepper_forest_divider_uns"];
}

- (UIImage *)imageForStepperDividerSelected
{
    return [UIImage imageNamed:@"stepper_forest_divider_sel"];
}

#pragma mark - SwitchControl customization
- (UIColor *)switchOnTintColor
{
    return [UIColor colorWithRed:0.192 green:0.298 blue:0.2 alpha:1.0];
}

- (UIColor *)switchOffTintColor
{
    return [UIColor colorWithRed:0.643 green:0.749 blue:0.651 alpha:1.0];
}

- (UIImage *)imageForSwitchOn
{
    return [UIImage imageNamed:@"tree_on"];
}

- (UIImage *)imageForSwitchOff
{
    return [UIImage imageNamed:@"tree_off"];
}

#pragma mark - ProgressBar customization
- (UIColor *)progressBarTintColor
{
    return [UIColor colorWithRed:0.2 green:0.345 blue:0.212 alpha:1.0];
}

- (UIColor *)progressBarTrackTintColor
{
    return [UIColor colorWithRed:0.541 green:0.647 blue:0.549 alpha:1.0];
}

#pragma mark - LabelText Dictionary
- (NSDictionary *)labelTextDictionary
{
    return @{
             UITextAttributeFont: [UIFont fontWithName:@"Optima" size:18.0f],
             UITextAttributeTextColor: [UIColor colorWithRed:0.965 green:0.976 blue:0.875 alpha:1.0f],
             UITextAttributeTextShadowColor: [UIColor colorWithRed:0.212 green:0.263 blue:0.208 alpha:1.0],
             UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]
             };
}

#pragma mark - UIButton customization
- (NSDictionary *)buttonTextDictionary
{
    return @{
             UITextAttributeFont:[UIFont fontWithName:@"Zapfino" size:15.0f],
             UITextAttributeTextColor:[UIColor colorWithRed:0.965 green:0.976 blue:0.875 alpha:1.0],
             UITextAttributeTextShadowColor:[UIColor colorWithRed:0.212 green:0.263 blue:0.208 alpha:1.0],
             UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 1)]
             };
}

- (UIImage *)imageForButtonNormal
{
    return [[UIImage imageNamed:@"button_forest_uns"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
}

- (UIImage *)imageForbuttonHighlighted
{
    return [[UIImage imageNamed:@"button_forest_sel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
}

#pragma mark - UITableViewCell customization
- (UIColor *)upperGradient
{
    return [UIColor colorWithRed:0.976 green:0.976 blue:0.937 alpha:1.0];
}

- (UIColor *)lowerGradient
{
    return [UIColor colorWithRed:0.969 green:0.976 blue:0.878 alpha:1.0];
}

- (UIColor *)seperatorColor
{
    return [UIColor colorWithRed:0.753 green:0.749 blue:0.698 alpha:1.0];
}

- (NSDictionary *)tableViewCellTextDictionary
{
    return @{
             UITextAttributeFont:[UIFont fontWithName:@"Optima" size:24.0],
             UITextAttributeTextColor:[UIColor colorWithRed:0.169 green:0.169 blue:0.153 alpha:1.0],
             UITextAttributeTextShadowColor:[UIColor colorWithWhite:1.0 alpha:1.0],
             UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 1)]
            };
}






@end
