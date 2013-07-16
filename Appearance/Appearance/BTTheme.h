//
//  BTTheme.h
//  Appearance
//
//  Created by Long Vinh Nguyen on 7/14/13.
//  Copyright (c) 2013 Adam Burkepile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@protocol BTTheme


- (UIColor *)backgroundColor;
- (UIColor *)pageTintColor;
- (UIColor *)pageCurrentTintColor;


- (UIImage *)imageForNavigationBar;
- (UIImage *)imageForNavigationBarLandscape;
- (UIImage *)imageForNavigationBarShadow;
- (UIImage *)imageForBarButtonNormal;
- (UIImage *)imageForBarButtonHighlighted;
- (UIImage *)imageForBarButtonNormalLandscape;
- (UIImage *)imageForBarButtonHighlightedLandscape;
- (UIImage *)imageForBarButtonDoneNormal;
- (UIImage *)imageForBarButtonDoneHighlighted;
- (UIImage *)imageForBarButtonDoneNormalLandscape;
- (UIImage *)imageForBarButtonDoneHighlightedLandscape;

- (NSDictionary *)navBarTextDictionary;
- (NSDictionary *)barButtonTextDictionary;

- (UIImage *)imageForStepperUnselected;
- (UIImage *)imageForStepperSelected;
- (UIImage *)imageForStepperDecrement;
- (UIImage *)imageForStepperIncrement;
- (UIImage *)imageForStepperDividerUnseleted;
- (UIImage *)imageForStepperDividerSelected;

- (UIColor *)switchOnTintColor;
- (UIColor *)switchOffTintColor;
- (UIImage *)imageForSwitchOn;
- (UIImage *)imageForSwitchOff;

- (UIColor *)progressBarTintColor;
- (UIColor *)progressBarTrackTintColor;

- (NSDictionary *)labelTextDictionary;

- (NSDictionary *)buttonTextDictionary;
- (UIImage *)imageForButtonNormal;
- (UIImage *)imageForbuttonHighlighted;

- (UIColor *)upperGradient;
- (UIColor *)lowerGradient;
- (UIColor *)seperatorColor;
- (Class)gradientLayer;
- (NSDictionary *)tableViewCellTextDictionary;


@end

@interface BTThemeManager : NSObject

+ (id<BTTheme>)sharedTheme;
+ (void)setSharedTheme:(id<BTTheme>)inTheme;
+ (void)applyTheme;
+ (void)customizeView:(UIView *)view;
+ (void)customizeNavigationBar:(UINavigationBar *)navigationBar;
+ (void)customizeButton:(UIButton *)button;
+ (void)customizeTableViewCell:(UITableViewCell *)tableViewCell;

@end

