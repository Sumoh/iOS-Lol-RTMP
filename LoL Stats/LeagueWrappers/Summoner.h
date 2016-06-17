//
// Created by Tristan Pollard on 2013-10-18.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TypedObject.h"
#import "Divisions.h"
#import "LoLRTMPSClient.h"
#import "RecentGame.h"
#import "RunePage.h"
#import "MasteryBook.h"


@interface Summoner : NSObject

@property (nonatomic, retain) NSString *summonerName;
@property (nonatomic, retain) NSString *previousSeasonHighestTier;

@property (nonatomic, retain) NSNumber *accountId;
@property (nonatomic, retain) NSNumber *summonerId;
@property (nonatomic, retain) NSNumber *summonerLevel;

//todo create another class for ranked division data?
//@property (nonatomic, assign) bool isRanked;
//@property (nonatomic, retain) NSString *soloQueueRank;
//@property (nonatomic, retain) NSString *soloQueueTier;

@property (nonatomic, retain) NSMutableArray *recentGames;
@property (nonatomic, retain) NSMutableArray *summonerLeagues;
@property (nonatomic, retain) NSMutableArray *runePages;

@property (nonatomic, retain) NSMutableDictionary *runeNames;
@property (nonatomic, retain) NSMutableDictionary *runeDescriptions;

@property (nonatomic, assign) bool loggedInSummoner;

-(void)parseSummonerData:(TypedObject *)summonerData;
-(id)initWithAccountId:(NSNumber *)acctId error:(NSError **)error;
-(id)initWithSummonerName:(NSString *)name error:(NSError **)error;
-(void)loadLeaguesData:(NSError **)error;
-(void)loadRecentGames:(NSError **)error;
-(void)loadPublicSummonerData:(NSError **)error;
//-(void)loadRunePages:(NSError **)error;

@end