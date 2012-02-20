//
//  TopPlacesPhotoMapViewController.h
//  TopPlaces
//
//  Created by Arnaud Leene on 17/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class TopPlacesPhotoMapViewController;
@protocol MapViewControllerDelegate <NSObject>

- (UIImage *)topPlacesPhotoMapViewController:(TopPlacesPhotoMapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
- (void)topPlacesPhotoMapViewController:(TopPlacesPhotoMapViewController *)sender showDetailForAnnotation:(id <MKAnnotation>)annotation;

@end

@interface TopPlacesPhotoMapViewController : UIViewController

@property (nonatomic, strong) NSArray *annotations; // of <id> MKAnnotation
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;

@end