//
//  Photo+Flickr.h
//  TopPlaces
//
//  Created by Arnaud Leene on 23/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "Photo.h"
#import "FlickrPhoto.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrDictionary:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Photo *)photoWithFlickrPhoto:(FlickrPhoto *)flickrPhoto inManagedObjectContext:(NSManagedObjectContext *)context;

- (NSDictionary *)asFlickrDictionary;

@end
