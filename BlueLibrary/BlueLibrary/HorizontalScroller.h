//
//  HorizontalScroller.h
//  BlueLibrary
//
//  Created by Long Vinh Nguyen on 9/8/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HorizontalScrollerDelegate;

@interface HorizontalScroller : UIView

@property (nonatomic, weak) id<HorizontalScrollerDelegate> delegate;

- (void)reload;

@end

@protocol HorizontalScrollerDelegate <NSObject>

@required

- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller *)scroller;
- (UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index;
- (void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index;

@optional
- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller *)scroller;

@end