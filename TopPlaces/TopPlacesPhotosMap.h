//
//  TopPlacesPhotosMap.h
//  TopPlaces
//
//  Created by Arnaud Leene on 16/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>

@interface TopPlacesPhotosMap : UIViewController

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSDictionary *place;

@property (weak, nonatomic) IBOutlet MKMapView *photosMapView;

@end
