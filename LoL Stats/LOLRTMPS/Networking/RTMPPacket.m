//
// Created by Tristan Pollard on 2013-10-11.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RTMPPacket.h"


@implementation RTMPPacket {

}

-(id)init{
    if ((self = [super init])){
        self.dataBuffer = [[NSMutableData alloc] init];
    }

    return self;
}
@end