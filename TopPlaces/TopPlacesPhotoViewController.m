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
#import "Vacation.h"
#import "Singleton.h"

// The UIScrollViewDelegate is needed to tell the world that this class 
// will implement viewForZoomingInScrollView
@interface TopPlacesPhotoViewController() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) NSString *photoTitle;
@property (strong, nonatomic) TopPlacesPhotoCache *cache;
@property (strong, nonatomic) NSURL *selectedPhotoUrl;
@property BOOL photoExistsInVacation;
@property (nonatomic, strong) Vacation *vacation;

@end

@implementation TopPlacesPhotoViewController
 // private variables
@synthesize photoScrollView = _photoScrollView;
@synthesize photoImageView = _photoImageView;
@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize photoTitle = _photoTitle;
@synthesize cache = _cache;
@synthesize selectedPhotoUrl = _selectedPhotoUrl;
@synthesize photoExistsInVacation = _photoExistsInVacation;
// public variables
@synthesize vacation = _vacation;
@synthesize flickrPhoto = _flickrPhoto;
@synthesize photo = _photo;

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
    
    // title for the iPad (WHY DOES THIS WORK FOR THE IPOD?)
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    // assume we use the button before the last
    UIBarButtonItem *titleButton = [toolbarItems objectAtIndex:1];
    titleButton.title = _photoTitle;
    self.toolbarItems = toolbarItems;
    // title for the iPhone
    self.title = _photoTitle;
}
   
- (void)updateVisitButtonTitle {
    //	NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    //	UIBarButtonItem *vacationButton = [toolbarItems objectAtIndex:2];
    UIBarButtonItem *vacationButton = [self.navigationItem rightBarButtonItem];
    
	// if there is a vacation defined?
	if (self.vacation)
        // is the photo in this vacation?
        if (self.photoExistsInVacation) 
            vacationButton.title = @"Unvisit";
        else 
            vacationButton.title = @"Visit";
    //no vacation yet, so might be possible to visit place
    else 
        vacationButton.title = @"Visit";
    
    //	self.toolbarItems = toolbarItems; 
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
            else self.photoTitle = @"no photo in cache";
        }
        else {
            UIBarButtonItem *lastButton;
            NSMutableArray *toolbarItems;
            // do we have a toolbar available?
            if (self.toolbar) {                                                         // the iPad has a toolbar
                toolbarItems = [self.toolbar.items mutableCopy];
                lastButton = [toolbarItems lastObject];
            } 
            else if (self.navigationItem)                                                                  // the iPod has a navigationbar
            {
                lastButton = [self.navigationItem rightBarButtonItem];
            }

            // get the current toolbar items
            // only retrieve another photo when the first is done loading (or is not in the cache)
            // not sure whether this is the right choice
            if (!([lastButton.customView isKindOfClass:[UIActivityIndicatorView class]])) {
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                UIBarButtonItem *spinnerButton = [[UIBarButtonItem alloc] initWithCustomView:spinner];
                
                // do we have a toolbar available?
                if (self.toolbar) {                                                         // the iPad has a toolbar
                    [toolbarItems addObject:spinnerButton];
                    self.toolbar.items = toolbarItems;
                } 
                else if (self.navigationItem)                                                                  // the iPod has a navigationbar
                {
                    self.navigationItem.rightBarButtonItem = spinnerButton;
                }

                
                dispatch_queue_t downloadQueue = dispatch_queue_create("download queue", NULL);
                dispatch_async(downloadQueue, ^{

                    // NSLog(@"Photo url found %@", self.selectedPhotoUrl);
                    NSData *photoData = [[NSData alloc] initWithContentsOfURL:self.selectedPhotoUrl];
                    
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
                        
                        // do we have a toolbar available?
                        if (self.toolbar) {                                                         // the iPad has a toolbar
                            [toolbarItems removeLastObject];                        // reset the toolbar as the file has been retrieved
                            self.toolbar.items = toolbarItems;
                        } 
                        else if (self.navigationItem)                                                                  // the iPod has a navigationbar
                        {
                            self.navigationItem.rightBarButtonItem = lastButton;
                        }
                        [self updateVisitButtonTitle];

                    });
                });
                dispatch_release(downloadQueue);
            }
        }
        
    } 
    else 
    {
        self.photoTitle = @"no photo id yet";                // just a fail safe
    }
}


