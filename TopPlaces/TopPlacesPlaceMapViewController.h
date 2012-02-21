//
//  TopPlacesPlaceMapViewController.h
//  TopPlaces
//
//  Created by Arnaud Leene on 20/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopPlacesPhotoMapViewController.h"

@class TopPlacesPlaceMapViewController;

@protocol MapViewControllerDelegate <NSObject>

- (UIImage *)topPlacesPlaceMapViewController:(TopPlacesPlaceMapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
- (void)topPlacesPhotoMapViewController:(TopPlacesPlaceMapViewController *)sender showPlaceForAnnotation:(id <MKAnnotation>)annotation;

@end

@interface TopPlacesPlaceMapViewController : TopPlacesPhotoMapViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
