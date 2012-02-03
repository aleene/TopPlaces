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

@interface TopPlacesPhotosTableViewController()

@property (nonatomic, strong) NSDictionary *selectedFlickrPhoto;
@property (nonatomic, strong) NSArray *flickrPhotos;

@end
@implementation TopPlacesPhotosTableViewController

@synthesize flickrPhotos = _flickrPhotos;
@synthesize selectedFlickrPhoto = _selectedFlickrPhoto;

- (void)refresh
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    UIBarButtonItem *currentButton = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    NSArray *photosFound = [FlickrFetcher recentGeoreferencedPhotos];
    if (!photosFound) {
        UIAlertView *noImagesAlertView = [[UIAlertView alloc] initWithTitle:@"No Images" message:@"Trouble getting images from Flickr" delegate:nil cancelButtonTitle:@"To bad" otherButtonTitles:nil];
        [noImagesAlertView show];
    }
    self.navigationItem.rightBarButtonItem = currentButton;
    self.flickrPhotos = photosFound;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self refresh];
    
}

- (IBAction)refresh:(id)sender {
    
    [self refresh];
}

- (void)setFlickrPhotos:(NSArray *)flickrPhotos
{
    if (flickrPhotos != _flickrPhotos) {
        _flickrPhotos = flickrPhotos;
        [self.tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Photo from TopPhotos Segue"]) {
        [segue.destinationViewController setPhoto:self.selectedFlickrPhoto];
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
    return [self.flickrPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *photo = [self.flickrPhotos objectAtIndex:indexPath.row];
    NSDictionary *descriptionObject = [photo valueForKey:@"description"];
    NSString *descriptionContent = [descriptionObject valueForKey:@"_content"];
    //    NSLog(@"%@ <> %@", [photo valueForKey:FLICKR_PHOTO_TITLE], descriptionContent);
    // do not know why this does not work
    //    NSLog(@"%@",[photo valueForKey:@"description._content"]);
    if ([[photo valueForKey:FLICKR_PHOTO_TITLE] isEqualToString:@""]) {
        cell.textLabel.text = @"no title available";
    } else {
        cell.textLabel.text = [photo valueForKey:FLICKR_PHOTO_TITLE];
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
    self.SelectedFlickrPhoto = [self.flickrPhotos objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Photo from TopPhotos Segue" sender:self];
    
}

@end
