//
//  TopPlacesVacationSingleTableViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 23/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesVacationSingleTableViewController.h"
#import "FlickrFetcher.h"

@implementation TopPlacesVacationSingleTableViewController

@synthesize vacation = _vacation;

#pragma mark - Table view data source

- (void) setupFetchedResultsController
{
    
}

- (void) fetchFlickrDataIntoDocument:(UIManagedDocument *)document
{
    // we have a bootstrap problem here
    // what happens when we have no vacation yet?
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        [document.managedObjectContext performBlock:^{
        NSArray *photos = [FlickrFetcher recentGeoreferencedPhotos];
        // create objects in documents context
            for (NSDictionary *photo in photos) {
                //...
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
                   [self setupFetchedResultsController];
                   [self fetchFlickrDataIntoDocument:self.vacation];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0 :
            cell.textLabel.text = @"Itinerary";
            break;
        case 1 :
            cell.textLabel.text = @"Tags";
            break;
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
