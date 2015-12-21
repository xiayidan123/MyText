//
//  CustomAnnotation.m
//  omim
//
//  Created by coca on 2012/11/11.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//


#import "CustomAnnotation.h"

@implementation CustomAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize shortTitle;

@synthesize latitude;
@synthesize longitude;

- (id) initWithLatitude:(CLLocationDegrees) lat longitude:(CLLocationDegrees) lng {
	latitude = lat;
	longitude = lng;
	return self;
}
- (CLLocationCoordinate2D) coordinate {
	CLLocationCoordinate2D coord = {self.latitude, self.longitude};
	return coord;
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    coordinate.latitude = newCoordinate.latitude;
    coordinate.longitude = newCoordinate.longitude;
    latitude = newCoordinate.latitude;
    longitude = newCoordinate.longitude;
    
}


@end


