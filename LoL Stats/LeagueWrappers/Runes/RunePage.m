//
// Created by Tristan Pollard on 2013-10-22.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "RunePage.h"


@implementation RunePage {

}

-(id)init{
    if ((self = [super init])){
        self.slots = [[NSMutableArray alloc] init];
        //self.runeNames = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(id)initWithRunePageData:(TypedObject *)runePage {

    if ((self = [super init])){
        self.slots = [[NSMutableArray alloc] init];
        //self.runeNames = [[NSMutableDictionary alloc] init];
        [self parseRunePageData:runePage];
    }

    return self;

}

-(void)parseRunePageData:(TypedObject *)runePage{
    self.pageId = [runePage objectForKey:@"pageId"];
    self.pageName = [runePage objectForKey:@"name"];
    self.current = [runePage boolForKey:@"current"];
    self.dateCreated = [runePage objectForKey:@"createDate"];

    NSArray *runeSlotEntries = [[runePage objectForKey:@"slotEntries"] objectForKey:@"array"];
    for (TypedObject *slot in runeSlotEntries){
        RuneSlotEntry *theSlot = [[RuneSlotEntry alloc] initWithRuneSlotEntry:slot];
        [self.slots addObject:theSlot];

    }

}

@end