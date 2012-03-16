//
//  Singleton.m
//  TopPlaces
//
//  Created by Arnaud Leene on 16/03/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import "Singleton.h"

static SingletonClass *sharedMyManager = nil;

@implementation SingletonClass

// the currentVacation is valid for all classes in TopPlaces
// once a vacation is selected, then this one is used
// to add or remove photo's
// a vacation is not passed between objects!
@synthesize currentVacation = _currentVacation;

#pragma mark Singleton Methods
+ (id)sharedManager {
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

- (id)initWithVacation:(Vacation *)vacation {
    if (self = [super init]) {
        _currentVacation = vacation;
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
