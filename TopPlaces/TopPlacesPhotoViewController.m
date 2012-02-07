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
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) NSString *photoTitle;

@end

@implementation TopPlacesPhotoViewController
 
@synthesize photoScrollView = _photoScrollView;
@synthesize photoImageView = _photoImageView;
@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize photoTitle = _photoTitle;

@synthesize photo = _photo;

// instruction from lecture 8
// set the image that needs to be scrolled by the scrollview
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoImageView;
}

- (void)setPhotoTitle:(NSString *)photoTitle
{
    if ([photoTitle isEqualToString:@""])
        _photoTitle = @"no photo description";
    else
        _photoTitle = photoTitle;
    
    // title for the iPad
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    NSLog(@"%i", [toolbarItems count]);
    // assume we use the button before the last
    UIBarButtonItem *titleButton = [toolbarItems objectAtIndex:[toolbarItems count]-2];
    titleButton.title = _photoTitle;
    // title for the iPhone
    self.title = _photoTitle;
}
   
- (void)retrievePhoto {
    if (self.photo) {
        NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
        NSData *photoData = [[NSData alloc] initWithContentsOfURL:photoURL];
        if (photoData) {
            UIImage *image = [[UIImage alloc] initWithData:photoData];
            [self.photoImageView setImage:image];
            
            // Assignment 4 - task 7
            self.photoTitle = [self.photo valueForKey:FLICKR_PHOTO_TITLE];
            // instructions from lecture 8
            self.photoScrollView.contentSize = self.photoImageView.image.size;
            self.photoImageView.frame = CGRectMake(0, 0, self.photoImageView.image.size.width, self.photoImageView.image.size.height);
        } else {
            self.photoTitle = @"no photo retrieved";
        }

    } else {
        self.photoTitle = @"no photo selected";
    }
}

//  This one was added for the iPad splitview
//  It needs displaying the image again if the photo is changed
- (void)setPhoto:(NSDictionary *)photo {
    if (photo != _photo) {
        _photo = photo;
        [self retrievePhoto];
        // do I have a mixup with vieeDidLoad here?
     //   [self.photoImageView setNeedsDisplay];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // instruction from lecture 8
    self.photoScrollView.delegate = self;
    self.photoImageView.contentMode = UIViewContentModeScaleToFill;

    // get the actual photo now that the view is loading
    [self retrievePhoto];
    
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) {
            [toolbarItems removeObject:_splitViewBarButtonItem];
        }
        if (splitViewBarButtonItem) {
            [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        }
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (YES);
}

- (void)viewDidUnload {
    [self setPhotoImageView:nil];
    [self setPhotoScrollView:nil];
    [self setToolbar:nil];
    [super viewDidUnload];
}
@end
