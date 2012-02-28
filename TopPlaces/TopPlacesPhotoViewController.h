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

//  this class implements the required SpltViewBarButtonItemPresenter methods

@interface TopPlacesPhotoViewController : UIViewController <SplitViewBarButtonItemPresenter>

// this interface is not very nice, as it is now not clear what we really need:
// photo.title to show in the navigationBar
// photo.url to retrieve the photo itself
// it should be possible to clean things up

@property (nonatomic, strong) NSDictionary *photo;
@property (nonatomic, strong) NSURL *selectedPhotoUrl;

@end
