//
//  TopPlacesPhotosMap.m
//  TopPlaces
//
//  Created by Arnaud Leene on 16/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesPhotosMap.h"
#import "FlickrFetcher.h"
#import "TopPlacesPhotosForPlaceTableViewController.h"

@implementation TopPlacesPhotosMap

@synthesize photos = _photos;
@synthesize photosMapView = _photosMapView;
@synthesize place = _place;

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
        if (self.place) {
            photosFound = [photosFound initWithArray:[FlickrFetcher photosInPlace:self.place maxResults:20]];
        } else
        {
            photosFound = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = currentButton;
            self.photos = photosFound;
        });
    });
    dispatch_release(placePhotosQueue);
    
    // Set the title of this viewcontroller
    NSString *placeName = [self.place valueForKey:FLICKR_PLACE_NAME];
    self.title = [placeName substringToIndex:[placeName rangeOfString:@","].location];
}

- (IBAction)refresh:(id)sender {
    if (self.place) {
//        [self refresh];
    }
}

- (void)viewDidUnload
{
    [self setPhotosMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (YES);
}

@end
