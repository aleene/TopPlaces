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

@interface TopPlacesPhotosForPlaceTableViewController() <MapViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *photo;
@end

@implementation TopPlacesPhotosForPlaceTableViewController

@synthesize place = _place;
@synthesize photo = _photo;

// why do I need to copy this from the parent class?

//  is a detail view controller available?
//  and is it a detail view controller that can present a photo?
- (TopPlacesPhotoViewController *)splitViewTopPlacesPhotoViewController {
    id gvc = [self.splitViewController.viewControllers lastObject];
    if (![gvc isKindOfClass:[TopPlacesPhotoViewController class]]) {
        gvc = nil;
    }
    return gvc; 
}

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
            self.flickrPhotos = photosFound;
        });
    });
    dispatch_release(placePhotosQueue);
    
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

- (IBAction)showAsMapPressed
{
    [self performSegueWithIdentifier:@"Show As Map" sender:self];  // go to the corresponding scene

}

- (UIImage *)topPlacesPhotoMapViewController:(TopPlacesPhotoMapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation  
{
    FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data ? [UIImage imageWithData:data] : nil;
}

- (void)topPlacesPhotoMapViewController:(TopPlacesPhotoMapViewController *)sender showImageForAnnotation:(id <MKAnnotation>)annotation
{
    FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
    self.photo = fpa.photo;
    if ([self splitViewTopPlacesPhotoViewController]) {
        [[self splitViewTopPlacesPhotoViewController] setPhoto:self.photo];
    } else {
        [self performSegueWithIdentifier:@"Show Photo Segue" sender:self];
    }
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc]initWithCapacity:[self.flickrPhotos count]]; 
    for (NSDictionary *photo in self.flickrPhotos) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show As Map"]) {
        // I pass the list of photos I retrieved already, so I do not need to reload it.
        [segue.destinationViewController setAnnotations:[self mapAnnotations]];
        [segue.destinationViewController setDelegate:self];
    } else if ([segue.identifier isEqualToString:@"Show Photo Segue"]) {
// need to call the super method as that is where the corresponding table thing is.
        [super prepareForSegue:segue sender:sender];
    }

}


- (void)setPlace:(NSDictionary *)place
{
    if (place != _place) {
        _place = place;
    }
}

@end
