//
//  FlickrPhotoAnnotation.m
//  TopPlaces
//
//  Created by Arnaud Leene on 17/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPhotoAnnotation

@synthesize photo = _photo;
@synthesize subsubtitle = _subsubtitle;

+ (FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo
{
    FlickrPhotoAnnotation *annotation = [[FlickrPhotoAnnotation alloc] init];
    annotation.photo = photo;
    return annotation;
}


- (NSString *)title
{
    NSString *text = [self.photo valueForKey:FLICKR_PHOTO_TITLE];
    if ([text isEqualToString:@""]) {
        text = @"no title available";
    }

    return text;
}

- (NSString *)subtitle
{
    NSString *text = [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if ([text isEqualToString:@""]) {
        text = @"no description available";
    }
    return text;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo valueForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.photo valueForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}
@end
