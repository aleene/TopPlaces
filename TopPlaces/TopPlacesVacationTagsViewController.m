//
//  TopPlacesVacationTagsViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 24/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesVacationTagsViewController.h"
#import "Tag.h"
#import "Photo+Flickr.h"
#import "FlickrFetcher.h"

@interface TopPlacesVacationTagsViewController()

@property (nonatomic, strong) Tag *selectedTag;

@end

@implementation TopPlacesVacationTagsViewController

@synthesize vacation = _vacation;
@synthesize selectedTag = _selectedTag;

- (void) setupFetchedResultsController
{
    self.debug = YES;
    // fetch all the Tags in this vacation !!!!
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    // no predicate required: all required
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
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
                
                // NSLog(@"Photo %@",[photo description]);
                
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
    static NSString *CellIdentifier = @"Tag Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tag.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [tag.hasPhotos count]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // the user selected a place he wants to visits
    self.selectedTag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"Tag Photos" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Tag Photos"]) {
        [segue.destinationViewController setVacation:self.vacation];
        [segue.destinationViewController setSelectedTag:self.selectedTag];
    }
}

@end
