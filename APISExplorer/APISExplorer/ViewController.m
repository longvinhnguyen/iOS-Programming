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
#import "Photo.h"
#import "FIickrPhotoCell.h"

#define FLICKR_CELL @"FlickrCell"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@end

@implementation ViewController
{
    AFHTTPClient *client;
    CLLocationManager *locationManager;
    CLLocation *userLocation;
    NSMutableArray *_venueLists;
    NSMutableArray *_photoLists;
    NSMutableArray *_searchResultsLists;
    NSString *_selectedAPI;
    enum_api_request _selectedType;
    CGRect _originalFrame;
    
    UIPinchGestureRecognizer *pinchGesture;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    _venueLists = [NSMutableArray new];
    _photoLists = [NSMutableArray new];
    _searchResultsLists = [[NSMutableArray alloc] initWithCapacity:10];
    
    pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [_mainKollectionView addGestureRecognizer:pinchGesture];
    _mainKollectionView.hidden = YES;
    [_mainKollectionView registerNib:[UINib nibWithNibName:@"FlickrPhotoCell" bundle:nil] forCellWithReuseIdentifier:FLICKR_CELL ];
    
    _originalFrame = _mainTableView.frame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [VIEWDECKCONTROLLER toggleLeftView];
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
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
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
    _selectedAPI = api;
    _selectedType = type;


    [self performAPI:_selectedAPI withType:_selectedType];
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
            [params setObject:@"10000" forKey:@"radius"];
            [params setObject:@"prominence" forKey:@"rankby"];
            [params setObject:@"food|cafe|city_hall|night_club|museum|park" forKey:@"types"];
            [params setObject:@"false" forKey:@"sensor"];
            [params setObject:GOOGLE_MAP_API_KEY forKey:@"key"];
            [self performGoogleSearchPlaces:params];
            break;
        case enum_api_request_flickr:
            [self performFlickrPhotoSearch:@"Ho Chi Minh, Ho Chi Minh, Vietnam"];
//            [self performFlickrPlaceSearch:@"Ho chi minh"];
            break;
            
        default:
            break;
    }
}

- (void)performFlickrPlaceSearch:(NSString *)searchText
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"flickr.places.find" forKey:@"method"];
    [params setObject:FLICKR_API_KEY forKey:@"api_key"];
    [params setObject:searchText forKey:@"query"];
    [params setObject:@"json" forKey:@"format"];
    [params setObject:@"oJ7n6B5QUL82NXEv" forKey:@"place_id"];
    [params setObject:@"1" forKey:@"nojsoncallback"];
    [client getPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        VLog(@"performFlickrPlaceSearch =====> %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            ALERT(error.localizedDescription);
        }
    }];
}

- (void)performFlickrPhotoSearch:(NSString *)searchText
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"flickr.photos.search" forKey:@"method"];
    [params setObject:@"429ce41ef16c0f4821d75bf515a4593c" forKey:@"api_key"];
//    [params setObject:searchText forKey:@"tags"];
    [params setObject:searchText forKey:@"text"];
    [params setObject:@" interestingness-desc" forKey:@"sort"];
    [params setObject:@"1" forKey:@"accuracy"];
    [params setObject:@"json" forKey:@"format"];
    [params setObject:@"1" forKey:@"nojsoncallback"];
    [params setObject:@"30" forKey:@"per_page"];
    [client getPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        VLog(@"performFlickrPhotoSearch ======> %@", responseObject);
        if ([responseObject count] > 0) {
            NSArray *photos = responseObject[@"photos"][@"photo"];
            for (NSDictionary *dict in photos) {
                Photo *photo = [[Photo alloc] init];
                [photo loadPhotoFromFlickr:dict];
                [_photoLists addObject:photo];
            }
            VLog(@"performFlickrPhotoSearch =========> %@", _photoLists);
            _mainKollectionView.hidden = NO;
            CGRect frame = CGRectMake(0, HEIGHT_IPHONE, _mainKollectionView.bounds.size.width, _mainKollectionView.bounds.size.height);
            _mainKollectionView.frame = frame;
            [self.view addSubview:_mainKollectionView];
            frame.origin.y = 0;
            [UIView animateWithDuration:0.4 animations:^{
                _mainKollectionView.frame = frame;
            } completion:^(BOOL finished) {
                [_mainKollectionView reloadData];
            }];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"%@\n%@",error.localizedDescription, operation.request.URL];
            ALERT(errorMessage);
        }
    }];
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
             _mainTableView.frame = _originalFrame;
         } else if (nextPageToken.length > 0 && _venueLists.count < 30) {
             [params setObject:nextPageToken forKey:@"pagetoken"];
             [self performGoogleSearchPlaces:params];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         VLog(@"%@ %@", error.localizedDescription, operation.request.URL);
     }];
}

- (void)performGoogleTextSearch:(NSString *)textSearch;
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:textSearch forKey:@"query"];
    [params setObject:GOOGLE_MAP_API_KEY forKey:@"key"];
    [params setObject:@"false" forKey:@"sensor"];
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            VLog(@"Error %@ %@", error.localizedDescription, operation.request.URL);
        }
    }];
}

