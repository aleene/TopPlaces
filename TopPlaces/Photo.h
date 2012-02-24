//
//  Photo.h
//  TopPlaces
//
//  Created by Arnaud Leene on 24/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place, Tag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) NSSet *hasTags;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addHasTagsObject:(Tag *)value;
- (void)removeHasTagsObject:(Tag *)value;
- (void)addHasTags:(NSSet *)values;
- (void)removeHasTags:(NSSet *)values;

@end
