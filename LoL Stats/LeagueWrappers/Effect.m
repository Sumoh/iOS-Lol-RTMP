//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "Effect.h"


@implementation Effect {

}

-(id)initWithEffect:(TypedObject *)effect{

    if ((self = [super init])){

    self.effectId = [effect objectForKey:@"effectId"];
    self.gameCode = [effect objectForKey:@"gameCode"];
    self.dataVersion = [effect objectForKey:@"dataVersion"];
    self.categoryId = [effect objectForKey:@"categoryId"];
    self.name = [effect objectForKey:@"name"];
    self.runeType = [[RuneType alloc] initWithRuneType:[effect objectForKey:@"runeType"]];
    self.futureData = [effect objectForKey:@'futureData'];

    }
    return self;
}

//public Effect(TypedObject ito) {
//    super(ito);
//    effectID = getInt("effectId");
//    gameCode = getString("gameCode");
//    dataVersion = getInt("dataVersion");
//    categoryID = getProbablyNull("categoryId");
//    name = getString("name");
//    runeType = new RuneType(getTO("runeType"));
//    futureData = getProbablyNull("futureData");
//    checkFields();
//}

@end