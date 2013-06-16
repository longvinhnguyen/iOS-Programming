//
//  LeftMenuController.h
//  APISExplorer
//
//  Created by Long Vinh Nguyen on 6/9/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeftMenuController;

@protocol LeftMenuControllerDelegate <NSObject>

- (void)leftMenuControllerdidFinishSelectingAPI:(NSString *)api withType:(enum_api_request)type;

@end


@interface LeftMenuController : UIViewController

@property (nonatomic, weak) id<LeftMenuControllerDelegate>delegate;


@end
