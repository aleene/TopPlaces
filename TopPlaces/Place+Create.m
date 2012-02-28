//
//  Place+Create.m
//  TopPlaces
//
//  Created by Arnaud Leene on 23/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "Place+Create.h"

@implementation Place (Create)

+ (Place *)placeWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context

{
    Place *place = nil;
    
    // need to check whether the place is already there
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"name =%@", name];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || [matches count] > 1) {
        // should handle the error here
    } else if ([matches count] == 0)
    {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        if ([name isEqualToString:@""])
            place.name = @"no place name";
        else 
            place.name = name;
        
        // NSLog(@"New Place %@",[place description]);
    }
    else
        place = [matches lastObject];
    // NSLog(@"Place Returned %@",[place description]);

    return place;
}

@end
