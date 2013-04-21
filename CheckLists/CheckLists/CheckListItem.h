//
//  CheckListItem.h
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/19/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckListItem : NSObject<NSCoding>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL checked;

- (void)toggleChecked;



@end
