//
//  TopPlacesPhotosForPlaceTableViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 2/2/12.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesPhotosForPlaceTableViewController.h"
#import "FlickrFetcher.h"

@interface TopPlacesPhotosForPlaceTableViewController()

@property (nonatomic, strong) NSArray *flickrPhotos;

@end

@implementation TopPlacesPhotosForPlaceTableViewController

@synthesize place = _place;
@synthesize flickrPhotos = _flickrPhotos;

- (void)refresh 
{
    
    NSArray *photosFound = [FlickrFetcher photosInPlace:self.place maxResults:10];
    self.flickrPhotos = photosFound;
}

- (IBAction)refresh:(id)sender 
{
    if (self.place) {
        [self refresh];
    }
}


- (void)setFlickrPhotos:(NSArray *)flickrPhotos
{
    if (flickrPhotos != _flickrPhotos) {
        _flickrPhotos = flickrPhotos;
        [self.tableView reloadData];
    }
}

- (void)setPlace:(NSDictionary *)place
{
    if (place != _place) {
        _place = place;
        [self refresh];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refresh];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.flickrPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotosForPlaceCell";
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
