//
// Created by Tristan Pollard on 11/11/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "XMPPJID.h"

@interface LoLChatBuddy : NSObject

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSMutableArray *messageHistory;
@property (nonatomic, assign) bool isNewMessage;
@property (nonatomic, retain) XMPPJID *jid;

-(id)initWithBuddyUsername:(NSString *)username andDisplayName:(NSString *)displayName;

@end