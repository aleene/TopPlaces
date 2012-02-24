//
//  TopPlacesVacationItineraryPhotosTableViewController.h
//  TopPlaces
//
//  Created by Arnaud Leene on 24/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Place.h"

@interface TopPlacesVacationItineraryPhotosTableViewController : CoreDataTableViewController

// needs these to continue working with the same document

@property (nonatomic, strong) UIManagedDocument *vacation;
@property (nonatomic, strong) Place *selectedPlace;


@end
