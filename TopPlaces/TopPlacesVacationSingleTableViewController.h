//
//  TopPlacesVacationSingleTableViewController.h
//  TopPlaces
//
//  Created by Arnaud Leene on 23/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface TopPlacesVacationSingleTableViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *vacation;

@end
