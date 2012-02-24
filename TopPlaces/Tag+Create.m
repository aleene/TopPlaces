//
//  Tag+Create.m
//  TopPlaces
//
//  Created by Arnaud Leene on 24/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)

+ (Tag *)tagWithName:(NSString *)name forPhoto:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context

{
    Tag *tag = nil;
    
    // need to check whether the place is already there
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"name =%@", name];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || [matches count]) {
        // should handle the error here
    } else if ([matches count] == 0)
    {
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
        if ([name isEqualToString:@""])
            tag.name = @"no tag name";
        else 
            tag.name = name;
        
        // NSLog(@"Tag %@",[tag description]);
    }
    else
        tag = [matches lastObject];
    
    // if the tag has been created, the photo can be added
    [tag addHasPhotosObject:photo];
    
    return tag;
}

@end
