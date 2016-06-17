//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "RuneItemEffect.h"


@implementation RuneItemEffect {

}

//    public RuneItemEffect(TypedObject ito) {
//        super(ito);
//        effectID = getInt("effectId");
//        itemEffectID = getInt("itemEffectId");
//        dataVersion = getInt("dataVersion");
//        value = getString("value");
//        itemID = getInt("itemId");
//        futureData = getProbablyNull("futureData");
//        effect = new Effect(getTO("effect"));
//        checkFields();
//    }

-(id)initWithRuneItemEffect:(TypedObject *)runeItemEffect{

    if ((self = [super init])){

    self.effectID = [runeItemEffect objectForKey:@"effectId"];
    self.itemEffectId = [runeItemEffect objectForKey:@"itemEffectId"];
    self.dataVersion = [runeItemEffect objectForKey:@"dataVersion"];
    self.value = [runeItemEffect objectForKey:@"value"];
    self.itemid = [runeItemEffect objectForKey:@"itemId"];
    self.futureData = [runeItemEffect objectForKey:@"futureData"];
    self.effect = [[Effect alloc] initWithEffect:[runeItemEffect objectForKey:@"effect"]];

    }

    return self;

}

@end