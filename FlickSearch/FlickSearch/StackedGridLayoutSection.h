//
//  StackedGridLayoutSection.h
//  FlickSearch
//
//  Created by Long Vinh Nguyen on 4/11/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StackedGridLayoutSection : NSObject

@property (nonatomic, assign, readonly) CGRect frame;
@property (nonatomic, assign, readonly) UIEdgeInsets itemInsets;
@property (nonatomic, assign, readonly) CGFloat columnWidth;
@property (nonatomic, assign, readonly) NSInteger numberOfItems;

- (id)initWithOrigin:(CGPoint)origin width:(CGFloat)width columns:(NSInteger)columns itemInsets:(UIEdgeInsets)itemInsets;
- (void)addItemOfSize:(CGSize)size forIndex:(NSInteger)index;
- (CGRect)frameForItemAtIndex:(NSInteger)index;

@end
