//
//  TopPlacesPhotosForPlaceTableViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 2/2/12.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesPhotosForPlaceTableViewController.h"
#import "FlickrFetcher.h"
#import "TopPlacesPhotoViewController.h"
#import "TopPlacesPhotosTableViewController.h"

@implementation TopPlacesPhotosForPlaceTableViewController

@synthesize place = _place;

- (void)refresh 
{    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    UIBarButtonItem *currentButton = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];

    dispatch_queue_t downloadQueue = dispatch_queue_create("download queue", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *photosFound = [FlickrFetcher photosInPlace:self.place maxResults:10];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.flickrPhotos = photosFound;
        });
    });
    dispatch_release(downloadQueue);
    
    self.navigationItem.rightBarButtonItem = currentButton;
    // Set the title of this viewcontroller
    NSString *placeName = [self.place valueForKey:FLICKR_PLACE_NAME];
    self.title = [placeName substringToIndex:[placeName rangeOfString:@","].location];
}

- (IBAction)refresh:(id)sender 
{
    if (self.place) {
        [self refresh];
    }
}


- (void)setPlace:(NSDictionary *)place
{
    if (place != _place) {
        _place = place;
        [self refresh];
    }
}

@end
