//
//  TopPlacesPhotoViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 3/2/12.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesPhotoViewController.h"
#import "TopPlacesPhotoCache.h"
#import "FlickrFetcher.h"

// The UIScrollViewDelegate is needed to tell the world that this class 
// will implement viewForZoomingInScrollView
@interface TopPlacesPhotoViewController() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) NSString *photoTitle;
@property (strong, nonatomic) TopPlacesPhotoCache *cache;

@end

@implementation TopPlacesPhotoViewController
 
@synthesize photoScrollView = _photoScrollView;
@synthesize photoImageView = _photoImageView;
@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize photoTitle = _photoTitle;

@synthesize photo = _photo;
@synthesize cache = _cache;

- (TopPlacesPhotoCache *)cache {
    if (!_cache) {
        _cache = [[TopPlacesPhotoCache alloc] init];
    }
    return _cache;
}

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
    // assume we use the button before the last
    UIBarButtonItem *titleButton = [toolbarItems objectAtIndex:[toolbarItems count]-2];
    titleButton.title = _photoTitle;
    // title for the iPhone
    self.title = _photoTitle;
}
   
- (void)retrievePhoto {
    if (self.photo) {
        if ([self.cache contains:self.photo]) {
            NSData *photoData = [self.cache retrieve:self.photo];
            if (photoData) {
                UIImage *image = [[UIImage alloc] initWithData:photoData];
                [self.photoImageView setImage:image];
                // reset zoom and contentMode when loading a new photo
                self.photoScrollView.zoomScale = 1.0;
                self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
                self.photoScrollView.contentMode = UIViewContentModeScaleAspectFit;
                self.photoTitle = [self.photo valueForKey:FLICKR_PHOTO_TITLE];
            } 
            else self.photoTitle = @"no photo retrieved";
        }
        else {
            // get the current toolbar items
            NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
            UIBarButtonItem *lastButton = [toolbarItems lastObject];
            // only retrieve another photo when the first is done loading (or is not in the cache)
            // not sure whether this is the right choice
            if (!([lastButton.customView isKindOfClass:[UIActivityIndicatorView class]])) {
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                UIBarButtonItem *spinnerButton = [[UIBarButtonItem alloc] initWithCustomView:spinner];
                
                [toolbarItems addObject:spinnerButton];
                self.toolbar.items = toolbarItems;
                
                dispatch_queue_t downloadQueue = dispatch_queue_create("download queue", NULL);
                dispatch_async(downloadQueue, ^{
                    NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
                    NSData *photoData = [[NSData alloc] initWithContentsOfURL:photoURL];
                    
                    dispatch_queue_t writeQueue = dispatch_queue_create("cache photo", NULL);       // do the caching in a separate thread
                    dispatch_async(writeQueue, ^{
                        [self.cache put:photoData for:self.photo];   
                    });
                    dispatch_release(writeQueue);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (photoData) {
                            UIImage *image = [[UIImage alloc] initWithData:photoData];
                            [self.photoImageView setImage:image];
                            // reset zoom and contentMode when loading a new photo
                            self.photoScrollView.zoomScale = 1.0;
                            self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
                            self.photoScrollView.contentMode = UIViewContentModeScaleAspectFit;
                            
                            self.photoTitle = [self.photo valueForKey:FLICKR_PHOTO_TITLE];
                        } 
                        else self.photoTitle = @"no photo retrieved";                // just a fail safe
                        
                        [toolbarItems removeLastObject];                        // reset the toolbar as the file has been retrieved
                        self.toolbar.items = toolbarItems;
                    });
                });
                dispatch_release(downloadQueue);
            }
        }
        
    } 
    else self.photoTitle = @"no photo selected";                // just a fail safe
}

//  This one was added for the iPad splitview
//  It needs displaying the image again if the photo is changed
- (void)setPhoto:(NSDictionary *)photo {
    if (photo != _photo) {
        _photo = photo;
        [self retrievePhoto];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // instruction from lecture 8
    self.photoScrollView.delegate = self;
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
