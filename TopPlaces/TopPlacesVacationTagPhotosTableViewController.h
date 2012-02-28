//
//  TopPlacesVacationTagPhotosTableViewController.h
//  TopPlaces
//
//  Created by Arnaud Leene on 26/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Tag.h"

@interface TopPlacesVacationTagPhotosTableViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *vacation;
@property (nonatomic, strong) Tag *selectedTag;

@end
