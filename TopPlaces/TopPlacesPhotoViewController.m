//
//  TopPlacesPhotoViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 3/2/12.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesPhotoViewController.h"
#import "FlickrFetcher.h"

// The UIScrollViewDelegate is needed to tell the world that this class 
// will implement viewForZoomingInScrollView
@interface TopPlacesPhotoViewController() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation TopPlacesPhotoViewController
 
@synthesize photoScrollView = _photoScrollView;
@synthesize photoImageView = _photoImageView;

@synthesize photo = _photo;

// instruction from lecture 8
// set the image that needs to be scrolled by the scrollview
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoImageView;
}
   
- (void)retrievePhoto {
    NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
    NSData *photoData = [[NSData alloc] initWithContentsOfURL:photoURL];
    UIImage *image = [[UIImage alloc] initWithData:photoData];
    [self.photoImageView setImage:image];
//    NSLog(@"%f %f", image.size.width, image.size.height);
    
}

#define MAX_TITLE_LENGTH 10
- (void)viewDidLoad
{
    [super viewDidLoad];
    // instruction from lecture 8
    self.photoScrollView.delegate = self;
    self.photoImageView.contentMode = UIViewContentModeScaleToFill;

    // get the actual photo now that the view is loading
    [self retrievePhoto];
    
    //  Set the title of the viewcontroller
    // Assignment 4 - task 7
    NSString *photoTitle = [self.photo valueForKey:FLICKR_PHOTO_TITLE];
    // the maximum length of this title depends on the view orientation
    self.title = [[photoTitle substringToIndex:MAX_TITLE_LENGTH] stringByAppendingString:@"..."]; 
    
    // instructions from lecture 8
    self.photoScrollView.contentSize = self.photoImageView.image.size;
    self.photoImageView.frame = CGRectMake(0, 0, self.photoImageView.image.size.width, self.photoImageView.image.size.height);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (YES);
}

- (void)viewDidUnload {
    [self setPhotoImageView:nil];
    [self setPhotoScrollView:nil];
    [super viewDidUnload];
}
@end
