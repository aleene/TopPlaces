//
//  Tag+Create.h
//  TopPlaces
//
//  Created by Arnaud Leene on 24/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "Tag.h"
#import "Photo.h"


@interface Tag (Create)

+ (Tag *)tagWithName:(NSString *)name forPhoto:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context;

@end
