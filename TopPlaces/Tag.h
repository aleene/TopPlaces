//
//  Tag.h
//  TopPlaces
//
//  Created by Arnaud Leene on 24/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *hasPhotos;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addHasPhotosObject:(Photo *)value;
- (void)removeHasPhotosObject:(Photo *)value;
- (void)addHasPhotos:(NSSet *)values;
- (void)removeHasPhotos:(NSSet *)values;

@end
