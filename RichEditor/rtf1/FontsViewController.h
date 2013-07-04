//
//  FontsViewController.h
//  rtf1
//
//  Created by Marin Todorov on 07/08/2012.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FontsViewControllerDelegate <NSObject>

- (void)selectedFontName:(NSString *)fontName withSize:(NSNumber *)fontSize;

@end

@interface FontsViewController : UIViewController

@property (nonatomic, weak) id<FontsViewControllerDelegate>delegate;
@property (nonatomic, strong) UIFont *preselectedFont;

@end
