//
//  ViewController.m
//  CocoaPodsExample
//
//  Created by Long Vinh Nguyen on 5/6/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"
#import "TraktAPIClient.h"


@implementation ViewController
{
    NSArray *jsonResponse;
    BOOL pageControlUsed;
    int previousPage;
    NSMutableSet *loadedPages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 1 Create trakt API Client
    TraktAPIClient *client = [TraktAPIClient sharedClient];
    
    // 2
    NSDate *today = [NSDate date];
    
    // 3
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *todayString = [formatter stringFromDate:today];
    // 4
    NSString *path = [NSString stringWithFormat:@"user/calendar/shows.json/%@/%@/%@/%d",kTraktAPIKey, @"marcelofabri", todayString, 3];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:nil];
    loadedPages = [NSMutableSet set];
    previousPage = -1;
    // 5
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@",JSON);
        jsonResponse = JSON;
        int shows = 0;
        for (NSDictionary *day in jsonResponse) {
            shows += [[day $for: @"episodes"] count];
        }
        NSLog(@"Number of shows: %d",shows);
         _showPageControl.numberOfPages = shows;
         _showPageControl.currentPage = 0;
         _showScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * shows, self.view.frame.size.height);
         [self loadShow:0];
                                         
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@",[error localizedDescription]);
    }];
    [operation start];
}

- (void)loadShow:(int)index
{
    if (![loadedPages containsObject:$int(index)]) {
        int shows = 0;
        NSDictionary *show = nil;
        for (NSDictionary *day in jsonResponse) {
            int count = [[day $for:@"episodes"] count];
            if (index < shows + count) {
                show = [[day $for:@"episodes"] $at:index-shows];
                break;
            }
            shows += count;
        }
        
        NSDictionary *episodeDict = [show $for:@"episode"];
        NSDictionary *showDict = [show $for:@"show"];
        // Display the show information
        
//        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(index *_showScrollView.bounds.size.width, 40, _showScrollView.bounds.size.width, 40)];
//        label.text = [showDict objectForKey:@"title"];
//        label.backgroundColor = [UIColor clearColor];
//        label.font = [UIFont systemFontOfSize:18];
//        label.textAlignment = UIBaselineAdjustmentAlignCenters;
        NIAttributedLabel *label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(index * _showScrollView.frame.size.width, 40, _showScrollView.frame.size.width, 40)];
        label.text = showDict[@"title"];
        label.backgroundColor = [UIColor clearColor];
        label.linkColor  = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = UIBaselineAdjustmentAlignCenters;
        [label addLink:[NSURL URLWithString:showDict[@"url"]] range:NSMakeRange(0, label.text.length)];
        label.delegate = self;
        [_showScrollView addSubview:label];
        [loadedPages addObject:$int(index)];
        
        // Create formatted airing date
        static NSDateFormatter *formatter = nil;
        if (!formatter) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateStyle = NSDateFormatterLongStyle;
            formatter.timeStyle = NSDateFormatterShortStyle;
            formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
        }
        NSTimeInterval showAired = [[episodeDict objectForKey:@"first_aired_localized"] doubleValue];
        NSString *showDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:showAired]];
        
        // Create label to display episode info
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(index *_showScrollView.bounds.size.width, 360, _showScrollView.bounds.size.width, 40)];
        NSString *episode = [NSString stringWithFormat:@"%02dx%02d - \"%@\"", [[episodeDict valueForKey:@"season"]intValue],
                             [[episodeDict valueForKey:@"number"]intValue],
                             [episodeDict valueForKey:@"title"]];
        lbl.text = [NSString stringWithFormat:@"%@\n%@",episode, showDate];
        lbl.numberOfLines = 0;
        lbl.textColor = [UIColor whiteColor];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textAlignment = UIBaselineAdjustmentAlignCenters;
        [_showScrollView addSubview:lbl];
        
        // Get Image
        NSString *posterURL = [[showDict $for:@"images"] $for:@"poster"];
        if ([[UIScreen mainScreen] isRetinaDisplay]) {
            posterURL = [posterURL stringByReplacingOccurrencesOfString:@".jpg" withString:@"-300.jpg"];
        } else {
            posterURL = [posterURL stringByReplacingOccurrencesOfString:@".jpg" withString:@"-138.jpg"];
        }
        
        // 6.4 Display image using image view
        UIImageView *posterImage = [[UIImageView alloc] init];
        posterImage.frame = CGRectMake(index * _showScrollView.bounds.size.width + 90, 80, 150, 225);
        [_showScrollView addSubview:posterImage];

        // 6.5 Asynchronously load the image
        [posterImage setImageWithURL:[NSURL URLWithString:posterURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    

    }
}

- (IBAction)pageChanged:(id)sender
{
    // Set flag
    pageControlUsed = YES;
    // Get previous number page
    int page = _showPageControl.currentPage;
    previousPage = page;
    // Call load show for the new page
    [self loadShow:page];
    // Scroll scroll view to new page
    CGRect frame = _showScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.showScrollView scrollRectToVisible:frame animated:YES];
    } completion:^(BOOL finished) {
        pageControlUsed = NO;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Was the scrolling initiated via page control
    if (pageControlUsed) {
        return;
    }
    
    // Figure out page to scroll to
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"ContentOffset X:%.2f %d",scrollView.contentOffset.x,page);
    if (page == previousPage || page < 0 || page >= _showPageControl.numberOfPages) {
        return;
    }
    previousPage = page;
    // Set the page control page display
    _showPageControl.currentPage = page;
    // Load the image
    [self loadShow:page];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

#pragma mark - NIAttributedLabel delegate
- (void)attributedLabel:(NIAttributedLabel *)attributedLabel didSelectTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point
{
    [[UIApplication sharedApplication] openURL:result.URL];
}

@end
