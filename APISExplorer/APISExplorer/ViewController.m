//
//  ViewController.m
//  APISExplorer
//
//  Created by Long Vinh Nguyen on 6/9/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"
#import <IIViewDeckController.h>
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import "Venue.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@end

@implementation ViewController
{
    AFHTTPClient *client;
    CLLocationManager *locationManager;
    CLLocation *userLocation;
    NSMutableArray *_venueLists;
    NSMutableArray *_searchResultsLists;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    _venueLists = [NSMutableArray new];
    _searchResultsLists = [[NSMutableArray alloc] initWithCapacity:10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [VIEWDECKCONTROLLER openLeftViewAnimated:YES];
}

#pragma mark
#pragma mark - UITableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _mainTableView) {
        return _venueLists.count;
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _searchResultsLists.count;
    }
    return _venueLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellId = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    Venue *_venue;
    if (tableView == _mainTableView) {
        _venue = _venueLists[indexPath.row];
    } else if (self.searchDisplayController.searchResultsTableView) {
        _venue = _searchResultsLists[indexPath.row];
    }
    
    
    cell.textLabel.text = _venue.title;
    cell.detailTextLabel.text = _venue.detailTitle;
    cell.imageView.image = _venue.imageIcon;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Venue *venue;
    if (tableView == _mainTableView) {
        venue = [_venueLists objectAtIndex:indexPath.row];
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
        venue = [_searchResultsLists objectAtIndex:indexPath.row];
    }
    [self.delegate viewController:self showVenueOnMap:venue];
    if (![VIEWDECKCONTROLLER isSideOpen:IIViewDeckRightSide]) {
        [VIEWDECKCONTROLLER toggleRightView];
    }
}

#pragma mark
#pragma mark - LeftMenuController delegate

- (void)leftMenuControllerdidFinishSelectingAPI:(NSString *)api withType:(enum_api_request)type
{
    client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [self performAPI:api withType:type];
}

- (void)performAPI:(NSString *)api withType:(enum_api_request)type
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    switch (type) {
        case enum_api_request_fs:
        {
            [params setObject:@"Chicago, IL" forKey:@"near"];
            [params setObject:@"30" forKey:@"limit"];
            [params setObject:FS_USER_TOKEN forKey:@"oauth_token"];
            [params setObject:FS_USER_ID forKey:@"v"];
            
            [client getPath:@"venues/search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                VLog(@"venue search %@", responseObject);
                _venueLists = responseObject[@"response"][@"venues"];
                [self.mainTableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }];
            break;
        }
        case enum_api_request_google:
            [params setObject:[NSString stringWithFormat:@"%f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude] forKey:@"location"];
            [params setObject:@"1000" forKey:@"radius"];
            [params setObject:@"food" forKey:@"types"];
            [params setObject:@"false" forKey:@"sensor"];
            [params setObject:GOOGLE_MAP_API_KEY forKey:@"key"];
            [self performGoogleSearchPlaces:params];
            
            break;
            
        default:
            break;
    }
}

- (void)performGoogleSearchPlaces:(NSMutableDictionary *)params
{
    [client getPath:@"nearbysearch/json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString *nextPageToken = responseObject[@"next_page_token"];
         VLog(@"%@ ==========> %@", nextPageToken, responseObject);
         NSArray *results = responseObject[@"results"];
         if ([responseObject[@"results"] count] > 0) {
             for (NSDictionary *dictionary in results) {
                 Venue *venue = [[Venue alloc] init];
                 [venue loadDataFromGooglePlacesResponse:dictionary];
                 [_venueLists addObject:venue];
             }
             [self.mainTableView reloadData];
         } else if (nextPageToken.length > 0 && _venueLists.count < 30) {
             [params setObject:nextPageToken forKey:@"pagetoken"];
             [self performGoogleSearchPlaces:params];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         VLog(@"%@ %@", error.localizedDescription, operation.request.URL);
     }];
}

- (void)performGoogleTextSearch:(NSMutableDictionary *)params;
{
    [client getPath:@"textsearch/json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *nextPageToken = responseObject[@"next_page_token"];
        VLog(@"%@ ==========> %@", nextPageToken, responseObject);
        NSArray *results = responseObject[@"results"];
        for (NSDictionary *dict in results) {
            if (results.count > 0) {
                Venue *venue = [[Venue alloc] init];
                [venue loadDataFromGooglePlaceTextSearch:dict];
                if (_searchResultsLists.count < 10) {
                    [_searchResultsLists addObject:venue];
                }
            }
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            VLog(@"Error %@ %@", error.localizedDescription, operation.request.URL);
        }
    }];
}

#pragma mark
#pragma mark - CoreLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[locations.count - 1];
    userLocation = location;
    VLog(@"My location is: %f %f",location.coordinate.latitude, location.coordinate.longitude);
    GMSGeocoder *geocoder = [[GMSGeocoder alloc] init];
    [geocoder reverseGeocodeCoordinate:userLocation.coordinate completionHandler:^(GMSReverseGeocodeResponse *placemark, NSError *error) {
        if (!error) {
            VLog(@"%@ %@", placemark.firstResult.addressLine1, placemark.firstResult.addressLine2);
        }
    }];
    [locationManager stopUpdatingLocation];
}

#pragma mark
#pragma mark - SearchDisplayController delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchResultsLists removeAllObjects];
    VLog(@"SearchBar button clicked");
    NSString *searchText = searchBar.text;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:searchText forKey:@"query"];
    [params setObject:GOOGLE_MAP_API_KEY forKey:@"key"];
    [params setObject:@"false" forKey:@"sensor"];
    [self performGoogleTextSearch:params];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    VLog(@"SearchBar button clicked");
}

@end
