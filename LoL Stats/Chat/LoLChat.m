//
// Created by Tristan Pollard on 11/2/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "LoLChat.h"
#import "XMPPMessage.h"
#import "XMPPPresence.h"
#import "XMPPPresence+XEP_0172.h"


@implementation LoLChat {

}

-(id)init {

    if ((self = [super init])){
        self.xmppStream = [[XMPPStream alloc] init];
        self.buddies = [[NSMutableDictionary alloc] init];
    }

    return self;

}

-(id)initWithUsername:(NSString *)username andPassword:(NSString *)password{
    if ((self = [super init])){

        self.buddies = [[NSMutableDictionary alloc] init];
        self.password = password;
        self.username = username;

        self.xmppStream = [[XMPPStream alloc] init];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];


        //This could be the issue?
#if !TARGET_IPHONE_SIMULATOR
        {
            self.xmppStream.enableBackgroundingOnSocket = YES;
        }
#endif

        [self.xmppStream setHostName:@"chat.na1.lol.riotgames.com"];
        [self.xmppStream setHostPort:5223];
        [self.xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@pvp.net", self.username]]];
        NSLog(@"JID = %@ HOSTNAME = %@", self.xmppStream.myJID, self.xmppStream.hostName);

        self.xmppReconnect = [[XMPPReconnect alloc] init];
        [self.xmppReconnect activate:self.xmppStream];

        self.xmppRosterStorage = [[XMPPRosterMemoryStorage alloc] init];
        self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterStorage];
        [self.xmppRoster activate:self.xmppStream];

        NSError *error = nil;
        if (![self.xmppStream oldSchoolSecureConnectWithTimeout:XMPPStreamTimeoutNone error:&error])
        {
            NSLog(@"Oops, I probably forgot something: %@", error.localizedDescription);
        }else{
            NSLog(@"connected to chat...");
        }


    }

    return self;
}

-(void)goOnline{
    XMPPPresence *presence = [[XMPPPresence alloc] init];
    NSXMLElement *element = [NSXMLElement elementWithName:@"status" stringValue:@"<body><profileIcon>519</profileIcon><level>30</level><wins>509</wins><leaves>2</leaves><odinWins>77</odinWins><odinLeaves>0</odinLeaves><queueType /><rankedLosses>0</rankedLosses><rankedRating>0</rankedRating><tier>UNRANKED</tier><rankedLeagueName>Xerath's Blades</rankedLeagueName><rankedLeagueDivision>V</rankedLeagueDivision><rankedLeagueTier>CHALLENGER</rankedLeagueTier><rankedLeagueQueue>RANKED_SOLO_5x5</rankedLeagueQueue><rankedWins>155</rankedWins><gameStatus>outOfGame</gameStatus><statusMsg>TESTING CHAT CLIENT iOS</statusMsg></body>"];
    [presence addChild:element];
    [self.xmppStream sendElement:presence];
}

-(void)setTestStatus{
    NSLog(@"TEST STATUS");
    XMPPPresence *presnence = [[XMPPPresence alloc] initWithName:@"available" stringValue:@"<body><level>9001</level><wins>9001</wins><leaves>0</leaves><rankedWins>218</rankedWins><rankedLosses>55</rankedLosses><rankedRating>2888</rankedRating><gameStatus>outOfGame</gameStatus></body>"];
    [self.xmppStream sendElement:presnence];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"AUTHENTICATED");
    [self goOnline];
    [self.xmppRoster fetchRoster];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    NSLog(@"SOCKET CONNECTED");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"XMPP CONNTECTED");
    [self.xmppStream authenticateWithPassword:[NSString stringWithFormat:@"%@%@", @"AIR_", self.password] error:nil];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {

    if ([message isChatMessageWithBody])
    {
        XMPPUserMemoryStorageObject *user = [self.xmppRosterStorage userForJID:[message from]];
        NSString *displayName = [user displayName];

        if ([self.buddies objectForKey:displayName]){

            LoLChatBuddy *buddy = [self.buddies objectForKey:displayName];
            NSMutableDictionary *messageDic = [[NSMutableDictionary alloc] init];
            [messageDic setObject:[message stringValue] forKey:@"msg"];
            [messageDic setObject:displayName forKey:@"sender"];
            [messageDic setObject:[NSDate date] forKey:@"date"];
            [buddy.messageHistory addObject:messageDic];
            buddy.isNewMessage = true;
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

            if (self.messageDelegate != nil && [self.messageDelegate respondsToSelector:@selector(didReceieveMessageForBuddy:)]){
                [self.messageDelegate didReceieveMessageForBuddy:buddy];
            }

        }

    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {

    XMPPUserMemoryStorageObject *user = [self.xmppRosterStorage userForJID:[presence from]];

    NSString *displayName = [user displayName];
    NSString *myUsername = [[sender myJID] user];
    NSString *myUsernameCheck = [NSString stringWithFormat:@"%@%@", myUsername, @"@pvp.net"];

    NSString *status = [[presence elementForName:@"status"] stringValue];
    //DDXMLElement *element = [[DDXMLElement alloc] initWithXMLString:status error:nil];

    if (![displayName isEqualToString:myUsernameCheck]){

       // NSLog(@"ATTRIBUTES = %@", presence.attributesAsDictionary);
        NSLog(@"USER = %@ DISPLAY = %@", [[presence from] user], displayName);

        if ([[presence type] isEqualToString:@"available"]){

            if (![self.buddies objectForKey:displayName] && displayName != nil){

                LoLChatBuddy *buddy = [[LoLChatBuddy alloc] initWithBuddyUsername:[[presence from] user] andDisplayName:displayName];

                [self.buddies setObject:buddy forKey:displayName];

                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(buddiesDidChange)]){
                    [self.delegate buddiesDidChange];
                }

            }

        }else{

            [self.buddies removeObjectForKey:displayName];

            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(buddiesDidChange)]){
                [self.delegate buddiesDidChange];
            }
        }
    }

}

-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    NSLog(@"FAILED TO AUTHENTICATE");
}

-(void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error {
    NSLog(@"ERROR = %@", error.stringValue);
}

-(void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
    [settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
    [settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
}

//- (void)xmppStreamDidConnect:(XMPPStream *)sender
//{
//    NSLog(@"XMPP CONNTECTED");
//    [self.xmppStream authenticateWithPassword:[NSString stringWithFormat:@"%@%@", @"AIR_", self.password] error:nil];
//}
//
//-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
//    NSLog(@"MESSAGE = %@", message.body);
//}

@end