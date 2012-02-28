//
//  Tag+Create.m
//  TopPlaces
//
//  Created by Arnaud Leene on 24/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)

+ (Tag *)tagWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context

{
    Tag *tag = nil;
    
    // need to check whether the place is already there
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"name =%@", name];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    //NSLog(@"Tag matches %d", [matches count]);
    if (!matches || [matches count] > 1) {
        // should handle the error here
        NSLog(@"Tag addition error");
    } else if ([matches count] == 0)
    {
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
        if ([name isEqualToString:@""])
            tag.name = @"no tag name";
        else 
            tag.name = name;
        
        //NSLog(@"New tag %@",tag.name);
    }
    else
        tag = [matches lastObject];
    //NSLog(@"Return tag %@",tag.name);

    return tag;
}

@end
