//
// Created by Tristan Pollard on 2013-10-22.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TypedObject.h"
#import "Rune.h"
#import "RuneSlot.h"

@interface RuneSlotEntry : NSObject


@property (nonatomic, retain) NSNumber *runeId;
@property (nonatomic, retain) NSNumber *slotId;
@property (nonatomic, retain) Rune *rune;
@property (nonatomic, retain) NSArray *futureData;
@property (nonatomic, retain) NSNumber *dataVersion;
@property (nonatomic, retain) RuneSlot *runeSlot;

-(id)initWithRuneSlotEntry:(TypedObject *)runeSlotEntry;

@end