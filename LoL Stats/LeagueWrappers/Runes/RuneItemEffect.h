//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TypedObject.h"
#import "Effect.h"

//public class RuneItemEffect extends ModelFromTO {
//    int effectID;
//    int itemEffectID;
//    int dataVersion;
//    String value; // ???
//    int itemID;
//    Object futureData;
//    Effect effect;
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
//}


@interface RuneItemEffect : NSObject

@property (nonatomic, retain) NSNumber *effectID, *itemEffectId, *dataVersion, *itemid;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSArray *futureData;
@property (nonatomic, retain) Effect *effect;

-(id)initWithRuneItemEffect:(TypedObject *)runeItemEffect;

//@property (nonatomic, assign) int itemEffectId;

@end