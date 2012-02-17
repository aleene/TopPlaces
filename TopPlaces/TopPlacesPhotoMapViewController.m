//
//  TopPlacesPhotoMapViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 17/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesPhotoMapViewController.h"

@interface  TopPlacesPhotoMapViewController() <MKMapViewDelegate>

@end

@implementation TopPlacesPhotoMapViewController 

@synthesize annotations = _annotations;
@synthesize mapView = _mapView;
@synthesize delegate = _delegate; 

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation 
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    }
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    UIImage *image = [self.delegate topPlacesPhotoMapViewController:self imageForAnnotation:view.annotation];
    [(UIImageView *)view.leftCalloutAccessoryView setImage:image];
}

#define REGIONMARGIN 1.1
- (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations
{
    id <MKAnnotation> annotation = [annotations objectAtIndex:0];
    double minLongitude = annotation.coordinate.longitude;
    double maxLongitude = minLongitude;
    double minLatitude = annotation.coordinate.latitude;
    double maxLatitude = minLatitude;

    // loop over all annotations to find the mean
    for (id <MKAnnotation> annotation in annotations) {
        if (annotation.coordinate.longitude > maxLongitude) {
            maxLongitude = annotation.coordinate.longitude;
        }
        if (annotation.coordinate.longitude < minLongitude) {
            minLongitude = annotation.coordinate.longitude;
        }
        if (annotation.coordinate.latitude > maxLatitude) {
            maxLatitude = annotation.coordinate.latitude;
        }
        if (annotation.coordinate.latitude < minLatitude) {
            minLatitude = annotation.coordinate.latitude;
        }

    }
        
    // I should set the map region based on the annotations
    CLLocationCoordinate2D mapCenter;
    mapCenter.longitude = (maxLongitude - minLongitude)/2 + minLongitude;
    mapCenter.latitude = (maxLatitude - minLatitude)/2 + minLatitude;
    MKCoordinateRegion mapRegion;
    MKCoordinateSpan mapSpan;
    mapSpan.longitudeDelta = (maxLongitude - minLongitude) * REGIONMARGIN;
    mapSpan.latitudeDelta = (maxLatitude - minLatitude) * REGIONMARGIN;
    mapRegion.center = mapCenter;
    mapRegion.span = mapSpan;
    return mapRegion;
}

// keep model and view in sync
- (void)updateMapView 
{
    // remove what was already there
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    
    // if I have a list of photos, create annotations for them and add them to the map
    if (self.annotations) {
        self.mapView.region = [self regionForAnnotations:self.annotations];
        [self.mapView addAnnotations:self.annotations];
    }
}

- (void)setMapView:(MKMapView *)mapView  // syncing purpose
{
    _mapView = mapView;
    [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (YES);
}

@end
