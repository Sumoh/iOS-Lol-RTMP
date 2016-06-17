//
// Created by Tristan Pollard on 2013-10-22.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "RuneType.h"


@implementation RuneType {

}

-(id)initWithRuneType:(TypedObject *)runeType {
    if ((self = [super init])){
        [self parseRuneType:runeType];
    }
    return self;
}

-(void)parseRuneType:(TypedObject *)runeType{
    self.runeTypeId = [runeType objectForKey:@"runeTypeId"];
    self.dataVersion = [runeType objectForKey:@'dataVersion'];
    self.name = [runeType objectForKey:@"name"];
    self.futureData = [runeType objectForKey:@"futureData"];
}

@end