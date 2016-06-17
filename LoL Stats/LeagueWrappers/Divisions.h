//
// Created by Tristan Pollard on 2013-10-19.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TypedObject.h"


@interface Divisions : NSObject

@property (nonatomic, retain) NSString *divisionName;
@property (nonatomic, retain) NSString *divisionQueue;
@property (nonatomic, retain) NSString *divisionRank;
@property (nonatomic, retain) NSString *divisionTier;

-(id)initWithDivisionData:(TypedObject *)divisionData;

@end