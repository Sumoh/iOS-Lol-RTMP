//
// Created by Tristan Pollard on 2013-10-10.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ClassDefinition.h"


@implementation ClassDefinition {

}

-(id)init {

    if ((self = [super init])){
        self.dynamic = false;
        self.externalizable = false;
        self.members = [[NSMutableArray alloc] init];
    }

    return self;

}

@end