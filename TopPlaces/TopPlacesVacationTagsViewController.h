//
//  TopPlacesVacationTagsViewController.h
//  TopPlaces
//
//  Created by Arnaud Leene on 24/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Vacation.h"

@interface TopPlacesVacationTagsViewController : CoreDataTableViewController

@property (nonatomic, strong) Vacation *vacation;

@end
