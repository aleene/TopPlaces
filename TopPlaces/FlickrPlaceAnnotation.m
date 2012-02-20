//
//  FlickPlaceAnnotation.m
//  TopPlaces
//
//  Created by Arnaud Leene on 20/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "FlickrPlaceAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPlaceAnnotation

@synthesize place = _place;

+ (FlickrPlaceAnnotation *)annotationForPlace:(NSDictionary *)place
{
    FlickrPlaceAnnotation *annotation = [[FlickrPlaceAnnotation alloc] init];
    annotation.place = place;
    return annotation;
}

- (NSArray *)placenamePartsForPlace:(NSString *)placeText
{
    
    // extract the place name parts
    NSMutableArray *placeName = [[NSMutableArray alloc] initWithArray:[placeText componentsSeparatedByString:@","]];
    if ([[placeName objectAtIndex:0] isEqualToString:@""]) {
        [placeName addObject:@"unknown country"];
    }
    return [placeName copy];
}

- (NSString *)title
{
    NSString *text = [[self placenamePartsForPlace:[self.place valueForKey:FLICKR_PLACE_NAME]] objectAtIndex:0];
    if ([text isEqualToString:@""]) {
        text = @"no city available";
    }
    return text;
}

- (NSString *)subtitle
{
    NSString *text = [[self placenamePartsForPlace:[self.place valueForKey:FLICKR_PLACE_NAME]] lastObject];
    if ([text isEqualToString:@""]) {
        text = @"no country available";
    }
    return text;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.place valueForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.place valueForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end
