//
//  TopPlacesPlaceMapViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 20/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesPlaceMapViewController.h"

@implementation TopPlacesPlaceMapViewController

@synthesize mapView = _mapView;

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control 
{
    // tell the delegate that the disclosure button has been tapped.
    [self.delegate topPlacesPhotoMapViewController:self showPlaceForAnnotation:view.annotation];
}

@end
