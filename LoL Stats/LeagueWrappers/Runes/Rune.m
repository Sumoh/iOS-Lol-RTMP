//
// Created by Tristan Pollard on 2013-10-22.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "Rune.h"


@implementation Rune {

}

-(id)initWithRune:(TypedObject *)rune {
    if ((self = [super init])){
        [self parseRune:rune];
    }

    return self;
}

-(void)parseRune:(TypedObject *)rune{
    self.tier = [rune objectForKey:@"tier"];
    self.description = [rune objectForKey:@"description"];
    self.name = [rune objectForKey:@"name"];
    self.futureData = [rune objectForKey:@'futureData'];
    self.dataVersion = [rune objectForKey:@"dataVersion"];
    self.type = [[RuneType alloc] initWithRuneType:[rune objectForKey:@"runeType"]];
    self.toolTip = [rune objectForKey:@"toolTip"];
    self.itemId = [rune objectForKey:@"itemId"];
    self.uses = [rune objectForKey:@"uses"];
    self.imagePath = [rune objectForKey:@"imagePath"];
    self.gameCode = [rune objectForKey:@"gameCode"];
    self.duration = [rune objectForKey:@"duration"];
    self.baseType = [rune objectForKey:@"baseType"];

    NSArray *arr = [[rune objectForKey:@"itemEffects"] objectForKey:@"array"];

    for (TypedObject *effects in arr){
        [self.itemEffects addObject:[[RuneItemEffect alloc] initWithRuneItemEffect:effects]];
    }

}

@end