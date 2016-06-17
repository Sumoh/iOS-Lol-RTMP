//
// Created by Tristan Pollard on 11/11/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "LoLChatBuddy.h"


@implementation LoLChatBuddy {

}

-(id)init{
    if ((self = [super init])){
        self.messageHistory = [[NSMutableArray alloc] init];
        self.isNewMessage = false;
    }

    return self;
}

-(id)initWithBuddyUsername:(NSString *)username andDisplayName:(NSString *)displayName{
    if ((self = [super init])){
        self.username = username;
        self.displayName = displayName;
        self.messageHistory = [[NSMutableArray alloc] init];
    }

    return self;
}

@end