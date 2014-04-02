//
//  ViewController.m
//  FreeGeoIP
//
//  Created by Tyler H on 4/1/14.
//  Copyright (c) 2014 Tyler Hoffman. All rights reserved.
//

#import "MapViewController.h"
#include <arpa/inet.h>


#define COORDINATES 1
#define CITYSTATEZIP 2



@interface MapViewController ()
{
    GeoData * geoData;
}

@end

@implementation MapViewController

#pragma Defaults

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    _searchBar.delegate = self;
    [self getGeoDataForCurrentIP];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma FreeGeoIP

/* Have the API detect the current external IP */
- (void) getGeoDataForCurrentIP
{
    [self getGeoDataForIP:nil];
}

/* The user entered an IP address */
- (void) getGeoDataForIP:(NSString *)ip
{
    NSMutableString *url = [NSMutableString stringWithString:@"http://freegeoip.net/json/"];
    
    if (ip != nil) {
        [url appendString:ip];
    }
    
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    
    /* Execute on main queue since it is the only application running, and it is easy to update UI */
	NSOperationQueue *queue = [NSOperationQueue mainQueue];
	[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        /* Dictionary of information from freegeoip.net */
        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        geoData = [[GeoData alloc] initWithDictionary:root];
        
        /* Hard coded value for now */
        int type = COORDINATES;
        
        
        /* If the user wants to base the location off of the coordinates returned from freegeoip */
        if (type == COORDINATES) {
            
            /* Set zoom and center */
            MKCoordinateRegion region;
            CLLocationCoordinate2D location;
            location.latitude = geoData.latitude;
            location.longitude = geoData.longitude;
            region.center = location;
            region.span.latitudeDelta = 1.0;
            region.span.longitudeDelta = 1.0;
            
            /* Generate a placemark with the coordinates */
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil];
            
            /* move map to location */
            [_map setRegion:region animated:YES];
            [_map addAnnotation:placemark];
            
            _searchBar.text = geoData.ip;
            self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"%f, %f", geoData.latitude, geoData.longitude];

            
        /* If the user wants to base the location off of the city/state/zip returned from freegeoip */
        } else if (type == CITYSTATEZIP) {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            
            /* format string for query */
            NSString *address = [NSString stringWithFormat:@"%@, %@ %@", geoData.city, geoData.region_name, geoData.zipcode];
            
            [geocoder geocodeAddressString:address
                         completionHandler:^(NSArray* placemarks, NSError* error){
                             if (placemarks && [placemarks count] > 0)
                             {
                                 CLPlacemark *temp = [placemarks firstObject];
                                 MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:temp];
                                 
                                 MKCoordinateRegion region = _map.region;
                                 
                                 //depracated but I can't find a better way
                                 region.center = [(CLCircularRegion *)placemark.region center];
                                 region.span.latitudeDelta = 1.0;
                                 region.span.longitudeDelta = 1.0;
                                 
                                 [_map setRegion:region animated:YES];
                                 [_map addAnnotation:placemark];
                             }
                         }
             ];
            
            _searchBar.text = geoData.ip;
            self.navigationController.navigationBar.topItem.title = address;
            
        } else {
            NSLog(@"uh oh\n");
        }
    }];
}

#pragma SearchBar

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self removeAnnotations];
    NSString *ip = searchBar.text;
    
    if ([self isValidIP:ip]) {
        [self getGeoDataForIP:ip];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"An invalid IP address has been entered" delegate: self cancelButtonTitle: nil otherButtonTitles: @"OK",nil, nil];
        [alert show];
    }
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_searchBar resignFirstResponder];
}

#pragma Utilities

- (void) removeAnnotations
{
    [_map removeAnnotations:[_map annotations]];
}

- (BOOL) isValidIP:(NSString *)ip
{
    const char *utf8 = [ip UTF8String];
    int success;
    
    struct in_addr dst;
    success = inet_pton(AF_INET, utf8, &dst);
    
    return success == 1;
}

@end
