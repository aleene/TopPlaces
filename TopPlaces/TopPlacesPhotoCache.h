//
//  TopPlacesPhotoCache.h
//  TopPlaces
//
//  Created by Arnaud Leene on 14/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopPlacesPhotoCache : NSObject

- (BOOL)contains:(NSDictionary *)photo;
- (NSData *)retrieve:(NSDictionary *)photo;
- (void)put:(NSData *)photoData for:(NSDictionary *)photo;

@end
