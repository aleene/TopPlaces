//
//  TopPlacesPhotoCache.m
//  TopPlaces
//
//  Created by Arnaud Leene on 14/02/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "TopPlacesPhotoCache.h"
#import "FlickrFetcher.h"

@interface TopPlacesPhotoCache()

@end

@implementation TopPlacesPhotoCache

#define FILETYPE @".jpg"

- (NSString *)pathForPhoto:(NSDictionary *)photo 
{
    NSString *photoIdentifier = [[photo valueForKey:FLICKR_PHOTO_ID] stringByAppendingString:FILETYPE];
    NSLog(@"photo id: %@", photoIdentifier);
    NSArray *cachePaths = [[NSArray alloc] initWithArray:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)];
    NSString *photoPath = [[cachePaths objectAtIndex:0] stringByAppendingString:@"/"];
    photoPath = [photoPath stringByAppendingString:photoIdentifier];
    return photoPath;
}

- (BOOL)contains:(NSDictionary *)photo;
{

    NSFileManager *filemanager = [NSFileManager defaultManager];
    BOOL photoExists = NO;
    NSArray *cachePaths = [[NSArray alloc] initWithArray:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)];

    if ([cachePaths count] >= 1) {
        NSDirectoryEnumerator *dirEnum =
        [filemanager enumeratorAtPath:[cachePaths objectAtIndex:0]];
        
        NSString *file;
        while (file = [dirEnum nextObject]) {
            NSLog(@"file: %@", file);
        }
        NSLog(@"%@", [self pathForPhoto:photo]);
        photoExists = [[NSFileManager defaultManager] isReadableFileAtPath:[self pathForPhoto:photo]];
        
    } else
    {
        // guess I have to create the caches directory here
    }
        return photoExists;
}

- (NSData *)retrieve:(NSDictionary *)photo
{
    NSData *photoData = [[NSData alloc] initWithData:[[NSFileManager defaultManager] contentsAtPath:[self pathForPhoto:photo]]];
    return photoData;
}

- (void)put:(NSData *)photoData for:(NSDictionary *)photo
{
    // convert the photo_id to a filename for the cache
    // put the data under that file name for the path of the cache
    if (![self contains:photo])
    {
        // write photo (jave to check the sie of the directory)
        [photoData writeToFile:[self pathForPhoto:photo] atomically:YES];
    }
}

@end
