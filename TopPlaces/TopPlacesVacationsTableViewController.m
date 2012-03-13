//
//  TopPlacesVacationsTableViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 23/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesVacationsTableViewController.h"
#import "TopPlacesVacationSingleTableViewController.h"
#import "VacationsList.h"
#import "Vacation.h"

@interface TopPlacesVacationsTableViewController()

@property (nonatomic, strong) VacationsList *vacationsList;
@property (nonatomic, strong) Vacation *selectedVacation;
@end

@implementation TopPlacesVacationsTableViewController

@synthesize selectedVacation = _selectedVacation;
@synthesize vacationsList = _vacationsList;

- (VacationsList *)vacationsList {
    if (!_vacationsList) {
        _vacationsList = [VacationsList initWithStoredDocuments];
    }
    return _vacationsList;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // whicj is the number of vacations found in storage
    return [self.vacationsList.vacations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacations Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.vacationsList.vacations objectAtIndex:indexPath.row] title];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedVacation = [self.vacationsList.vacations objectAtIndex:indexPath.row];
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
