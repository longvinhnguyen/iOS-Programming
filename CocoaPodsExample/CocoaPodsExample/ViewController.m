//
//  ViewController.m
//  CocoaPodsExample
//
//  Created by Long Vinh Nguyen on 5/6/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <ConciseKit.h>
#import <SSToolkit.h>
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
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(index *_showScrollView.bounds.size.width, 40, _showScrollView.bounds.size.width, 40)];
        label.text = [showDict objectForKey:@"title"];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = UIBaselineAdjustmentAlignCenters;
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
        
    }
}

- (IBAction)pageChanged:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
