//
//  ColorViewController.h
//  rtf1
//
//  Created by Marin Todorov on 07/08/2012.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorViewControllerDelegate <NSObject>

- (void)selectedColor:(UIColor *)color;

@end

@interface ColorViewController : UITableViewController

@property (nonatomic, weak) id<ColorViewControllerDelegate>delegate;

@end
