//
//  DynamicSandwichViewController.m
//  SandwichFlow
//
//  Created by Long Vinh Nguyen on 4/8/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "DynamicSandwichViewController.h"
#import "SandwichViewController.h"
#import "AppDelegate.h"

@interface DynamicSandwichViewController ()

@end

@implementation DynamicSandwichViewController
{
    NSMutableArray *_views;
    UIGravityBehavior *_gravity;
    UIDynamicAnimator *_animator;
    CGPoint _previousTouchPoint;
    BOOL _draggingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background image
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background-LowerLayer"]];
    [self.view addSubview:backgroundImage];
    
    // Header Logo
    UIImageView *header = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sarnie.png"]];
    header.center = CGPointMake(220, 190);
    [self.view addSubview:header];
    
    _views = [NSMutableArray new];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] init];
    [_animator addBehavior:_gravity];
    _gravity.magnitude = 4.0;
    
    CGFloat offset = 250;
    for (NSDictionary *sandwich in [self sandwiches]) {
        [_views addObject:[self addRecipeAtOffset:offset forSandwich:sandwich]];
        offset -= 50;
        break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)sandwiches
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.sandwiches;
}

- (UIView *)addRecipeAtOffset:(CGFloat)offset forSandwich:(NSDictionary *)sandwich
{
    CGRect frameFromView = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height - offset);
    
    // create the view controller
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SandwichViewController *viewController = [myStoryBoard instantiateViewControllerWithIdentifier:@"SandwichVC"];
    
    // set the frame and provide some data
    UIView *view = viewController.view;
    view.frame = frameFromView;
    viewController.sandwich = sandwich;
    
    // add as a child
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    // add a gesture recognizer
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [viewController.view addGestureRecognizer:pan];
    
    // create a collision
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[view]];
    [_animator addBehavior:collision];
    
    // lower boundary, where the tab resets
    CGFloat boundary = view.frame.origin.y + view.frame.size.height + 1;
    CGPoint boundaryStart = CGPointMake(0.0, boundary);
    CGPoint boundaryEnd = CGPointMake(view.frame.size.width, boundary);
    [collision addBoundaryWithIdentifier:@1 fromPoint:boundaryStart toPoint:boundaryEnd];
    
    [_gravity addItem:view];
    
    return view;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self.view];
    UIView *draggedView = gesture.view;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint dragStartLocation = [gesture locationInView:draggedView];
        if (dragStartLocation.y < 200.0f) {
            _draggingView = YES;
            _previousTouchPoint = touchPoint;
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged && _draggingView) {
        // handle dragging
        CGFloat yOffset = _previousTouchPoint.y - touchPoint.y;
        gesture.view.center = CGPointMake(draggedView.center.x, draggedView.center.y - yOffset);
        _previousTouchPoint = touchPoint;
    } else if (gesture.state == UIGestureRecognizerStateEnded && _draggingView) {
        [_animator updateItemUsingCurrentState:draggedView];
        _draggingView = NO;
    }
}

@end
