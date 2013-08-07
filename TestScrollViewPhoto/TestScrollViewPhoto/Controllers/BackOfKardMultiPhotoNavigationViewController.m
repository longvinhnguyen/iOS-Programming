//
//  BackOfKardMultiPhotoNavigationViewController.m
//  VISIKARD
//
//  Created by VisiKard MacBook Pro on 5/31/13.
//
//

#import "BackOfKardMultiPhotoNavigationViewController.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import <FPPopoverController.h>
#import "SelectPlayerViewController.h"
#import "FeedViewController.h"
#import "PhotoViewController.h"

#define convertDegreeToRadius(x) ({M_PI * x / 180.0f ;})
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds].size.height - ( double )568 ) < DBL_EPSILON )

@interface BackOfKardMultiPhotoNavigationViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView *jiggleView;

@property (nonatomic, strong) FPPopoverController *popover;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation BackOfKardMultiPhotoNavigationViewController
{
    NSArray *_photoUrls;
    NSInteger _index;
    BOOL pageControlUsed;
    int previousPage;
    int _height;
    BOOL jiggling;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (id)initWithPhotoUrls:(NSArray *)photoUrls withIndex:(NSInteger)index andHeight:(int)height
{
    if (self = [self init]) {
        _photoUrls = photoUrls;
        _index = index;
        _height = height;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 2.0f;
    _jiggleView.layer.masksToBounds = YES;
    _jiggleView.layer.cornerRadius = 10;
    
    [_jiggleView addGestureRecognizer:longPress];
    
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTaps:)];
    doubleTap.numberOfTapsRequired = 2;
    [_jiggleView addGestureRecognizer:doubleTap];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [_jiggleView addGestureRecognizer:panGesture];
    
    NSDictionary *options =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                forKey: UIPageViewControllerOptionSpineLocationKey];
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    if (IS_IPHONE_5) {
        _pageViewController.view.frame = CGRectMake(0, 0, 320, 450);
    } else {
        _pageViewController.view.frame = CGRectMake(0, 0, 320, 450);
    }
    _pageViewController.view.backgroundColor = [UIColor blackColor];
    
    PhotoViewController *pvc = [[PhotoViewController alloc] init];
    pvc.photoURL = _photoUrls[0];
    
    [_pageViewController setViewControllers:@[pvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:_pageViewController];
    [[self view] addSubview:[_pageViewController view]];
    [_pageViewController didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"Photos"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    NSLog(@"LongPress handling");
    CABasicAnimation *jiggle = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    jiggle.fromValue = [NSNumber numberWithDouble:convertDegreeToRadius(1)];
    jiggle.toValue = [NSNumber numberWithDouble:convertDegreeToRadius(-1)];
    jiggle.duration = 0.2f;
    CAMediaTimingFunction *timing = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    jiggle.timingFunction = timing;
    jiggle.repeatCount = HUGE_VALF;
    [_jiggleView.layer addAnimation:jiggle forKey:@"jiggle"];
    jiggling = YES;

}

- (void)handleDoubleTaps:(UITapGestureRecognizer *)tapGesture
{
    if (jiggling) {
        [_jiggleView.layer removeAllAnimations];
        jiggling = NO;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        if (jiggling) {
            CGPoint translation = [panGesture translationInView:_jiggleView];
            NSLog(@"Translation x: %f y:%f", translation.x, translation.y);
            CGRect frame;
            frame = _jiggleView.frame;
            frame.origin.x += translation.x;
            frame.origin.y += translation.y;
            _jiggleView.frame = frame;
            [panGesture setTranslation:CGPointZero inView:self.view];
        }
    }

}

- (IBAction)animateButtonTapped:(UIButton *)sender
{
//    CABasicAnimation *expand = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
//    expand.fromValue = @0;
//    expand.toValue = @1;
//    expand.duration = 0.6;
//    [sender.layer addAnimation:expand forKey:@"expandButton"];
    
//    CAKeyframeAnimation *expand = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation"];
//    NSValue *value1 = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeTranslation(20, 20)];
//    NSValue *value2 = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeTranslation(-20, -20)];
//    NSValue *value3 = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeTranslation(0, 0)];
    
//    expand.values = @[@0, @20, @-20, @0];
//    expand.duration = 5.0;
//    expand.keyTimes = @[@0.0, @0.2, @0.5, @0.3];
//    CAMediaTimingFunction *timeFuction1 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    CAMediaTimingFunction *timeFuction2 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    CAMediaTimingFunction *timeFuction3 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    CAMediaTimingFunction *timeFuction4 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    expand.timingFunctions = @[timeFuction1, timeFuction2, timeFuction3, timeFuction4];
//    [sender.layer addAnimation:expand forKey:@"expandButton"];
//    
//    CAKeyframeAnimation *blur = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//    blur.values = @[@1.0, @0.3, @0.8, @1.0];
//        blur.duration = 5.0;
//    expand.keyTimes = @[@0.0,@0.2,@0.5,@0.3];
//    [sender.layer addAnimation:blur forKey:@"blurButton"];
//    
    SelectPlayerViewController *playerController = [[SelectPlayerViewController alloc] init];
    [self presentViewController:playerController animated:YES completion:nil];
}

- (IBAction)tableButtonTapped:(id)sender
{
    FeedViewController *fvc = [[FeedViewController alloc] init];
    NSLog(@"%@", self.parentViewController);
    
    [[self navigationController] pushViewController:fvc animated:YES];
}

#pragma mark - UIPageViewController delegate & datasource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    int index = [_photoUrls indexOfObject:((PhotoViewController *)viewController).photoURL];
    if (index == 0) {
        index = _photoUrls.count - 1;
    } else {
        index --;
    }
    PhotoViewController *pvc = [[PhotoViewController alloc] init];
    pvc.photoURL = _photoUrls[index];
    
    return pvc;

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{

    int index = [_photoUrls indexOfObject:((PhotoViewController *)viewController).photoURL];
    if (index == _photoUrls.count - 1) {
        index= 0;
    } else {
        index ++;
    }
    PhotoViewController *pvc = [[PhotoViewController alloc] init];
    pvc.photoURL = _photoUrls[index];
    
    return pvc;

}
















@end
