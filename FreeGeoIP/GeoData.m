//
//  GeoData.m
//  FreeGeoIP
//
//  Created by Tyler H on 4/1/14.
//  Copyright (c) 2014 Tyler Hoffman. All rights reserved.
//

#import "GeoData.h"

@implementation GeoData
@synthesize ip = _ip;
@synthesize country_code = _country_code;
@synthesize country_name = _country_name;
@synthesize region_code = _region_code;
@synthesize region_name = _region_name;
@synthesize city = _city;
@synthesize zipcode = _zipcode;
@synthesize metro_code = _metro_code;
@synthesize area_code = _area_code;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

- (id) initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        _ip = dict[@"ip"];
        _country_code = dict[@"country_code"];
        _country_name = dict[@"country_name"];
        _region_code = dict[@"region_code"];
        _region_name = dict[@"region_name"];
        _city = dict[@"city"];
        _zipcode = dict[@"zipcode"];
        _metro_code = dict[@"metro_code"];
        _area_code = dict[@"area_code"];
        _latitude = [(NSNumber *)dict[@"latitude"] doubleValue];
        _longitude = [(NSNumber *)dict[@"longitude"] doubleValue];
    }
    return self;
}
@end
