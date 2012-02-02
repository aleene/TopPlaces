//
//  TopPlacesPlacesTableViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 2/2/12.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesPlacesTableViewController.h"
#import "FlickrFetcher.h"

@implementation TopPlacesPlacesTableViewController

@synthesize places = _places;

- (IBAction)refresh:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    NSArray *places = [FlickrFetcher topPlaces];
    if (!places) {
        UIAlertView *noImagesAlertView = [[UIAlertView alloc] initWithTitle:@"No Images" message:@"Trouble getting images from Flickr" delegate:nil cancelButtonTitle:@"To bad" otherButtonTitles:nil];
        [noImagesAlertView show];
    }
    self.navigationItem.rightBarButtonItem = sender;
    self.places = places;
}

- (void) setPlaces:(NSArray *)places
{
    if (places != _places) {
        _places = places;
        if (self.tableView.window)[self.tableView reloadData]; 
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
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Places Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *place = [self.places objectAtIndex:indexPath.row];
    cell.textLabel.text = [place objectForKey:FLICKR_PLACE_NAME];
    NSString *numberOfPhotosAtPlace = [place objectForKey:FLICKR_PLACE_COUNT];
    cell.detailTextLabel.text = [numberOfPhotosAtPlace stringByAppendingString:@" photos available"];
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
