//
//  TopPlacesPhotosTableViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 2/2/12.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesPhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "TopPlacesPhotoViewController.h"
#import "FlickrPhotoAnnotation.h"
#import "TopPlacesPhotoMapViewController.h"

@interface TopPlacesPhotosTableViewController() <MapViewControllerDelegate>

@end
@implementation TopPlacesPhotosTableViewController

@synthesize flickrList = _flickrList;
@synthesize flickrLocation = _flickrLocation; // can be a photo or a location

//  is a detail view controller available?
//  and is it a detail view controller that can present a photo?
- (TopPlacesPhotoViewController *)splitViewTopPlacesPhotoViewController {
    id gvc = [self.splitViewController.viewControllers lastObject];
    if (![gvc isKindOfClass:[TopPlacesPhotoViewController class]]) {
        gvc = nil;
    }
    return gvc; 
}

- (void)setFlickrLocation:(NSDictionary *)flickrLocation
{
    if (flickrLocation != _flickrLocation) {
        _flickrLocation = flickrLocation;
    }
}


- (void)refresh
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    UIBarButtonItem *currentButton = self.navigationItem.rightBarButtonItem;
    UIBarButtonItem *testButton = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    self.navigationItem.rightBarButtonItem = testButton;
    
    dispatch_queue_t topPhotosQueue = dispatch_queue_create("top photos queue", NULL);
    dispatch_async(topPhotosQueue, ^{
        
        NSArray *photosFound = [FlickrFetcher recentGeoreferencedPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!photosFound) {
                UIAlertView *noImagesAlertView = [[UIAlertView alloc] initWithTitle:@"No Flickr" 
                                                                            message:@"Trouble getting info from Flickr" 
                                                                           delegate:nil 
                                                                  cancelButtonTitle:@"To bad" 
                                                                  otherButtonTitles:nil];
                [noImagesAlertView show];
            }
            self.flickrList = photosFound;
            self.navigationItem.rightBarButtonItem = currentButton;
        });
    });
    dispatch_release(topPhotosQueue);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self refresh];
    
}

- (IBAction)refresh:(id)sender {
    
    [self refresh];
}

- (void)setFlickrList:(NSArray *)flickrList
{
    if (flickrList != _flickrList) {
        _flickrList = flickrList;
        [self.tableView reloadData];
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
    self.flickrLocation = fpa.photo;
    if ([self splitViewTopPlacesPhotoViewController]) {
        [[self splitViewTopPlacesPhotoViewController] setPhoto:self.flickrLocation];
    } else {
        [self performSegueWithIdentifier:@"Show Photo Segue" sender:self];
    }
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc]initWithCapacity:[self.flickrList count]]; 
    for (NSDictionary *photo in self.flickrList) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photo Segue"]) {
        [segue.destinationViewController setPhoto:self.flickrLocation];
    }
    else if ([segue.identifier isEqualToString:@"Show As Map"])
    {
        [segue.destinationViewController setAnnotations:[self mapAnnotations]];
        [segue.destinationViewController setDelegate:self];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (YES);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.flickrList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // I do not really want this data here
    NSDictionary *photo = [self.flickrList objectAtIndex:indexPath.row];
    
    NSString *title = [photo valueForKey:FLICKR_PHOTO_TITLE];
    NSString *descriptionContent = [photo valueForKeyPath:@"description._content"];

    if ([title isEqualToString:@""]) {
        cell.textLabel.text = @"no title available";
    } else {
        cell.textLabel.text = title;
    }
    if ([descriptionContent isEqualToString:@""]) {
        cell.detailTextLabel.text = @"no description available";
    } else {
        cell.detailTextLabel.text = descriptionContent;
    }
    
    return cell;
}

#pragma mark - Table view delegate
            
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.flickrLocation = [self.flickrList objectAtIndex:indexPath.row];
    //  check to see whether we are on the iPad or not
    //  and if we can go to the right controller right away (as it is on screen) 
    if ([self splitViewTopPlacesPhotoViewController]) {
        [[self splitViewTopPlacesPhotoViewController] setPhoto:self.flickrLocation];
    } else {
        [self performSegueWithIdentifier:@"Show Photo Segue" sender:self];
    }
}

@end
