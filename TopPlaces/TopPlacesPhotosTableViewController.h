//
//  TopPlacesPhotosTableViewController.h
//  TopPlaces
//
//  Created by Arnaud Leene on 2/2/12.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//
//  This class shows a list of Top Flickr Photos

#import <UIKit/UIKit.h>

@interface TopPlacesPhotosTableViewController : UITableViewController


// generic flickr-based properties. 
@property (nonatomic, strong) NSArray *flickrList;
@property (nonatomic, strong) NSDictionary *flickrLocation;
@property (nonatomic, strong) NSDictionary *flickrPhoto;

@end
