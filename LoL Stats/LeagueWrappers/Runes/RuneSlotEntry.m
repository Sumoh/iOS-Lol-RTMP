//
// Created by Tristan Pollard on 2013-10-22.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "RuneSlotEntry.h"
#import "RuneType.h"


@implementation RuneSlotEntry {

}

-(id)initWithRuneSlotEntry:(TypedObject *)runeSlotEntry {
    if ((self = [super init])){
        [self parseRuneSlotEntry:runeSlotEntry];
    }
    return self;
}

-(void)parseRuneSlotEntry:(TypedObject *)runeSlotEntry{
    self.runeId = [runeSlotEntry objectForKey:@"runeId"];
    self.slotId = [runeSlotEntry objectForKey:@"runeSlotId"];

    TypedObject *rune = [runeSlotEntry objectForKey:@"rune"];

    if (![rune isKindOfClass:[TypedObject class]]){
        self.rune = [[Rune alloc] init];
    }else{
        self.rune = [[Rune alloc] initWithRune:[runeSlotEntry objectForKey:@"rune"]];
    }

    self.futureData = [runeSlotEntry objectForKey:@"futureData"];
    self.dataVersion = [runeSlotEntry objectForKey:@"dataVersion"];

    self.runeSlot = [[RuneSlot alloc] initWithRuneSlot:[runeSlotEntry objectForKey:@"runeSlot"]];
}

@end