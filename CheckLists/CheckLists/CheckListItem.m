//
//  CheckListItem.m
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/19/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CheckListItem.h"
#import "DataModel.h"

@implementation CheckListItem
@synthesize text, checked;

- (id)init
{
    if (self = [super init]) {
        self.itemID = [DataModel nextCheckListItemId];
    }
    return self;
}

- (void)toggleChecked
{
    self.checked = !checked;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemID forKey:@"ItemID"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.itemID = [aDecoder decodeIntegerForKey:@"ItemID"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
    }
    return self;
}


@end
