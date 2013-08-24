//
//  SelectPlayerViewController.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 7/11/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "SelectPlayerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "Icon.h"
#import "TTSwitch.h"

typedef void(^completeBlock)();

@interface SelectPlayerViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView1;
@property (nonatomic, weak) IBOutlet UIImageView *imageView2;
@property (nonatomic, weak) IBOutlet UIImageView *imageView3;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation SelectPlayerViewController
{
    ALAssetsLibrary *library;
    NSMutableArray *myPhotos;
    UILongPressGestureRecognizer *tap;
    UIPanGestureRecognizer *pan;
    Icon *selectedCellView;
    UIImageView *plusIcon;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myPhotos = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum | ALAssetsGroupLibrary | ALAssetsGroupPhotoStream usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (index != NSNotFound) {
                NSLog(@"%@", result);
                UIImage *myImage = [UIImage imageWithCGImage:[result thumbnail]];
                if (myImage) {
                    [myPhotos addObject:myImage];
                    if (myPhotos.count == 20) {
                        *stop = YES;
                    }
                }
            }
        }];
        [_tableView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error %@", error.localizedDescription);
    }];
    
    tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnTableView:)];
    tap.minimumPressDuration = 0.5;
    tap.delegate = self;
    [_tableView addGestureRecognizer:tap];
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
    pan.delegate = self;
    [pan setCancelsTouchesInView:NO];
    [_tableView addGestureRecognizer:pan];
    
    
    _imageView1.layer.cornerRadius = 10;
    _imageView1.layer.masksToBounds = YES;
    
    _imageView2.layer.cornerRadius = 10;
    _imageView2.layer.masksToBounds = YES;
    
    _imageView3.layer.cornerRadius = 10;
    _imageView3.layer.masksToBounds = YES;
    
    [self setAttributeStringForTitle];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAttributeStringForTitle
{
    NSMutableAttributedString *mAtributedString = [[NSMutableAttributedString alloc] init];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    NSAttributedString *sender = [[NSAttributedString alloc] initWithString:@"Mike Alan" attributes:dict];
    NSAttributedString *content = [[NSAttributedString alloc] initWithString:@"like one of your photo" attributes:@{NSForegroundColorAttributeName: [UIColor greenColor]}];
    NSAttributedString *place = [[NSAttributedString alloc] initWithString:@"White Palace" attributes:dict];
    [mAtributedString appendAttributedString:sender];
    [mAtributedString appendAttributedString: content];
    [mAtributedString appendAttributedString:place];
    [mAtributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} range:NSMakeRange(0, mAtributedString.length)];
    
    _bottomTitle.attributedText = mAtributedString;
}


