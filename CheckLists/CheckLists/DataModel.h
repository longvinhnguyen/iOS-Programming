//
//  DataModel.h
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/22/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableArray *lists;

+ (int)nextCheckListItemId;

- (void)saveCheckLists;
- (int)indexOfSelectedChecklist;
- (void)setIndexOfSelectedChecklist:(int)index;
- (void)sortChecklists;

@end
