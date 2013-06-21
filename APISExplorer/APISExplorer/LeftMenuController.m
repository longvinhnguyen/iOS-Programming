//
//  LeftMenuController.m
//  APISExplorer
//
//  Created by Long Vinh Nguyen on 6/9/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "LeftMenuController.h"
#import "AppDelegate.h"
#import <IIViewDeckController.h>


@interface LeftMenuController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation LeftMenuController
{
    NSMutableDictionary *apiLists;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        apiLists = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [apiLists setValue:STRING_ROOT_URL_REQUEST_FOURSQUARE forKey:[NSString stringWithFormat:@"%i",enum_api_request_fs]];
    [apiLists setValue:STRING_ROOT_URL_REQUEST_GOOLGE_PLACES forKey:[NSString stringWithFormat:@"%i",enum_api_request_google]];
    [apiLists setValue:STRING_ROOT_URL_REQUEST_FLICKR forKey:[NSString stringWithFormat:@"%i",enum_api_request_flickr]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - UITableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return apiLists.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    int type = [apiLists.allKeys[indexPath.row] intValue];
    switch (type) {
        case enum_api_request_fs:
            cell.textLabel.text = @"Foursquare API";
            cell.imageView.image = [UIImage imageNamed:@"foursquare"];
            break;
        case enum_api_request_google:
            cell.textLabel.text = @"Google Places API";
            cell.imageView.image = [UIImage imageNamed:@"google"];
            break;
        case enum_api_request_flickr:
            cell.textLabel.text = @"Flickr API";
            cell.imageView.image = [UIImage imageNamed:@"flickr"];
            break;
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [VIEWDECKCONTROLLER toggleLeftView];
    [self.delegate leftMenuControllerdidFinishSelectingAPI:apiLists[apiLists.allKeys[indexPath.row]] withType:[apiLists.allKeys[indexPath.row] intValue]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