- (void)performGooglePlacesAutocompleSearch:(NSString *)searchText
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:searchText forKey:@"input"];
    [params setObject:GOOGLE_MAP_API_KEY forKey:@"key"];
    [params setObject:@"true" forKey:@"sensor"];
    [params setObject:@"geocode" forKey:@"types"];
    [client getPath:@"autocomplete/json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:GOOGLE_MAP_API_KEY forKey:@"key"];
        [params setValue:@"false" forKey:@"sensor"];
        NSArray *predictions = responseObject[@"predictions"];
        for (NSDictionary *dict in predictions) {
            [params setValue:dict[@"reference"] forKey:@"reference"];
            [client getPath:@"details/json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *result = responseObject[@"result"];
                if (result) {
                    Venue *venue = [[Venue alloc] init];
                    [venue loadDataFromGooglePlaceDetailResponse:result];
                    [_searchResultsLists addObject:venue];
                }
                [self.searchDisplayController.searchResultsTableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (error) {
                    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Error" andMessage: [NSString stringWithFormat:@"%@", error.localizedDescription]];
                    [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
                }
            }];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Error" andMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
            }];
            [alertView show];
        }
    }];
}

- (void)performGooglePlaceQueryAutocomplete:(NSString *)searchText
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:GOOGLE_MAP_API_KEY forKey:@"key"];
    [params setObject:@"false" forKey:@"sensor"];
    [params setObject:searchText forKey:@"input"];
    [params setObject:[NSString stringWithFormat:@"%f,%f",userLocation.coordinate.latitude, userLocation.coordinate.longitude] forKey:@"location"];
    [params setObject:@"50000" forKey:@"radius"];
    [client getPath:@"queryautocomplete/json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        VLog(@"%@ ==========> %@", operation.request.URL, responseObject);
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:GOOGLE_MAP_API_KEY forKey:@"key"];
        [params setValue:@"false" forKey:@"sensor"];
        NSArray *predictions = responseObject[@"predictions"];
        for (NSDictionary *dict in predictions) {
            [params setValue:dict[@"reference"] forKey:@"reference"];
            [client getPath:@"details/json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *result = responseObject[@"result"];
                if (result) {
                    Venue *venue = [[Venue alloc] init];
                    [venue loadDataFromGooglePlaceDetailResponse:result];
                    [_searchResultsLists addObject:venue];
                }
                [self.searchDisplayController.searchResultsTableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (error) {
                    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Error" andMessage: [NSString stringWithFormat:@"%@", error.localizedDescription]];
                    [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
                }
            }];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Error" andMessage:[NSString stringWithFormat:@"%@\n%@",error.localizedDescription, operation.request.URL]];
            [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
                return;
            }];
            [alertView show];
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
    if (!client) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Warning" andMessage:@"Please choose the API from LeftMenuController to explore"];
        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
        [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
            [VIEWDECKCONTROLLER toggleLeftView];
        }];
        [alertView show];

        return;
    }
    [_searchResultsLists removeAllObjects];
    VLog(@"SearchBar button clicked");
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading ...";
    hud.mode = MBProgressHUDModeIndeterminate;
//    [self performGoogleTextSearch:searchBar.text];
//    [self performGooglePlacesAutocompleSearch:searchBar.text];
//    [self performGooglePlaceQueryAutocomplete:searchBar.text];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    
}

#pragma mark
#pragma mark - ScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    VLog(@"content offset %f %f", scrollView.contentOffset.x, scrollView.contentOffset.y);  
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    VLog(@"content offset %f %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -60) {
        CGRect frame;
        frame = _mainTableView.frame;
        frame.origin.y = 50 + HEIGHT_SEARCH_BAR;
        _mainTableView.frame = frame;
        [self performAPI:_selectedAPI withType:enum_api_request_google];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    VLog(@"scrollViewDidScroll content offset %f %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
}

#pragma mark
#pragma mark - UIKollectionView datasource & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photoLists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FIickrPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FLICKR_CELL forIndexPath:indexPath];
    cell.photo = _photoLists[indexPath.item];
    
    return cell;
}
                
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 90);
}


#pragma mark - UIGestureRecoginizer actions
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)thePinchGesture
{
    if (thePinchGesture.state == UIGestureRecognizerStateBegan) {
        VLog(@"Pinch gesture start");
    } else if (thePinchGesture.state == UIGestureRecognizerStateChanged) {
        CGFloat scaleRatio = thePinchGesture.scale;
        VLog(@"handlePinchGesture ======> %f", scaleRatio);
        _mainKollectionView.transform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
    } else if (thePinchGesture.state == UIGestureRecognizerStateEnded) {
        if (pinchGesture.scale < 0.5) {
            _mainKollectionView.hidden = YES;
            _mainKollectionView.transform = CGAffineTransformIdentity;
        } else {
             _mainKollectionView.transform = CGAffineTransformIdentity;
        }
    }
}







@end
