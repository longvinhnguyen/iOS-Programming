//
//  HypnosisView.m
//  Hypnosister
//
//  Created by Long Vinh Nguyen on 1/24/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "HypnosisView.h"

@implementation HypnosisView
@synthesize circleColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // All HypnosisterView start with a clear background color
        [self setBackgroundColor:[UIColor clearColor]];
        [self setCircleColor:[UIColor lightGrayColor]];
        
        // Create a new layer object
        boxLayer = [[CALayer alloc] init];
        
        // Give it a size
        [boxLayer setBounds:CGRectMake(0.0, 0.0, 85.0, 85.0)];
        
        // Give it a location
        [boxLayer setPosition:CGPointMake(160.0, 100.0)];
        
        // Make half -transparent red the background color for the layer
        UIColor *reddish = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        
        // Get a CGColor object with the same color values
        CGColorRef cgReddish = [reddish CGColor];
        [boxLayer setBackgroundColor:cgReddish];
        
        // Make it a sublayer of the view's layer
        [[self layer] addSublayer:boxLayer];
        
        // Create a UIImage
        UIImage *layerImage = [UIImage imageNamed:@"Hypno.png"];
        
        // Get the underlying CGImage
        CGImageRef image = [layerImage CGImage];
        
        // Put the CGImage on the layer
        [boxLayer setContents:(__bridge id)image];
        
        // Insert the image a bit on each side
        [boxLayer setContentsRect:CGRectMake(-0.1, -0.1, 1.2, 1.2)];
        
        // Let the image resize (without changing the aspect ratio)
        // to fill the contentRect
        [boxLayer setContentsGravity:kCAGravityResizeAspect];
        
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bounds = [self bounds];
    
    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height/ 2.0;
    
    NSLog(@"%f %f",bounds.origin.x, bounds.origin.y);
    NSLog(@"%f %f",[self frame].origin.x,[self frame].origin.y);
    
    // The radius of the circle shoul be as nearly as big as the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    // The thickness of the line should be 10 points wide
    CGContextSetLineWidth(ctx, 10);
    
    // The color of the line should be gray (red, blue, green)

    [[self circleColor] setStroke];
    
    // Draw concentric circles from the outside in
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20)
    {
        // Add a path to the context
        CGContextAddArc(ctx, center.x, center.y, currentRadius, 0.0, M_PI * 2.0, YES);
        
        // Performing drawing instruction; remove path
        CGContextStrokePath(ctx);
    }
    
    // Create a string
    NSString *text = @"You are getting sleepy.";
    
    // Get a font to draw it in
    UIFont *font = [UIFont boldSystemFontOfSize:28];
    
    CGRect textRect;
    
    // How big is this string when draw in this font?
    textRect.size = [text sizeWithFont:font];
    
    // Let put that string in the center of the view
    textRect.origin.x = center.x - textRect.size.width / 2.0;
    textRect.origin.y = center.y - textRect.size.height / 2.0;
    
    // Set the fill color of the current context to black
    [[UIColor blackColor] setFill];
    
    // The shadow will move 4 points to the right and 3 points down from the text
    CGSize offset = CGSizeMake(4, 3);
    
    // The shadow will be dark gray in color
    CGColorRef color = [[UIColor darkGrayColor] CGColor];
    
    // Set the shadow of the context with these parameters,
    // all subsequent drawing will be shadowed
    
    CGContextSetShadowWithColor(ctx, offset, 2.0, color);
    
    // Draw the String
    [text drawInRect:textRect withFont:font];

}


- (BOOL)canBecomeFirstResponder
{
    return YES;
    
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{

    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"Device started shaking");
        [self setCircleColor:[UIColor redColor]];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    CABasicAnimation *ba = [CABasicAnimation animationWithKeyPath:@"position"];
    [ba setFromValue:[NSValue valueWithCGPoint:[boxLayer position]]];
    [ba setToValue:[NSValue valueWithCGPoint:p]];
    [ba setDuration:3.0];
    
    
    //[boxLayer setPosition:p];
    
    [boxLayer addAnimation:ba forKey:@"foo"];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *t = [touches anyObject];
//    CGPoint p = [t locationInView:self];
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    [boxLayer setPosition:p];
//    [CATransaction commit];
    
}

- (void)setCircleColor:(UIColor *)clr
{
    circleColor = clr;
    [self setNeedsDisplay];
}






@end
