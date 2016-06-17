//
// Created by Tristan Pollard on 2013-10-22.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "RuneSlot.h"
#import "RuneType.h"

@implementation RuneSlot {

}


-(id)initWithRuneSlot:(TypedObject *)runeSlot {
    if ((self = [super init])){
        [self parseRuneSlot:runeSlot];
    }
    return self;
}

-(void)parseRuneSlot:(TypedObject *)runeSlot{
    if (runeSlot != nil){
        self.id = [runeSlot objectForKey:@"id"];
        self.dataVersion = [runeSlot objectForKey:@"dataVersion"];
        self.minLevel = [runeSlot objectForKey:@"minLevel"];
        self.type = [[RuneType alloc] initWithRuneType:[runeSlot objectForKey:@"runeType"]];
    }
}

@end