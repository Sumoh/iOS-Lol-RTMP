//
// Created by Tristan Pollard on 2013-10-22.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TypedObject.h"
#import "RuneType.h"
#import "RuneItemEffect.h"

@interface Rune : NSObject

@property (nonatomic, retain) NSString *toolTip, *description, *name, *baseType;
@property (nonatomic, retain) NSNumber *tier, *dataVersion, *duration, *gameCode, *itemId;
@property (nonatomic, retain) RuneType *type;
@property (nonatomic, retain) NSMutableArray *itemEffects;
@property (nonatomic, retain) NSArray *futureData, *uses, *imagePath;

-(id)initWithRune:(TypedObject *)rune;

@end