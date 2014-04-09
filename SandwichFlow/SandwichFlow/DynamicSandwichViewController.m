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

@interface DynamicSandwichViewController ()<UICollisionBehaviorDelegate>

@end

@implementation DynamicSandwichViewController
{
    NSMutableArray *_views;
    UIGravityBehavior *_gravity;
    UIDynamicAnimator *_animator;
    CGPoint _previousTouchPoint;
    BOOL _draggingView;
    BOOL _viewDocked;
    UISnapBehavior *_snap;
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
    
    
    // add the background lower layer
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background-LowerLayer.png"]];
    backgroundImageView.frame = CGRectInset(self.view.frame, -50.0f, -50.0f);
    [self.view addSubview:backgroundImageView];
    [self addMotionEffectToView:backgroundImageView magnitude:50.0f];
    
    // add the background mid layer
    UIImageView *midLayerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background-MidLayer.png"]];
    [self.view addSubview:midLayerImageView];
    
    // add foreground image
    UIImageView *header = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sarnie.png"]];
    header.center = CGPointMake(220, 190);
    [self.view addSubview:header];
    [self addMotionEffectToView:header magnitude:20.0f];
    
    _views = [NSMutableArray new];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] init];
    [_animator addBehavior:_gravity];
    _gravity.magnitude = 4.0;
    
    CGFloat offset = 250;
    for (NSDictionary *sandwich in [self sandwiches]) {
        [_views addObject:[self addRecipeAtOffset:offset forSandwich:sandwich]];
        offset -= 50;
    }
    
    [_views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        // create motion effect
        UIInterpolatingMotionEffect *xMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        int motionValue = 20 - idx * 2;
        xMotion.minimumRelativeValue = @(-motionValue);
        xMotion.maximumRelativeValue = @(motionValue);
        [view addMotionEffect:xMotion];
    }];
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
    
    // higher boundary
    boundaryStart = CGPointMake(0.0, 0.0);
    boundaryEnd = CGPointMake(view.frame.size.width, 0.0);
    [collision addBoundaryWithIdentifier:@2 fromPoint:boundaryStart toPoint:boundaryEnd];
    collision.collisionDelegate = self;
    
    [_gravity addItem:view];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
    itemBehavior.allowsRotation = NO;
    [_animator addBehavior:itemBehavior];
    
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
        [self tryDockView:draggedView];
        [self addVelocityToView:draggedView fromGesture:gesture];
        [_animator updateItemUsingCurrentState:draggedView];
        _draggingView = NO;
    }
}

- (UIDynamicItemBehavior *)itemBehaviorForView:(UIView *)view
{
    for (UIDynamicItemBehavior *behavior in _animator.behaviors) {
        if (behavior.class == [UIDynamicItemBehavior class] && behavior.items.firstObject == view) {
            return behavior;
        }
    }
    
    return nil;
}

- (void)addVelocityToView:(UIView *)view fromGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint vel = [gesture velocityInView:self.view];
    vel.x = 0;
    UIDynamicItemBehavior *behavior = [self itemBehaviorForView:view];
    [behavior addLinearVelocity:vel forItem:view];
}

- (void)tryDockView:(UIView *)view
{
    BOOL viewHasReachedDockLocation = view.frame.origin.y < 100.0;
    if (viewHasReachedDockLocation) {
        if (!_viewDocked) {
            _snap = [[UISnapBehavior alloc] initWithItem:view snapToPoint:self.view.center];
            [_animator addBehavior:_snap];
            [self setAlphaWhenViewDocked:view alpha:0.0];
            _viewDocked = YES;
        }
    } else {
        if (_viewDocked) {
            [_animator removeBehavior:_snap];
            [self setAlphaWhenViewDocked:view alpha:1.0];
            _viewDocked = NO;
        }
    }
}

- (void)setAlphaWhenViewDocked:(UIView *)view alpha:(CGFloat)alpha
{
    for (UIView *aView in _views) {
        if (view != aView) {
            aView.alpha = alpha;
        }
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    UIView *view = (UIView *)item;
    if ([@2 isEqual:identifier]) {
        [self tryDockView:view];
    } else if ([@1 isEqual:identifier]) {
        UIDynamicItemBehavior *itemBehavior = [self itemBehaviorForView:view];
        CGPoint velocity = [itemBehavior linearVelocityForItem:item];
        for (UIView *otherView in _views) {
            if (otherView != view) {
                UIDynamicItemBehavior *otherItemBehavior = [self itemBehaviorForView:otherView];
                CGFloat bounce = arc4random() % 50 + velocity.y * 0.5;
                [otherItemBehavior addLinearVelocity:CGPointMake(0, bounce) forItem:otherView];
            }
        }
    }
}

- (void)addMotionEffectToView:(UIView *)view magnitude:(CGFloat)magnitude
{
    UIInterpolatingMotionEffect *xMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xMotion.minimumRelativeValue = @(-magnitude);
    xMotion.maximumRelativeValue = @(magnitude);
    
    UIInterpolatingMotionEffect *yMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yMotion.minimumRelativeValue = @(-magnitude);
    yMotion.maximumRelativeValue = @(magnitude);
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xMotion, yMotion];
    [view addMotionEffect:group];
}


@end
