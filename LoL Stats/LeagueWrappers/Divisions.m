//
// Created by Tristan Pollard on 2013-10-19.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "Divisions.h"


@implementation Divisions {

}

-(id)initWithDivisionData:(TypedObject *)divisionData {
    if ((self = [super init])){
        self.divisionName = [divisionData objectForKey:@"name"];
        self.divisionQueue = [divisionData objectForKey:@"queue"];
        self.divisionRank = [divisionData objectForKey:@"requestorsRank"];
        self.divisionTier = [divisionData objectForKey:@"tier"];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"Division: %@ Queue: %@ Rank: %@ Tier: %@", self.divisionName, self.divisionQueue, self.divisionRank, self.divisionTier];
}


@end