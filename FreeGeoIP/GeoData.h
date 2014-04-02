//
//  GeoData.h
//  FreeGeoIP
//
//  Created by Tyler H on 4/1/14.
//  Copyright (c) 2014 Tyler Hoffman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoData : NSObject
@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSString *country_code;
@property (strong, nonatomic) NSString *country_name;
@property (strong, nonatomic) NSString *region_code;
@property (strong, nonatomic) NSString *region_name;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *zipcode;
@property (strong, nonatomic) NSString *metro_code;
@property (strong, nonatomic) NSString *area_code;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

- (id) initWithDictionary:(NSDictionary *)dict;
@end
