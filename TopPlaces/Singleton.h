//
//  Singleton.h
//  TopPlaces
//
//  Created by Arnaud Leene on 16/03/2012.
//  Copyright (c) 2012 MicroContent Musings - Hovering Above. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vacation.h"

@interface SingletonClass : NSObject {
    
    Vacation *currentVacation;
}

@property (nonatomic, retain) Vacation *currentVacation;

+ (id)sharedManager;

- (id)initWithVacation:(Vacation *)vacation;

@end