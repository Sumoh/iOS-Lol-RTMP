//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RuneType.h"
#import "TypedObject.h"


@interface Effect : NSObject

@property (nonatomic, retain) NSNumber *effectId, *dataVersion;
@property (nonatomic, retain) NSString *gameCode, *name;
@property (nonatomic, retain) NSArray *futureData, *categoryId;
@property (nonatomic, retain) RuneType *runeType;

-(id)initWithEffect:(TypedObject *)effect;


//
//int effectID;
//String gameCode;
//int dataVersion;
//Object categoryID;
//String name;
//RuneType runeType;
//Object futureData;
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