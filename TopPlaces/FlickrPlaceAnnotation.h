//
//  FlickPlaceAnnotation.h
//  TopPlaces
//
//  Created by Arnaud Leene on 20/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>

@interface FlickrPlaceAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSDictionary *place;

+ (FlickrPlaceAnnotation *)annotationForPlace:(NSDictionary *)place;

@end
