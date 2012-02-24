//
//  TopPlacesVacationItineraryTableViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 23/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesVacationItineraryTableViewController.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "Place.h"


@implementation TopPlacesVacationItineraryTableViewController

@synthesize vacation = _vacation;

- (void) setupFetchedResultsController
{
    // fetch all the PLACES in this vacation !!!!
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    // no predicate required: all required
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    fetch.sortDescriptors = [NSArray arrayWithObject:descriptor];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetch managedObjectContext:self.vacation.managedObjectContext sectionNameKeyPath:nil cacheName:nil]; 
}

- (void) fetchFlickrDataIntoDocument:(UIManagedDocument *)document
{
    // we have a bootstrap problem here
    // what happens when we have no vacation yet?
    // TBD add the spinner here as it it is pretty busy.
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        [document.managedObjectContext performBlock:^{
            // to bootstrap take the most popular places
            NSArray *places = [FlickrFetcher topPlaces];
            NSArray *photos = [FlickrFetcher photosInPlace:[places objectAtIndex:6] maxResults:20];
            
            // create objects in documents context
            for (NSDictionary *photo in photos) {
                
                NSLog(@"Photo %@",[photo description]);
                
                [Photo photoWithFlickrDictionary:photo inManagedObjectContext:document.managedObjectContext];                
            }
        }];
    });
    dispatch_release(fetchQ);
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.vacation.fileURL path]]) {
        [self.vacation saveToURL:self.vacation.fileURL
                forSaveOperation:UIDocumentSaveForCreating 
               completionHandler:^(BOOL success) { 
                   // if the file does not exits fill it
                   [self fetchFlickrDataIntoDocument:self.vacation];
                   [self setupFetchedResultsController];
               }];
    }
    else if (self.vacation.documentState == UIDocumentStateClosed)
    {
        [self.vacation openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
            
        }];
    }
    else if (self.vacation.documentState == UIDocumentStateNormal)
    {
        [self setupFetchedResultsController];
    }
}

- (void)setVacation:(UIManagedDocument *)vacation
{
    if (vacation != _vacation) {
        _vacation = vacation;
        [self useDocument];
    } 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Itinerary Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [place.hasPhotos count]];
    
    return cell;
}

@end
