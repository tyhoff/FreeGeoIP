//
//  ViewController.h
//  FreeGeoIP
//
//  Created by Tyler H on 4/1/14.
//  Copyright (c) 2014 Tyler Hoffman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GeoData.h"

@interface MapViewController : UIViewController <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) GeoData *data;

@end
