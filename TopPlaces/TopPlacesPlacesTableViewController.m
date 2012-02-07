//
//  TopPlacesPlacesTableViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 2/2/12.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesPlacesTableViewController.h"


#import "FlickrFetcher.h"
#import "TopPlacesPhotosForPlaceTableViewController.h"

@interface TopPlacesPlacesTableViewController()

@property (nonatomic, strong) NSDictionary *selectedFlickrPlace;

@end

@implementation TopPlacesPlacesTableViewController

@synthesize places = _places;
@synthesize selectedFlickrPlace = _selectedFlickrPlace;

- (void)refresh
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    UIBarButtonItem *currentButton = self.navigationItem.rightBarButtonItem;
    UIBarButtonItem *testButton = [[UIBarButtonItem alloc] init];
    testButton.title = @"test";
//    self.navigationItem.rightBarButtonItem = ;
    self.navigationItem.rightBarButtonItem = testButton;
    // probleem is dat er niets aan de presentatie veranderd
    // kan de button zelfs niet verwijderen
    // de inhoud van de buttons klopt
    // aan het eind van deze method is inderdaad wel de button verwijderd
    // de vraag wordt dus waar ik dit moet aanpassen 
    
    
    NSArray *places = [FlickrFetcher topPlaces];
    if (!places) {
        UIAlertView *noImagesAlertView = [[UIAlertView alloc] initWithTitle:@"No Images" 
                                                                    message:@"Trouble getting images from Flickr" 
                                                                   delegate:nil cancelButtonTitle:@"To bad" 
                                                          otherButtonTitles:nil];
        [noImagesAlertView show];
    }
    self.navigationItem.rightBarButtonItem = currentButton;
    self.places = places;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self refresh];
    
}

- (IBAction)refresh:(id)sender
{
    [self refresh];
}


- (void) setPlaces:(NSArray *)places
{
    if (places != _places) {
        _places = places;
        if (self.tableView.window)[self.tableView reloadData]; 
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photos For Place"]) {
        [segue.destinationViewController setPlace:self.selectedFlickrPlace];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *place = [self.places objectAtIndex:indexPath.row];
    NSString *fullPlaceName = [place objectForKey:FLICKR_PLACE_NAME];
    NSRange positionOfFirstComma = [fullPlaceName rangeOfString:@","];
    cell.textLabel.text = [fullPlaceName substringToIndex:positionOfFirstComma.location];
//    NSString *numberOfPhotosAtPlace = [place objectForKey:FLICKR_PLACE_COUNT];
    cell.detailTextLabel.text = [fullPlaceName substringFromIndex:positionOfFirstComma.location + 2];;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedFlickrPlace = [self.places objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Show Photos For Place" sender:self];
}

@end
