//
// Created by Tristan Pollard on 11/2/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "XMPP.h"
//#import "XMPPStream.h"
#import "XMPPReconnect.h"
//#import "XMPPJID.h"
#import "XMPPRoster.h"
#import "XMPPRosterMemoryStorage.h"
#import "LoLChatBuddy.h"
#import "AudioToolbox/AudioToolbox.h"

@protocol LoLChatMessageDelegate <NSObject>
@optional
-(void)didReceieveMessageForBuddy:(LoLChatBuddy *)buddy;
@end

@protocol LoLChatDelegate <NSObject>
@optional
-(void)buddiesDidChange;
@end

@interface LoLChat : NSObject <XMPPStreamDelegate, UIApplicationDelegate>

@property (nonatomic, retain) XMPPStream *xmppStream;
@property (nonatomic, retain) XMPPReconnect *xmppReconnect;
@property (nonatomic, retain) XMPPRoster *xmppRoster;
@property (nonatomic, retain) XMPPRosterMemoryStorage *xmppRosterStorage;
@property (nonatomic, retain) NSString *username, *password;

@property (nonatomic, retain) id <LoLChatDelegate> delegate;
@property (nonatomic, retain) id <LoLChatMessageDelegate> messageDelegate;

@property (nonatomic, retain) NSMutableDictionary *buddies;


-(id)initWithUsername:(NSString *)username andPassword:(NSString *)password;

@end