//
//  TwitterFeedViewController.m
//  iSocial
//
//  Created by Felipe on 9/3/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "TwitterFeedViewController.h"
#import "AppDelegate.h"
#import "TwitterCell.h"

@implementation TwitterFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTwitterFeed) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTwitterFeed) name:AccountTwitterAccountAccessGranted object:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.twitterAccount) {
        [self refreshTwitterFeed];
    } else {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate getTwitterAccount];
    }
    
}


- (void)refreshTwitterFeed
{
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"] parameters:@{@"count":@"50"}];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    request.account = appDelegate.twitterAccount;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        [self.refreshControl endRefreshing];
        
        if (error) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error reading your Twitter feed. %@", error.localizedDescription]];
            
        } else {
            NSError *error;
            NSArray *responseJson = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            
            if (error) {
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error reading your Twitter feed. %@", error.localizedDescription]];
            } else {
                self.tweetsArray = responseJson;
                self.imagesDictionary = [NSMutableDictionary dictionary];
                VLog(@"%@", _tweetsArray);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }
        }
    }];
}

#pragma mark
#pragma mark - UITableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCellAtIndexPath:indexPath.row];
}

- (CGFloat)heightForCellAtIndexPath:(NSUInteger)index
{
    NSDictionary *tweet = self.tweetsArray[index];
    
    CGFloat cellHeight = 50;
    
    NSString *tweetText = tweet[@"text"];
    
    CGSize labelHeight = [tweetText sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(700, 250)];
    cellHeight += labelHeight.height;
    
    return cellHeight;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwitterCell"];
    
    NSDictionary *currentTweet = [self.tweetsArray objectAtIndex:indexPath.row];
    NSDictionary *currentUser = currentTweet[@"user"];
    
    cell.usernameLabel.text = currentUser[@"name"];
    cell.tweetLabel.text = currentTweet[@"text"];
    cell.tweetLabel.frame = CGRectMake(cell.tweetLabel.frame.origin.x, cell.tweetLabel.frame.origin.y, 700, [self heightForCellAtIndexPath:indexPath.row] - 50);
    
    NSString *userName = cell.usernameLabel.text;
    if (self.imagesDictionary[userName]) {
        cell.userImageView.image = self.imagesDictionary[userName];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL  *imageURL = [NSURL URLWithString:currentUser[@"profile_image_url"]];
            
            __block NSData *imageData;
            
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                imageData = [NSData dataWithContentsOfURL:imageURL];
                
                [self.imagesDictionary setObject:[UIImage imageWithData:imageData] forKey:userName];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    cell.imageView.image = self.imagesDictionary[cell.usernameLabel.text];
                });
            });
            
        });
    }
    
    return cell;
    
}





@end
