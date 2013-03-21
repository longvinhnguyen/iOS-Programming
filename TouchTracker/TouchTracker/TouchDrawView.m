//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Long Vinh Nguyen on 2/5/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"

@implementation TouchDrawView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lineInProcess = [[NSMutableDictionary alloc] init];
        
        completeLines = [[NSMutableArray alloc] init];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self setMultipleTouchEnabled:YES];
        
        UITapGestureRecognizer *tapRegconizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapRegconizer];
        
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        
        moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        [moveRecognizer setDelegate:self];
        [moveRecognizer setCancelsTouchesInView:NO];
        [self addGestureRecognizer:moveRecognizer];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // Draw complete lines in black
    [[UIColor redColor] set];
    for (Line *line in completeLines) {
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    
    // Draw lines in process in red
    [[UIColor blackColor] set];
    for (NSValue *v in lineInProcess) {
        Line *l = [lineInProcess objectForKey:v];
        CGContextMoveToPoint(context, [l begin].x, [l begin].y);
        CGContextAddLineToPoint(context, [l end].x, [l end].y);
        CGContextStrokePath(context);
    }
    
    // If there is a selected line, draw it
    if ([self selectedLine]) {
        [[UIColor greenColor] set];
        CGContextMoveToPoint(context, [self selectedLine].begin.x, [self selectedLine].begin.y);
        CGContextAddLineToPoint(context, [self selectedLine].end.x, [self selectedLine].end.y);
        CGContextStrokePath(context);
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    for (UITouch *t in touches) {
        // Is this double tap
        if ([t tapCount] > 1) {
            [self clearAll];
            return;
        }
        
        // Use the touch object (packed in an NSValue) as the key
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        // Create a line for the value
        CGPoint loc = [t locationInView:self];
        Line *newLine = [[Line alloc] init];
        [newLine setBegin:loc];
        [newLine setEnd:loc];
        
        // Put pair in dictionary
        [lineInProcess setObject:newLine forKey:key];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Update linesInProcess with moved touches
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        // Fine the linw for this touch
        Line *line = [lineInProcess objectForKey:key];
        
        // Update the line
        CGPoint loc = [t locationInView:self];
        [line setEnd:loc];
    }
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

-(void)endTouches:(NSSet *)touches
{
    // Remove ending touches from dictionary
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        Line *line = [lineInProcess objectForKey:key];
        
        // If this a double tap, 'line' will be nil
        if (line) {
            [completeLines addObject:line];
            [lineInProcess removeObjectForKey:key];
            [line setContainingArray:completeLines];
        }
        
        // Redraw
        [self setNeedsDisplay];
    }
}

- (void)clearAll
{
    [lineInProcess removeAllObjects];
    // [completeLines removeAllObjects];
    
    completeLines = [[NSMutableArray alloc] init];
    
    // Redrawn
    [self setNeedsDisplay];
}

- (void)tap:(UIGestureRecognizer *)gr
{
    NSLog(@"Recoginizer tap");
    
    CGPoint point = [gr locationInView:self];
    [self setSelectedLine:[self lineAtPoint:point]];
    
    // If we just tapped, remove all lines in process
    // so taht a tap doesn't result in a new line
    [lineInProcess removeAllObjects];
    
    if ([self selectedLine]) {
        [self becomeFirstResponder];
        // Grab the menu controller
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        // Create a new "Delete" UIMenuItem
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        [menu setMenuItems:[NSArray arrayWithObject:deleteItem]];
        
        // Tell the menu where it should come from and show it
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES];
        
    } else {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }

    

    
    
    [self setNeedsDisplay];
    
}

- (Line *)lineAtPoint:(CGPoint)p
{
    // Find a line close to p
    for (Line *l in completeLines) {
        CGPoint start = [l begin];
        CGPoint end = [l end];
        
        // Check a few points on the line
        for (float t = 0.0;  t<= 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            // If the tapped point is within 20 points, let's return this line
            if (hypot(x - p.x, y - p.y) < 20.0) {
                return l;
            }
        }
    }
    
    // If nothing is close enough to the tapped point, then we did't select a line
    return nil;
}

- (void)deleteLine: (id)sender
{
    // Remove the selected line from the list of compleLines
    [completeLines removeObject:[self selectedLine]];
    
    // Redraw everything
    [self setNeedsDisplay];
}

- (void) longPress:(UIGestureRecognizer *)gr
{
    if ([gr state] == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        [self setSelectedLine:[self lineAtPoint:point]];
        
        if ([self selectedLine]) {
            [lineInProcess removeAllObjects];
        }
    } else if ([gr state] == UIGestureRecognizerStateEnded) {
        [self setSelectedLine:nil];
    }
    [self setNeedsDisplay];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == moveRecognizer) {
        return YES;
    }
    return NO;
}

- (void)moveLine:(UIPanGestureRecognizer *)gr
{
    // If we haven't selected a line, we don't do anything here
    if (![self selectedLine]) {
        return;
    }
    
    // When the pan recognizer changes its position
    if ([gr state] == UIGestureRecognizerStateChanged) {
        // How far has the pan moved?
        CGPoint translation = [gr translationInView:self];
        
        // Add the translation to the current begin and end points of the line
        CGPoint begin = [self selectedLine].begin;
        CGPoint end = [self selectedLine].end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        
        // Set the new beginning and ends of the line
        [[self selectedLine] setBegin:begin];
        [[self selectedLine] setEnd:end];
        
        // Redrawn the screen
        [self setNeedsDisplay];
        
        [gr setTranslation:CGPointZero inView:self];
    }
}


- (int)numberOfLines
{
    int count = 0;
    
    // Check that they are non-nil before add their counts
    if (lineInProcess && completeLines) {
        count = [lineInProcess count] + [completeLines count];
    }
    
    return count;
}















@end
