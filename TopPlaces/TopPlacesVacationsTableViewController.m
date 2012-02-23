//
//  TopPlacesVacationsTableViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 23/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesVacationsTableViewController.h"
#import "TopPlacesVacationSingleTableViewController.h"

@interface TopPlacesVacationsTableViewController()

@property (nonatomic, strong) NSArray *vacations; // of UIManagedDocument(s)
@property (nonatomic, strong) NSDictionary *selectedVacation;
@end

@implementation TopPlacesVacationsTableViewController

@synthesize vacations = _vacations;
@synthesize selectedVacation = _selectedVacation;

#pragma mark - Table view data source

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.vacations)        // get a list of vacations
    {
        // this should result in a single directory URL!!
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] lastObject];
        
        // I should look at the contents of this directory
        // and see if there are files that contain vacations
        // and add all these urls to an url array
        NSMutableArray *vacationUrls = [[NSMutableArray alloc] initWithCapacity:0];
        
        // if no vacations are found, add a default one
        if ([vacationUrls count] == 0) {
            // FAKING
            // we start just with the default vacation "My Vacation" for now
            // and add that to the url vacations
            url = [url URLByAppendingPathComponent:@"My Vacation"];
            [vacationUrls addObject:url];
        }

        NSMutableArray *vacations = [[NSMutableArray alloc] initWithCapacity:[vacationUrls count]];
        
        // loop over all documents and add each document to the vacations array
        for (NSURL *vacation in vacationUrls) {
            [vacations addObject:[[UIManagedDocument alloc] initWithFileURL:url]];
        }
        self.vacations = vacations;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // whicj is the number of vacations found in storage
    return [self.vacations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacations Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[[self.vacations objectAtIndex:indexPath.row] fileURL] lastPathComponent];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedVacation = [self.vacations objectAtIndex:indexPath.row];
    // when selected  go to the vacation scene

    [self performSegueWithIdentifier:@"Show Vacation" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Vacation"]) {
        // set the selected vacation
        [segue.destinationViewController setVacation:self.selectedVacation];
    }
}
         
@end
