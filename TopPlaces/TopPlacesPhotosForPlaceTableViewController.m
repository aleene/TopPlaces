//
//  TopPlacesPhotosForPlaceTableViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 2/2/12.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesPhotosForPlaceTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoAnnotation.h"
#import "TopPlacesPhotoViewController.h"
#import "TopPlacesPhotosTableViewController.h"
#import "TopPlacesPhotoMapViewController.h"

@interface TopPlacesPhotosForPlaceTableViewController() 

@end

@implementation TopPlacesPhotosForPlaceTableViewController

- (void)refresh 
{    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    UIBarButtonItem *spinnerButton = [[UIBarButtonItem alloc] initWithCustomView:spinner];

    UIBarButtonItem *currentButton = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = spinnerButton;

    dispatch_queue_t placePhotosQueue = dispatch_queue_create("place photos queue", NULL);
    dispatch_async(placePhotosQueue, ^{
        NSMutableArray *photosFound = [NSMutableArray alloc];
        if (self.flickrLocation) {
            photosFound = [photosFound initWithArray:[FlickrFetcher photosInPlace:self.flickrLocation maxResults:20]];
        } else
        {
            photosFound = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = currentButton;
            self.flickrList = photosFound;
        });
    });
    dispatch_release(placePhotosQueue);
    
    // Set the title of this viewcontroller
    NSString *placeName = [self.flickrLocation valueForKey:FLICKR_PLACE_NAME];
    self.title = [placeName substringToIndex:[placeName rangeOfString:@","].location];
}

- (IBAction)refresh:(id)sender 
{
    if (self.flickrLocation) {
        [self refresh];
    }
}

@end
