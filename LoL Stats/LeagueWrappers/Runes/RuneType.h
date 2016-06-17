//
// Created by Tristan Pollard on 2013-10-22.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TypedObject.h"


@interface RuneType : NSObject

@property (nonatomic, retain) NSNumber *runeTypeId;
@property (nonatomic, retain) NSNumber *dataVersion;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *futureData;

-(id)initWithRuneType:(TypedObject *)runeType;

@end