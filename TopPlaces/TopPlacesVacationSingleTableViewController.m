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

// this class just passes the selected vaction onwards
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setVacation:self.vacation];
}
@end
