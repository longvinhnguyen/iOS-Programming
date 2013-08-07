//
//  SetNewLocationController.h
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 7/31/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface SetNewLocationController : UIViewController<GMSMapViewDelegate>

@property (nonatomic, weak) IBOutlet GMSMapView *mapView;

@end
