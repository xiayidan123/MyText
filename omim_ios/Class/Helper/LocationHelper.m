//
//  LocationHelper.m
//  omim
//
//  Created by elvis on 2013/05/14.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "LocationHelper.h"
#import "WowTalkWebServerIF.h"

#import "WGS84TOGCJ02.h"

@interface LocationHelper ()

@end

@implementation LocationHelper


+ (LocationHelper *)defaultLocaltionHelper {
    
    static dispatch_once_t pred = 0;
    static LocationHelper *helper = nil;
    dispatch_once(&pred, ^{
        helper = [[LocationHelper alloc] init];
    });
    
    return helper;
}

-(void)startTraceLocation
{
    if (nil == _cllmanager) {
        _cllmanager = [[CLLocationManager alloc] init];
    }
    
    _cllmanager.delegate = self;
    
    _cllmanager.desiredAccuracy = kCLLocationAccuracyKilometer;
    _cllmanager.distanceFilter = 500;
    
    [_cllmanager startUpdatingLocation];

}

-(void)stopTraceLocation
{
    [_cllmanager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* location =  newLocation;
    
    if (![WGS84TOGCJ02 isLocationOutOfChina:[location coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[location coordinate]];
        location = [[CLLocation alloc]initWithLatitude:coord.latitude longitude:coord.longitude];
    }
    
    self.currentLocation = location;
    
    [WowTalkWebServerIF userBecomeActiveWithLastLongitude:self.currentLocation.coordinate.longitude withLastLatitude:self.currentLocation.coordinate.latitude withCallback:nil withObserver:nil];
    
    [manager stopUpdatingLocation];
    
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake( location.coordinate.latitude, location.coordinate.longitude);
    
    MKReverseGeocoder *reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:startCoord] autorelease];
    
    reverseGeocoder.delegate = self;
    
    [reverseGeocoder start];
}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    NSDictionary *address =[[[NSDictionary alloc]initWithDictionary:placemark.addressDictionary] autorelease];
    
    NSString* country = [address valueForKey:@"Country"];
    NSString* city = [address valueForKey:@"City"];
    NSString* state = [address valueForKey:@"State"];
    
    NSString* thoroughfare = [address valueForKey:@"Thoroughfare"];
    NSString* subThoroughfare = [address valueForKey:@"SubThoroughfare"];
    
    
    NSMutableString* title = [[[NSMutableString alloc] init] autorelease];
    if (country !=nil) {
        [title appendString:country];
        [title appendString:@" "];
    }
    
    
    if (state !=nil) {
        [title appendString:state];
        [title appendString:@" "];
    }
    
    if (city !=nil) {
        [title appendString:city];
        [title appendString:@" "];
    }
    
    if (thoroughfare !=nil) {
        [title appendString:thoroughfare];
        [title appendString:@" "];
    }
    if (subThoroughfare !=nil) {
        [title appendString:subThoroughfare];
    }
    
    [geocoder cancel];
    
    self.locationName = title;
    
    if (self.delegate&& [self.delegate respondsToSelector:@selector(getCurrentLocationData:withResult:)]) {
        [self.delegate getCurrentLocationData:self withResult:TRUE];
    }
    
}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    if (self.delegate&& [self.delegate respondsToSelector:@selector(getCurrentLocationData:withResult:)]) {
        [self.delegate getCurrentLocationData:self withResult:FALSE];
    }
    [geocoder cancel];
}

-(void)dealloc
{
    self.currentLocation = nil;
    [super dealloc];
}

-(CLLocationDistance)distanceBetweenMyLocationAndPlaceWithLatitude:(double)latitude Longitude:(double)longitude
{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
   
    CLLocationDistance meters = [loc distanceFromLocation:self.currentLocation];
    
    [loc release];
    
    return fabs(meters) / 1000;
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_cllmanager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                [_cllmanager requestWhenInUseAuthorization];// 前台定位
            }
            break;
            
        default:
            break;
    }
}

@end
