//
//  HypnosisterAppDelegate.h
//  Hypnosister
//
//  Created by Long Vinh Nguyen on 1/24/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HypnosisView.h"

@interface HypnosisterAppDelegate : UIResponder <UIApplicationDelegate, UIScrollViewDelegate>
{
    HypnosisView *view;
}
@property (strong, nonatomic) UIWindow *window;


@end
