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

- (NSArray *)getPhotoList
{
    NSArray *photosFound = [FlickrFetcher photosInPlace:self.place maxResults:10];
    return [photosFound copy];
}

- (void)refresh 
{
    NSArray *photosFound = [self getPhotoList];
    self.flickrPhotos = photosFound;

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
