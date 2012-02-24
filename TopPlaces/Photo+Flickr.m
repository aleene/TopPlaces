//
//  Photo+Flickr.m
//  TopPlaces
//
//  Created by Arnaud Leene on 23/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Place+Create.h"
#import "Place.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrDictionary:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    // need to check whether the photo is already there
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique =%@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || [matches count]) {
        // should handle the error here
    } else if ([matches count] == 0)
    {
        // the photo is not yet available
        // it should be added
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        // NSLog(@"FlickrInfo %@",[flickrInfo description]);
        photo.unique = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        if ([photo.title isEqualToString:@""]) {
            photo.title = @"no title";
        }
        photo.subtitle = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.url = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
        photo.place = [Place placeWithName:[flickrInfo objectForKey:FLICKR_PHOTO_PLACE_NAME] inManagedObjectContext:context];
    }
    else
    {
        photo = [matches lastObject];
    }
    return photo;
}

- (NSDictionary *)asFlickrDictionary
{    
    // NSLog(@"photo %@",[self description]);
    // this creates a rudimentary Flickr dictionary
    // many things are missing
    NSDictionary *flickrPhoto = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    self.unique, FLICKR_PHOTO_ID, 
                                    self.title, FLICKR_PHOTO_TITLE, 
                                    self.subtitle, FLICKR_PHOTO_DESCRIPTION,
                                    nil];

    return flickrPhoto;
}
@end