#pragma mark - UITableView datasource & delegate;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myPhotos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const CELL_ID = @"PLAYER_CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
        TTSwitch *squareThumbSwitch = [[TTSwitch alloc] initWithFrame:(CGRect){ CGPointZero, { 76.0f, 27.0f } }];
        squareThumbSwitch.trackImage = [UIImage imageNamed:@"square-switch-track"];
        squareThumbSwitch.overlayImage = [UIImage imageNamed:@"square-switch-overlay"];
        squareThumbSwitch.thumbImage = [UIImage imageNamed:@"square-switch-thumb"];
        squareThumbSwitch.thumbHighlightImage = [UIImage imageNamed:@"square-switch-thumb-highlight"];
        squareThumbSwitch.trackMaskImage = [UIImage imageNamed:@"square-switch-mask"];
        squareThumbSwitch.thumbMaskImage = nil; // Set this to nil to override the UIAppearance setting
        squareThumbSwitch.thumbOffsetY = -3.0f;
        squareThumbSwitch.thumbInsetX = -3.0f;
        [squareThumbSwitch addTarget:self action:@selector(toogleSwitchButton:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = squareThumbSwitch;
    }
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.image = myPhotos[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Photo %i", indexPath.row + 1];
    TTSwitch *switcher = (TTSwitch *)cell.accessoryView;
    switcher.tag = indexPath.row;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - SelectPlayerViewController actions
- (IBAction)exitButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)refreshButtonTapped:(id)sender
{
    [self refreshAllToDefault];
}

- (void)refreshAllToDefault
{
    _imageView1.image = [UIImage imageNamed:@"holder"];
    _imageView2.image = [UIImage imageNamed:@"holder"];
    _imageView3.image = [UIImage imageNamed:@"holder"];
}

#pragma mark - Gesture methods
- (void)tapOnTableView:(UILongPressGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint currentPointInTableView = [tapGesture locationInView:_tableView];
        CGPoint currentPointInMainView = [tapGesture locationInView:self.view];
        
        
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:currentPointInTableView];
        NSLog(@"IndexPath %d %d\n currentPointMV: %f %f", indexPath.section, indexPath.row, currentPointInMainView.x, currentPointInMainView.y);
        
        int row = indexPath.row;
        selectedCellView = [[Icon alloc] init];
        selectedCellView.indexPath = indexPath;
        selectedCellView.iconImageView.image = myPhotos[row];
        selectedCellView.frame = CGRectMake(0, 0, 50, 50);
        selectedCellView.center = currentPointInMainView;
        [self.view addSubview:selectedCellView];
        [self.view bringSubviewToFront:selectedCellView];

        
    } else if (tapGesture.state == UIGestureRecognizerStateEnded) {
        if ([self isInAnySlot]) {
            if (CGRectIntersectsRect(selectedCellView.frame, _imageView1.frame)) {
                [self animateToTheSlot:_imageView1.frame complete:^{
                    _imageView1.image = selectedCellView.image;
                }];
            } else if (CGRectIntersectsRect(selectedCellView.frame, _imageView2.frame)) {
                [self animateToTheSlot:_imageView2.frame complete:^{
                    _imageView2.image = selectedCellView.image;
                }];
            } else  if (CGRectIntersectsRect(selectedCellView.frame, _imageView3.frame)) {
                [self animateToTheSlot:_imageView3.frame complete:^{
                    _imageView3.image = selectedCellView.image;
                }];
            }
        } else {
            [selectedCellView removeFromSuperview];
            selectedCellView = nil;
        }

    }
}

- (BOOL)isInAnySlot
{
    return CGRectIntersectsRect(selectedCellView.frame, _imageView1.frame) || CGRectIntersectsRect(selectedCellView.frame, _imageView2.frame) || CGRectIntersectsRect(selectedCellView.frame, _imageView3.frame);
}

- (void)animateToTheSlot:(CGRect)frame complete:(completeBlock) block
{
    [UIView animateWithDuration:0.4 animations:^{
        selectedCellView.frame = frame;
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
        
        // Update table
        [_tableView beginUpdates];
        [_tableView reloadRowsAtIndexPaths:@[selectedCellView.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableView endUpdates];

        [selectedCellView removeFromSuperview];
        selectedCellView = nil;
    }];
}

- (void)panImage:(UIPanGestureRecognizer *)panGesture
{
    if (!selectedCellView) {
        return;
    }
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        _tableView.scrollEnabled = NO;
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:self.view];
        CGRect frame = selectedCellView.frame;
        frame.origin.x += translation.x;
        frame.origin.y += translation.y;
        
        selectedCellView.frame = frame;
        
        if ([self isInAnySlot]) {
            if (!selectedCellView.plusImageView.image) {
                selectedCellView.plusImageView.image = [UIImage imageNamed:@"plus_white"];
            }
        } else {
            selectedCellView.plusImageView.image = nil;
        }
        
        [panGesture setTranslation:CGPointZero inView:self.view];
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        _tableView.scrollEnabled = YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Action methods
- (void)toogleSwitchButton:(TTSwitch *)switcher
{
    NSLog(@"Button %d is %d", switcher.tag, switcher.isOn);
}


@end
