//
// Created by Tristan Pollard on 2013-10-11.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "LoLRTMPSClient.h"

@class LoLRTMPSClient;

@interface HeartBeat : NSObject

@property (nonatomic, assign) int heartbeat;
@property (nonatomic, retain) LoLRTMPSClient *client;

-(void)startHeartBeat;
-(id)initWithClient:(LoLRTMPSClient *)client;


@end