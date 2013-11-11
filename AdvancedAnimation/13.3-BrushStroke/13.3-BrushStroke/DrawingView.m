//
//  DrawingView.m
//  13.3-BrushStroke
//
//  Created by VisiKard MacBook Pro on 11/11/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "DrawingView.h"

#define BRUSH_SIZE  32

@interface DrawingView()

@property (nonatomic,strong) NSMutableArray *strokes;


@end

@implementation DrawingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{
    self.strokes = [NSMutableArray new];
    self.backgroundColor = [UIColor darkGrayColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    [self addBrushStrokeAtPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    [self addBrushStrokeAtPoint:point];
}

- (void)addBrushStrokeAtPoint:(CGPoint)point
{
    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
    
    // needs redrawn
    [self setNeedsDisplayInRect:[self brushRectForPoint:point]];
}

- (CGRect)brushRectForPoint:(CGPoint)point
{
    return CGRectMake(point.x - BRUSH_SIZE/2, point.y - BRUSH_SIZE/2, BRUSH_SIZE, BRUSH_SIZE);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    for (NSValue *value in self.strokes) {
        CGPoint point = [value CGPointValue];
        
        // get brush rect
        CGRect brushRect = [self brushRectForPoint:point];
        if (CGRectIntersectsRect(rect, brushRect)) {
            [[UIImage imageNamed:@"Chalk.png"] drawInRect:brushRect];
        }
    }
}


@end
