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
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name  forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
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

@end
