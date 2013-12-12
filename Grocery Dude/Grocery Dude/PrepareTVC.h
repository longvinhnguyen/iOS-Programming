//
//  PrepareTVC.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/12/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CoreDataTVC.h"

@interface PrepareTVC : CoreDataTVC<UIActionSheetDelegate>

@property (nonatomic, strong) UIActionSheet *clearConfirmActionSheet;

@end
