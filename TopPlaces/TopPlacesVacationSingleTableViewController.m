//
//  TopPlacesVacationSingleTableViewController.m
//  TopPlaces
//
//  Created by Arnaud Leene on 23/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesVacationSingleTableViewController.h"

@implementation TopPlacesVacationSingleTableViewController

@synthesize vacation = _vacation;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *fileName = [self.vacation.fileURL lastPathComponent];
    NSRange  range = [fileName rangeOfString:@"vacation"];
    self.title = [fileName substringToIndex:range.location-1];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"Itineraries" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"Tags" sender:self];
            break;
        default:
            break;
    }
}

// this class just passes the selected vacation onwards
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Itineraries"])
        [segue.destinationViewController setVacation:self.vacation];
    else if ([segue.identifier isEqualToString:@"Tags"])
        [segue.destinationViewController setVacation:self.vacation];
}
@end
