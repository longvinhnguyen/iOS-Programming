//
//  StackedGridLayoutSection.m
//  FlickSearch
//
//  Created by Long Vinh Nguyen on 4/11/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "StackedGridLayoutSection.h"

@implementation StackedGridLayoutSection
{
    CGRect _frame;
    UIEdgeInsets _itemInsets;
    CGFloat columnWidth;
    NSMutableArray *columnHeights;
    NSMutableDictionary *_indexToFrameMap;
}


- (id)initWithOrigin:(CGPoint)origin width:(CGFloat)width columns:(NSInteger)columns itemInsets:(UIEdgeInsets)itemInsets
{
    self  = [super init];
    if (self) {
        _frame = CGRectMake(origin.x, origin.y, width, 0.0f);
        _itemInsets = itemInsets;
        columnWidth = floorf(width/columns);
        columnHeights = [NSMutableArray new];
        _indexToFrameMap = [NSMutableDictionary new];
        for (int i = 0; i < columns; i++) {
            [columnHeights addObject:@(0.0f)];
        }
    }
    return self;
}

- (CGRect)frame
{
    return _frame;
}

- (CGFloat)columnWidth
{
    return columnWidth;
}

- (NSInteger)numberOfItems
{
    return _indexToFrameMap.count;
}

- (void)addItemOfSize:(CGSize)size forIndex:(NSInteger)index
{
    // 1
    __block CGFloat shortestColumnHeight = CGFLOAT_MAX;
    __block NSUInteger shortestColumnIndex = 0;
    
    // 2
    [columnHeights enumerateObjectsUsingBlock:^(NSNumber *height, NSUInteger idx, BOOL *stop){
        CGFloat thisColoumHeight = [height floatValue];
        if (thisColoumHeight < shortestColumnHeight) {
            shortestColumnHeight = thisColoumHeight;
            shortestColumnIndex = idx;
        }
    }];
    
    // 3
    CGRect frame;
    frame.origin.x = _frame.origin.x + (columnWidth * shortestColumnIndex) + _itemInsets.left;
    frame.origin.y = _frame.origin.y + shortestColumnHeight + _itemInsets.top;
    frame.size = size;
    
    // 4
    _indexToFrameMap[@(index)] = [NSValue valueWithCGRect:frame];
    
    
    // 5
    if (CGRectGetMaxY(frame) > CGRectGetMaxY(_frame)) {
        _frame.size.height = (CGRectGetMaxY(frame) - frame.origin.y)  + _itemInsets.bottom;
    }
    
    // 6
    [columnHeights replaceObjectAtIndex:shortestColumnIndex withObject:@(shortestColumnHeight + size.height + _itemInsets.bottom)];
    
    
    
    
}

- (CGRect)frameForItemAtIndex:(NSInteger)index
{
    return [_indexToFrameMap[@(index)] CGRectValue];
}











@end
