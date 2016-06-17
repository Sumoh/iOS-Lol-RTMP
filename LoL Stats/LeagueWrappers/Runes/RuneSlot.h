//
// Created by Tristan Pollard on 2013-10-22.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TypedObject.h"
#import "RuneType.h"



@interface RuneSlot : NSObject

@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSNumber *dataVersion;
@property (nonatomic, retain) NSNumber *minLevel;
@property (nonatomic, retain) RuneType *type;
//@property (nonatomic, retain) NSNumber *runeId;

-(id)initWithRuneSlot:(TypedObject *)runeSlot;

@end