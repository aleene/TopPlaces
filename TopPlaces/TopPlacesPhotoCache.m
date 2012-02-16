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

@property (nonatomic, strong)NSString *cachePath;

@end

@implementation TopPlacesPhotoCache

@synthesize cachePath = _cachePath;

#define FILETYPE @".jpg"
#define FILEPREFIX @"Fl1ckr_"
#define MAXIMUM_CACHE_SIZE 8000000 // in Bytes

- (NSString *)cachePath
{
    if (!_cachePath) {
    NSArray *cachePaths = [[NSArray alloc] initWithArray:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)];
        _cachePath =[NSString stringWithFormat:@"%@",[cachePaths objectAtIndex:0]];
    }
    return _cachePath;
}

- (NSString *)pathForPhoto:(NSDictionary *)photo 
{
    // create a unique photo_identifier, so I can find it back
    NSString *photoIdentifier = [[photo valueForKey:FLICKR_PHOTO_ID] stringByAppendingString:FILETYPE];
    photoIdentifier = [FILEPREFIX stringByAppendingString:photoIdentifier];
//    NSLog(@"photo id: %@", photoIdentifier);
    return [self.cachePath stringByAppendingPathComponent:photoIdentifier];
}

- (BOOL)contains:(NSDictionary *)photo;
{

    BOOL photoExists = NO;
    NSArray *cachePaths = [[NSArray alloc] initWithArray:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)];

    // check if there is a cache directory
    if ([cachePaths count] >= 1) {
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

- (NSDictionary *)fileAttributesForCacheFile:(NSString *)fileName
{
    return [[NSFileManager defaultManager] attributesOfItemAtPath:[self.cachePath stringByAppendingPathComponent:fileName] error:nil];
}

- (int)directorySizeForPath:(NSString *)directoryPath
{
    int directorySize = 0;                                                              // determine the size of the entire cache directory
    NSString *fileName;
    
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:self.cachePath error:nil]; // get the files in the directory
    
    NSEnumerator *filesEnumator = [filesArray objectEnumerator];
    // loop over all files in the directory and summ the file sizes
    while (fileName = [filesEnumator nextObject]) {
        directorySize += [[self fileAttributesForCacheFile:fileName] fileSize];
    }

    return directorySize;
}

- (void)pruneCacheForPhoto:(NSData *)photoData
{
    int dataSize = [photoData length];                                                  // size of the file to write in Bytes
    
    int currentDirectorySize = [self directorySizeForPath:self.cachePath];              // size of the Cache Directory
    
    if ((currentDirectorySize + dataSize) > MAXIMUM_CACHE_SIZE)                         // do I need to make space?
    {
        NSString *fileName;
        
        NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:self.cachePath error:nil]; // get the files in the directory
        NSMutableArray *filesWithProperties = [[NSMutableArray alloc] initWithCapacity:[filesArray count]]; // prepare an array with a directory for each file
        
        NSEnumerator *filesEnumator = [filesArray objectEnumerator];
        // loop over all files in the directory and summ the file sizes
        while (fileName = [filesEnumator nextObject]) {
                        
            if ([fileName hasSuffix:FILETYPE])                                              // check if this is an image (should check the FILEPREFIX as well)
            {
                [filesWithProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys:fileName, @"filePath",[[self fileAttributesForCacheFile:fileName] fileModificationDate], @"lastModDate", nil]];
            }
        }
        // inspiration http://stackoverflow.com/questions/1523793/get-directory-contents-in-date-modified-order
                                                                                        // create an array sorted by file modification dates
        NSArray *invertedSortedFiles = [[NSArray alloc] initWithArray:[filesWithProperties sortedArrayUsingComparator:^(id path1, id path2)
                                        {                               
                                            return [[path1 objectForKey:@"lastModDate"] compare:[path2 objectForKey:@"lastModDate"]];                          
                                        }]];
        NSDictionary *fileObject;
        for (fileObject in invertedSortedFiles)                                         // loop over all fileOjects
        {
//            NSLog(@"dir size %i %i", currentDirectorySize, dataSize);
//            NSLog(@"found:: %@ %@", [fileObject valueForKey:@"filePath"], [[fileObject valueForKey:@"lastModDate"] description]);

            if ((currentDirectorySize + dataSize) > MAXIMUM_CACHE_SIZE)                        // do I need to make place
            {
//                NSLog(@"delete:: %@ %@", [fileObject valueForKey:@"filePath"], [[fileObject valueForKey:@"lastModDate"] description]);

                [[NSFileManager defaultManager] removeItemAtPath:[self.cachePath stringByAppendingPathComponent:[fileObject valueForKey:@"filePath"]] error:nil];   // remove file
                currentDirectorySize = [self directorySizeForPath:self.cachePath];
            }
        }
        // what happens when the other files in the cache take to much space?
    }
}

- (void)put:(NSData *)photoData for:(NSDictionary *)photo
{
    if (![self contains:photo])                                                          // is the photo already in the Cache?
    {
        [self pruneCacheForPhoto:photoData];                                             // is there enough space for this photo?
       
        [photoData writeToFile:[self pathForPhoto:photo] atomically:YES];                // write photo
    }
}

@end
