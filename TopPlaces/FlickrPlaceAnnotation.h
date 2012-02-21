//
//  FlickPlaceAnnotation.h
//  TopPlaces
//
//  Created by Arnaud Leene on 20/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>
#import "FlickrPhotoAnnotation.h"

@interface FlickrPlaceAnnotation : FlickrPhotoAnnotation

+ (FlickrPlaceAnnotation *)annotationForPlace:(NSDictionary *)photo;

@end
