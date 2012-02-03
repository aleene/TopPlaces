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


@end
@implementation TopPlacesPhotosTableViewController

@synthesize flickrPhotos = _flickrPhotos;
@synthesize selectedFlickrPhoto = _selectedFlickrPhoto;

- (IBAction)refresh:(id)sender {
    
    NSArray *photosFound = [FlickrFetcher recentGeoreferencedPhotos];
    self.flickrPhotos = photosFound;
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
    cell.textLabel.text = [photo valueForKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKey:FLICKR_PLACE_NAME];
    
    return cell;
}

#pragma mark - Table view delegate
            
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.SelectedFlickrPhoto = [self.flickrPhotos objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Photo from TopPhotos Segue" sender:self];
    
}

@end
