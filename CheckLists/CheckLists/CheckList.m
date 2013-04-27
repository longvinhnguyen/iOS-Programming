//
//  CheckList.m
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/21/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CheckList.h"
#import "CheckListItem.h"

@implementation CheckList
@synthesize items;

- (id)init
{
    self = [super init];
    if (self) {
        items = [[NSMutableArray alloc] initWithCapacity:20];
        self.iconName = @"No Icon";
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
        self.iconName = [aDecoder decodeObjectForKey:@"IconName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name  forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.iconName forKey:@"IconName"];
}

- (int)countUncheckedItems
{
    int count = 0;
    for (CheckListItem *item in self.items) {
        if (!item.checked) {
            count ++;
        }
    }
    return count;
}

- (NSComparisonResult)compare:(CheckList *)otherChecklist
{
    return [self.name localizedStandardCompare:otherChecklist.name];
}

- (void)sortChecklistItemByDueDate
{
    VLog(@"Sorted checklist");
    [items sortedArrayUsingSelector:@selector(compare:)];
}

@end
