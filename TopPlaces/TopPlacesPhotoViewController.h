//
//  TopPlacesPhotoViewController.h
//  TopPlaces
//
//  Created by Arnaud Leene on 3/2/12.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//
//  This class shows a single Flickr Photo in a scrollview

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"
#import "TopPlacesVacationsModalTableViewController.h"
#import "Vacation.h"
#import "FlickrPhoto.h"

//  this class implements the required SplitViewBarButtonItemPresenter methods
//  and the ChosenVacationDelegate methods

@interface TopPlacesPhotoViewController : UIViewController <SplitViewBarButtonItemPresenter, ChosenVacationDelegate>

@property (nonatomic, strong) Vacation *vacation;
@property (nonatomic, strong) FlickrPhoto *flickrPhoto;;
// I would like supress the next method 
@property (nonatomic, strong) NSDictionary *photo;

@end
