//
// Created by Tristan Pollard on 2013-10-11.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "HeartBeat.h"

@implementation HeartBeat {

}

-(id)init{
    if ((self = [super init])){
        self.heartbeat = 1;
    }

    return self;
}

-(id)initWithClient:(LoLRTMPSClient *)client{
    if ((self = [super init])){
        self.client = client;
        self.heartbeat = 1;
    }

    return self;
}

-(void)startHeartBeat{
    while (true){
        [self beatHeart];
    }
}

-(void)beatHeart{
    long long hbTime = [[NSDate date] timeIntervalSince1970] * 1000;
    NSLog(@"beating heart...");

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"ddd MMM d yyyy HH:mm:ss 'GMTZ'";

    NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithInteger:self.client.accountId], self.client.sessionToken, [NSNumber numberWithInt:self.heartbeat], [df stringFromDate:[NSDate date]], nil];
    int id = [self.client invoke:@"loginService" operation:@"performLCDSHeartBeat" body:arr];

    [self.client cancel:id];

    self.heartbeat++;

    while (([[NSDate date] timeIntervalSince1970] * 1000) - hbTime < 120000){
        usleep(100);
    }
}

@end