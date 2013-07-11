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

#define convertDegreeToRadius(x) ({M_PI * x / 180.0f ;})

@interface BackOfKardMultiPhotoNavigationViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIView *jiggleView;

@property (nonatomic, strong) FPPopoverController *popover;

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
    // Do any additional setup after loading the view from its nib.
    [_pageControl setCurrentPage:0];
    [_pageControl setNumberOfPages:_photoUrls.count];
    
    CGFloat maxPhoto = 0;
    maxPhoto = 375;

    _scrollView.contentMode = UIViewContentModeScaleAspectFit;
    [self loadPhoto:0];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 2.0f;
    _jiggleView.layer.masksToBounds = YES;
    _jiggleView.layer.cornerRadius = 10;
    
    [_jiggleView addGestureRecognizer:longPress];
    
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTaps:)];
    doubleTap.numberOfTapsRequired = 2;
    [_jiggleView addGestureRecognizer:doubleTap];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [_jiggleView addGestureRecognizer:panGesture];
}

- (void)loadPhoto:(int)index
{
    UIImageView *mediaImage = [[UIImageView alloc] init];
    mediaImage.frame = CGRectMake(_scrollView.bounds.size.width * index, 0,_scrollView.bounds.size.width, _scrollView.bounds.size.height);
    mediaImage.contentMode = UIViewContentModeScaleAspectFit;
    [mediaImage setImageWithURL:[NSURL URLWithString:_photoUrls[index]]];
    [_scrollView addSubview:mediaImage];
    [_scrollView setContentSize:CGSizeMake(_scrollView.bounds.size.width * _photoUrls.count, mediaImage.bounds.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (pageControlUsed) {
        return;
    }
    
    CGFloat pageWidth = scrollView.bounds.size.width;
//    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    int page = round(scrollView.contentOffset.x / pageWidth);
    NSLog(@"Page: round of %f is %d", scrollView.contentOffset.x / pageWidth, page);

    if (page == previousPage || page < 0 || page >= _pageControl.numberOfPages)
        return;
    previousPage = page;
    _pageControl.currentPage = page;
    [self loadPhoto:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}
- (IBAction)pageControlValueChanged:(id)sender {
    int page = [sender currentPage];
    previousPage = page;
    CGRect frame = _scrollView.frame;
    frame.origin.x = _scrollView.bounds.size.width * page;
    frame.origin.y = 0;
    [self loadPhoto:page];
    [UIView animateWithDuration:0.5 animations:^{
        [_scrollView scrollRectToVisible:frame animated:YES];
    } completion:^(BOOL finished) {
        pageControlUsed = NO;
    }];
    
    
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
    
    CAKeyframeAnimation *expand = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation"];
//    NSValue *value1 = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeTranslation(20, 20)];
//    NSValue *value2 = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeTranslation(-20, -20)];
//    NSValue *value3 = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeTranslation(0, 0)];
    
    expand.values = @[@0, @20, @-20, @0];
    expand.duration = 5.0;
//    expand.keyTimes = @[@0.0, @0.2, @0.5, @0.3];
    CAMediaTimingFunction *timeFuction1 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAMediaTimingFunction *timeFuction2 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CAMediaTimingFunction *timeFuction3 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    CAMediaTimingFunction *timeFuction4 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    expand.timingFunctions = @[timeFuction1, timeFuction2, timeFuction3, timeFuction4];
    [sender.layer addAnimation:expand forKey:@"expandButton"];
    
    CAKeyframeAnimation *blur = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    blur.values = @[@1.0, @0.3, @0.8, @1.0];
        blur.duration = 5.0;
    expand.keyTimes = @[@0.0,@0.2,@0.5,@0.3];
    [sender.layer addAnimation:blur forKey:@"blurButton"];
    
    SelectPlayerViewController *playerController = [[SelectPlayerViewController alloc] init];
    [self presentViewController:playerController animated:YES completion:nil];
}


- (IBAction)popOverButtonTapped:(id)sender
{
//    UIButton *popOverButton = (UIButton *)sender;
    
    UIViewController *demoController = [[UIViewController alloc] init];
    demoController.view.backgroundColor = [UIColor clearColor];
    demoController.view.layer.cornerRadius = 10.0f;
    demoController.view.layer.masksToBounds = YES;
    
    _popover = [[FPPopoverController alloc] initWithViewController:demoController];

    _popover.contentSize = CGSizeMake(200, 450);
    [_popover presentPopoverFromView:sender]; 
    
    _popover.border =NO;
    _popover.tint = FPPopoverWhiteTint;
    
    

}
















@end
