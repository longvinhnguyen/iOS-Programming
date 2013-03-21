//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Long Vinh Nguyen on 2/5/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Line;

@interface TouchDrawView : UIView<UIGestureRecognizerDelegate>
{
    NSMutableDictionary *lineInProcess;
    NSMutableArray *completeLines;
    UIPanGestureRecognizer *moveRecognizer;
}

@property (nonatomic, weak) Line *selectedLine;

- (Line *)lineAtPoint:(CGPoint)p;

- (void)clearAll;
- (void)endTouches:(NSSet *)touches;

@end
