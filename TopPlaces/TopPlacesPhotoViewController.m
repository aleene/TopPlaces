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
    
    // instructions from lecture 8
    self.photoScrollView.contentSize = self.photoImageView.image.size;
    self.photoImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // instruction from lecture 8
    self.photoScrollView.delegate = self;
    
    // get the actual photo now that the view is loading
    [self retrievePhoto];
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
