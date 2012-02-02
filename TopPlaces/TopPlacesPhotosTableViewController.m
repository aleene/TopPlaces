//
//  TopPlacesPhotosTableViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 2/2/12.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesPhotosTableViewController.h"
#import "FlickrFetcher.h"

@implementation TopPlacesPhotosTableViewController

@synthesize flickrPhotos = _flickrPhotos;

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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *photo = [self.flickrPhotos objectAtIndex:indexPath.row];
    cell.textLabel.text = [photo valueForKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKey:FLICKR_PHOTO_OWNER];
    
    return cell;
}

#pragma mark - Table view delegate
            
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
