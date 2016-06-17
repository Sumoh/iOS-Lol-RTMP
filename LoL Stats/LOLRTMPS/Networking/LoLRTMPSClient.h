//
// Created by Tristan Pollard on 2013-10-11.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TypedObject.h"
#import "AMF3Decoder.h"
#import "AMF3Decoder.h"
#import "RTMPSClient.h"
#import "HeartBeat.h"
#import "TestFlight.h"
#import "LoLChat.h"

@class HeartBeat;

@interface LoLRTMPSClient : RTMPSClient

typedef enum {
    kRegionNA = 0,
    kRegionEUW = 1,
    kRegionEUN = 2,
    kRegionEUNE = 3,
    kRegionKR = 4,
    kRegionBR = 5,
    kRegionTR = 6,
    kRegionPBE = 7,
    kRegionSG = 8,
    kRegionMY = 9,
    kRegionSGMY = 10,
    kRegionTW = 11,
    kRegionTH = 12,
    kRegionPH = 13,
    kRegionVn = 14
} regionTypes;

@property (nonatomic, assign) regionTypes region;

@property (nonatomic, assign) int port;
@property (nonatomic, retain) NSString *server;
//@property (nonatomic, retain) NSString *region;

@property (nonatomic, assign) bool loggedIn;
@property (nonatomic, retain) NSString *loginQueue;
@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *pass;

@property (nonatomic, assign) bool useGarena;
@property (nonatomic, retain) NSString *garenaToken;
@property (nonatomic, retain) NSString *userId;

@property (nonatomic, retain) NSString *clientVersion;
@property (nonatomic, retain) NSString *ipAddress;
@property (nonatomic, retain) NSString *locale;

@property (nonatomic, retain) NSString *authToken;
@property (nonatomic, retain) NSString *sessionToken;
@property (nonatomic, assign) int accountId;

@property (nonatomic, retain) HeartBeat *heartBeat;

@property (nonatomic, retain) LoLChat *chat;

//-(id)initWithUsername:(NSString *)user andPassword:(NSString *)pass forRegion:(regionTypes)regionId withClientVersion:(NSString *)clientVersion;

-(void)setUsername:(NSString *)user andPassword:(NSString *)pass forRegion:(regionTypes)regionId withClientVersion:(NSString *)clientVersion;
+ (id)sharedInstance;

-(bool)login;

@end