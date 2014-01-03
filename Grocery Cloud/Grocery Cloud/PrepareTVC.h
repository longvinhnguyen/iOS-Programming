//
//  PrepareTVC.h
//  Grocery Cloud
//
//  Created by Tim Roadley on 19/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTVC.h"
@interface PrepareTVC : CoreDataTVC <UIActionSheetDelegate>
@property (strong, nonatomic) UIActionSheet *clearConfirmActionSheet;
@end
