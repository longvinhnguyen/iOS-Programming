//
//  FeedViewController.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 7/29/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedCell.h"
#import "FeedPhotoCell.h"
#import "SetNewLocationController.h"
#import "SelectPlayerViewController.h"
#import "PostMessageController.h"

@interface FeedViewController ()
@property (nonatomic, strong) UIView *refreshView;
@property (nonatomic, strong) UIActivityIndicatorView *av;
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation FeedViewController

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
    NSDictionary *data1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Check in Pizza Hut", @"message", @"1000", @"likes", @"2000", @"comments", nil];
    NSDictionary *data2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Mike posted a picture on your wall. Following him? Darling don't be afraid I've loved you for a thounsands year", @"message", @"2000", @"likes", @"10000", @"comments", nil];
    NSDictionary *data3 = [NSDictionary dictionaryWithObjectsAndKeys:@"All along I believe", @"message", @"10", @"likes", @"5", @"comments", nil];    
    NSDictionary *data4 = [NSDictionary dictionaryWithObjectsAndKeys:@"All along I believe I would find you. Time has brought heart to me.", @"message", @"100", @"likes", @"50", @"comments", nil];
    NSDictionary *data5 = [NSDictionary dictionaryWithObjectsAndKeys:@"All along I believe I would find you. Time has brought heart to me. I've love you for a thoundsand years", @"message", @"0", @"likes", @"0", @"comments", nil];
    NSDictionary *data6 = [NSDictionary dictionaryWithObjectsAndKeys:@"All along I believe I would find you. Time has brought heart to me.", @"message", @"1", @"likes", @"0", @"comments", nil];
    NSDictionary *data7 = [NSDictionary dictionaryWithObjectsAndKeys:@"All along I believe I would find you. Time has brought heart to me.", @"message", @"1", @"likes", @"0", @"comments", @"exit.png", @"image", nil];
    NSDictionary *data8 = [NSDictionary dictionaryWithObjectsAndKeys:@"All along I believe I would find you.", @"message", @"1", @"likes", @"10", @"comments", @"plus.png", @"image", nil];
    NSDictionary *data9 = [NSDictionary dictionaryWithObjectsAndKeys:@"Mike posted a picture on your wall. Following him? Darling don't be afraid I've loved you for a thounsands year", @"message", @"2000", @"likes", @"10000", @"comments", nil];
    NSDictionary *data10 = [NSDictionary dictionaryWithObjectsAndKeys:@"Mike posted a picture on your wall. Following him? Darling don't be afraid I've loved you for a thounsands year", @"message", @"200", @"likes", @"1000", @"comments", nil];
    NSDictionary *data11 = [NSDictionary dictionaryWithObjectsAndKeys:@"Mike posted a picture on your wall. Following him? Darling don't be afraid I've loved you for a thounsands year", @"message", @"2000", @"likes", @"10000", @"comments", nil];
    NSDictionary *data12 = [NSDictionary dictionaryWithObjectsAndKeys:@"All along I believe I would find you. Time has brought heart to me.", @"message", @"1000", @"likes", @"9000", @"comments", @"refresh.png", @"image", nil];
    
    UINib *feedCellNib = [UINib nibWithNibName:@"FeedCell" bundle:nil];
    [_mainTable registerNib:feedCellNib forCellReuseIdentifier:@"FeedCell"];
    
    UINib *feedPhotoCellNib = [UINib nibWithNibName:@"FeedPhotoCell" bundle:nil];
    [_mainTable registerNib:feedPhotoCellNib forCellReuseIdentifier:@"FeedPhotoCell"];
    
    _dataList = [NSArray arrayWithObjects:data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationItem setTitle:@"Feeds"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)refreshView
{
    if (!_refreshView) {
        _refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        _av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _av.center = CGPointMake(CGRectGetMidX(_refreshView.frame), CGRectGetMidY(_refreshView.frame));
        [_refreshView addSubview:_av];
    }
    return _refreshView;
}

#pragma mark - UITableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCell *cell;
    
    
    NSDictionary *info = _dataList[indexPath.row];
    
    
    if (!info[@"image"]) {
        FeedCell *feedCell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
        feedCell.eventMessage.text = info[@"message"];
        feedCell.numberLikes.text = info[@"likes"];
        feedCell.numberComments.text = info[@"comments"];
        cell = feedCell;
    } else {
        FeedPhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"FeedPhotoCell"];
        photoCell.eventMessage.text = info[@"message"];
        photoCell.numberLikes.text = info[@"likes"];
        photoCell.numberComments.text = info[@"comments"];
        photoCell.photo.image = [UIImage imageNamed:info[@"image"]];
        cell = photoCell;
    }

    
    return cell;
}

- (float)configureHeightForIndexPath:(NSIndexPath *)indexPath
{
    float height = 40;
    NSDictionary *info = _dataList[indexPath.row];
    NSString *message = info[@"message"];
    CGSize messageSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(280, 60)];
    
    if (!info[@"image"]) {
        NSLog(@"No Image");
        height = messageSize.height + 20;
    } else {
        NSLog(@"Photo Cell");
        height = messageSize.height + 65;
    }

    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self configureHeightForIndexPath:indexPath];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -60) {
        [self.view addSubview:self.refreshView];
        [self.av startAnimating];
        _mainTable.frame = CGRectMake(_mainTable.frame.origin.x, 40, scrollView.frame.size.width, scrollView.frame.size.height);
        [self performSelector:@selector(doneRefresh) withObject:self afterDelay:3];
    }
}

- (void)doneRefresh
{
    NSLog(@"Done refreshing");
    [self.av stopAnimating];
    [self.refreshView removeFromSuperview];
    self.refreshView = nil;
    _mainTable.frame = CGRectMake(0, 0, _mainTable.frame.size.width, _mainTable.frame.size.height);
}

#pragma mark - FeedViewController actions
- (IBAction)changeToPostMessageControoler:(id)sender
{
    PostMessageController *postController = [[PostMessageController alloc] init];
    UINavigationController *controller = (UINavigationController *)self.parentViewController;
    [controller pushViewController:postController animated:YES];
}

- (IBAction)openMap:(id)sender
{
    SetNewLocationController *slController = [[SetNewLocationController alloc] init];
    NSLog(@"%@", self.parentViewController);
    UINavigationController *controller = (UINavigationController *)self.parentViewController;
    [controller pushViewController:slController animated:YES];
}



@end