// I must keep photo and flickrPhoto synchronised.
- (void)setPhoto:(NSDictionary *)photo {
    if (photo != _photo) {
        _photo = photo;
        NSLog(@"photo in viewer %@", [photo description]);
    }
}
- (NSDictionary *)photo
{
	if (!_photo)
		_photo = [self.flickrPhoto flickrDictionary];
	return _photo;
}
- (void)setFLickrPhoto:(FlickrPhoto *)flickrPhoto {
    if (flickrPhoto != _flickrPhoto) {
        _flickrPhoto = flickrPhoto;
    }
}
- (FlickrPhoto *)flickrPhoto
{
	if (!_flickrPhoto)
		_flickrPhoto = [FlickrPhoto initWithFlickr:self.photo];
	return _flickrPhoto;
}
- (NSURL *)selectedPhotoUrl
{
	// do we have the url already?
	if (self.flickrPhoto.urlLarge)
		_selectedPhotoUrl = self.flickrPhoto.urlLarge;
	else
		_selectedPhotoUrl = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
	return _selectedPhotoUrl;
}

- (Vacation *)vacation
{
    if (!_vacation) {
        SingletonClass *sharedManager = [SingletonClass sharedManager];
        _vacation = sharedManager.currentVacation;
    }
    return _vacation;
}

- (void)setVacation:(Vacation *)vacation
{
    // has the vacation been changed?
	if (vacation != _vacation) {
		_vacation = vacation;
        self.photoExistsInVacation = [self.vacation has:self.photo];
        // adapt the button title
        [self updateVisitButtonTitle];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.photoScrollView.delegate = self;
    // if I have a photo defined, retrieve it.
    if (self.photo) 
        [self retrievePhoto];
    if (self.vacation)
        self.photoExistsInVacation = [self.vacation has:self.photo];
        else
            self.photoExistsInVacation = NO;
    // set the button title
    [self updateVisitButtonTitle];
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) {
            [toolbarItems removeObject:_splitViewBarButtonItem];
        }
        if (splitViewBarButtonItem)
            [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (YES);
}

- (IBAction)vacationButtonPressed:(id)sender {
    // do I have a vacation?
    if (!self.vacation)
        [self performSegueWithIdentifier:@"Vacations List" sender:self];
    else
        if (self.photoExistsInVacation) {
            [self.vacation remove:self.photo];
            self.photoExistsInVacation = NO;
        }
        else {
            [self.vacation add:self.photo];
            self.photoExistsInVacation = YES;
        }
    [self updateVisitButtonTitle];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Vacations List"]) {
        // set the delegate
        [segue.destinationViewController setDelegate:self];
    }
}

// this is a delegate method for the VacationListModalTableViewController
// and is used to pass a selected vacation on to this one
// 
- (void)TopPlacesVacationsModalTableViewController:(TopPlacesVacationsModalTableViewController *)sender vacationHasBeenChosen:(BOOL)chosen
{
	// dismiss the controller
    [self dismissModalViewControllerAnimated:YES];
	// is there still somebody to give this to?
	// can make it void as well!!!
    // now that we have a vacation we can add the photo
    if (!self.photoExistsInVacation) {
        [self.vacation add:self.photo];
        // check if it really is available now
        self.photoExistsInVacation = [self.vacation has:self.photo];
        [self updateVisitButtonTitle];
    }
    else
        // do nothing as it does not match the title of the button
        ;
}

- (void)viewDidUnload {
    [self setPhotoImageView:nil];
    [self setPhotoScrollView:nil];
    [self setToolbar:nil];
    [super viewDidUnload];
}

@end
