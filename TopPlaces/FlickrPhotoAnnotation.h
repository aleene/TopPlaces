//
//  FlickrPhotoAnnotation.h
//  TopPlaces
//
//  Created by Arnaud Leene on 17/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>

@interface FlickrPhotoAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSDictionary *photo;

@property (nonatomic, strong) NSString * subsubtitle;

+ (FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo;


@end
