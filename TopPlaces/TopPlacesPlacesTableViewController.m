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
#import "TopPlacesPhotoMapViewController.h"
#import "FlickrPhotoAnnotation.h"

@interface TopPlacesPlacesTableViewController()

@property (nonatomic, strong) NSDictionary *selectedFlickrPlace;
@property (nonatomic, strong) NSMutableArray *countries;
@property (nonatomic, strong) NSArray *places;

@end

@implementation TopPlacesPlacesTableViewController

@synthesize places = _places;
@synthesize selectedFlickrPlace = _selectedFlickrPlace;
@synthesize countries = _countries;

- (NSMutableArray *)countries
{
    if (!_countries) {
        _countries = [[NSMutableArray alloc] init];
    }
    return _countries;
}

- (NSArray *)placeNameParts:(NSString *)place
{
    // extract the place name parts
    NSMutableArray *placeName = [[NSMutableArray alloc] initWithArray:[place componentsSeparatedByString:@","]];
    if ([[placeName objectAtIndex:0] isEqualToString:@""]) {
        [placeName addObject:@"Unknown country"];
    }
    return [placeName copy];
}

- (void)refresh
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    UIBarButtonItem *currentButton = self.navigationItem.rightBarButtonItem;
    UIBarButtonItem *testButton = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    self.navigationItem.rightBarButtonItem = testButton;

    // get rid of the previous country list
    [self.countries removeAllObjects];
    
    // get the top places from flickr
    dispatch_queue_t topPlacesQueue = dispatch_queue_create("topplaces queue", NULL);
    dispatch_async(topPlacesQueue, ^{
        NSArray *places = [FlickrFetcher topPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
            // did we get something back from Flickr?
            if (!places) {
                UIAlertView *noImagesAlertView = [[UIAlertView alloc] initWithTitle:@"No Images" 
                                                                            message:@"Trouble getting images from Flickr" 
                                                                           delegate:nil 
                                                                  cancelButtonTitle:@"To bad" 
                                                                  otherButtonTitles:nil];
                [noImagesAlertView show];
            }
            
            // I have to calculate the number of sections in this places array
            // And assign each place to a section
            // each ection will be a country
            // create a multable dictionary to store countries.
            NSMutableDictionary *countriesDict = [[NSMutableDictionary alloc] init];
            // each country will contain a dictionary with an array with places
            // loop over all places in the array
            for (NSDictionary *place in places) {
                // cut the place name in its parts
                NSArray *placeName = [self placeNameParts:[place objectForKey:FLICKR_PLACE_NAME]];
                
                // is this country already in the Array?
                if ([countriesDict objectForKey:[placeName lastObject]]) {
                    // get the array with places for this country
                    NSMutableArray *placesInCountry = [countriesDict valueForKey:[placeName lastObject]];
                    // add the current place to the placesInCountry array
                    [placesInCountry addObject:place];
                }
                // this country is not yet in the dictionary
                else {
                    // create a new array for this country with this place as a start
                    NSMutableArray *placesInCountry = [[NSMutableArray alloc] initWithObjects:place, nil];
                    // add this array to the country dictionary
                    [countriesDict setValue:placesInCountry forKey:[placeName lastObject]];
                }
            }    ;    
            
            // now convert from the dictionary of countries to a sorted array of countries
            NSArray *sortedKeys = [[NSArray alloc] initWithArray:[countriesDict allKeys]];  // get the countries
            sortedKeys = [sortedKeys sortedArrayUsingSelector:@selector(compare:)];         // sort the countries
            
            for(NSString *key in sortedKeys) {                                              // loop over all countries
                NSArray *placesInCountry = [countriesDict valueForKey:key];
                [self.countries addObject:placesInCountry];                                 // create the places in the array
            }
            
            // put the previous button back
            self.navigationItem.rightBarButtonItem = currentButton;
            self.places = places;
            NSLog(@"Number of countries found: %i", [self.places count]);
        });
    });
    dispatch_release(topPlacesQueue);

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

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc]initWithCapacity:[self.places count]]; 
    for (NSDictionary *place in self.places) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:place]];
    }
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photos For Place"]) {
        [segue.destinationViewController setFlickrLocation:self.selectedFlickrPlace];
    }
    else if ([segue.identifier isEqualToString:@"Map From Places"])
    {
        [segue.destinationViewController setAnnotations:[self mapAnnotations]];
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
    NSSet *placesInCountry = [self.countries objectAtIndex:section];
    return [placesInCountry count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.countries count];
}   

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *country = [self.countries objectAtIndex:section];
    NSDictionary *firstPlace = [country objectAtIndex:0];
    NSArray *placeNameParts = [self placeNameParts:[firstPlace objectForKey:FLICKR_PLACE_NAME]];
    return [placeNameParts lastObject];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Places Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    NSArray *country = [self.countries objectAtIndex:indexPath.section];
    NSDictionary *place = [country objectAtIndex:indexPath.row];
    NSArray *placeNameParts = [self placeNameParts:[place objectForKey:FLICKR_PLACE_NAME]];
    
    cell.textLabel.text = [placeNameParts objectAtIndex:0];
//    NSString *numberOfPhotosAtPlace = [place objectForKey:FLICKR_PLACE_COUNT];
    
    cell.detailTextLabel.text = [placeNameParts objectAtIndex:1];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *country = [self.countries objectAtIndex:indexPath.section];
    self.selectedFlickrPlace = [country objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Show Photos For Place" sender:self];
}

@end
