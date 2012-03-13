//
//  TopPlacesVacationTagPhotosTableViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 26/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesVacationTagPhotosTableViewController.h"
#import "Photo.h"
#import "Photo+Flickr.h"
#import "TopPlacesPhotoViewController.h"

@interface TopPlacesVacationTagPhotosTableViewController()

@property (nonatomic, strong) Photo *selectedPhoto;

@end

@implementation TopPlacesVacationTagPhotosTableViewController

@synthesize vacation = _vacation;
@synthesize selectedTag = _selectedTag;
@synthesize selectedPhoto = _selectedPhoto;

- (void) setupFetchedResultsController
{
    // self.debug = YES;
    // fetch all the photos for this tag !!!!
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    // ik weet de lijst van photo's die opgehaald moeten worden (selectedTag.hasPhotos)
    // selectedTag is een set
    fetch.predicate = [NSPredicate predicateWithFormat:@"self IN %@", self.selectedTag.hasPhotos];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    fetch.sortDescriptors = [NSArray arrayWithObject:descriptor];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetch managedObjectContext:self.vacation.vacationDocument.managedObjectContext sectionNameKeyPath:nil cacheName:nil]; 
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.vacation.vacationDocument.fileURL path]]) {
        [self.vacation.vacationDocument saveToURL:self.vacation.vacationDocument.fileURL
                forSaveOperation:UIDocumentSaveForCreating 
               completionHandler:^(BOOL success) { 
                   // if the file does not exits fill it
                   // should not pass here!!!!
                   // the file should have been set up in the previous TVC
                   NSLog(@"File does not exist in TopPlacesVacationItineraryPhotosTableViewController");
                   //[self fetchFlickrDataIntoDocument:self.vacation];
                   [self setupFetchedResultsController];
               }];
    }
    else if (self.vacation.vacationDocument.documentState == UIDocumentStateClosed)
    {
        [self.vacation.vacationDocument openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
            
        }];
    }
    else if (self.vacation.vacationDocument.documentState == UIDocumentStateNormal)
    {
        [self setupFetchedResultsController];
    }
}

- (void)setVacation:(Vacation *)vacation
{
    if (vacation != _vacation) {
        _vacation = vacation;
    } 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // only perform the fetch when vacation and selectedTag are defined
    if (self.vacation && self.selectedTag) {
        // NSLog(@"viewWillAppear in Tags");
        [self useDocument];
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (YES);
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Tag Photo Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.description;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set which photo is selected
    self.selectedPhoto = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // should segue to the selected photo
    [self performSegueWithIdentifier:@"Show Photo" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photo"]) {
        // convert the Photo to a FlickrPhoto
        // and pass the FlickrPhoto onwards
        [segue.destinationViewController setFlickrPhoto:[FlickrPhoto initWithPhoto:self.selectedPhoto]];
        [segue.destinationViewController setVacation:self.vacation];
    }
}

@end
