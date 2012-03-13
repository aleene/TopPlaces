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
#import "Vacation.h"

@interface TopPlacesVacationItineraryPhotosTableViewController : CoreDataTableViewController

// needs these to continue working with the same document

@property (nonatomic, strong) Vacation *vacation;
@property (nonatomic, strong) Place *selectedPlace;


@end
