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

- (NSString *)viewControllerTitle
{
    NSString *title;
    // Set the title of this viewcontroller
    if (self.flickrLocation) {
    NSString *placeName = [self.flickrLocation valueForKey:FLICKR_PLACE_NAME];
    title = [placeName substringToIndex:[placeName rangeOfString:@","].location];
    }
    else
        title = @"No placename";
    
    return title;
}

- (NSArray *)getFlickrArray
{
    NSLog(@"flickerLocation %@", [self.flickrLocation description]);
    return [FlickrFetcher photosInPlace:self.flickrLocation maxResults:20];
}


// this one is exact the same as its parent!!!!

- (void)refresh 
{    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    UIBarButtonItem *spinnerButton = [[UIBarButtonItem alloc] initWithCustomView:spinner];

    UIBarButtonItem *currentButton = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = spinnerButton;

    dispatch_queue_t placePhotosQueue = dispatch_queue_create("place photos queue", NULL);
    dispatch_async(placePhotosQueue, ^{
        
        NSArray *photosFound = [self getFlickrArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!photosFound) {
                UIAlertView *noImagesAlertView = [[UIAlertView alloc] initWithTitle:@"No Flickr" 
                                                                            message:@"Trouble getting info from Flickr" 
                                                                           delegate:nil 
                                                                  cancelButtonTitle:@"To bad" 
                                                                  otherButtonTitles:nil];
                [noImagesAlertView show];
            }

            self.navigationItem.rightBarButtonItem = currentButton;
            self.flickrList = photosFound;
        });
    });
    dispatch_release(placePhotosQueue);
    self.navigationItem.title = [self viewControllerTitle];
}
 

- (IBAction)refresh:(id)sender 
{
    if (self.flickrLocation) {
        [self refresh];
    }
}


@end
