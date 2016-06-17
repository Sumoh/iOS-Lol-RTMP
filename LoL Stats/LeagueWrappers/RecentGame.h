//
// Created by Tristan Pollard on 2013-10-20.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TypedObject.h"


@interface RecentGame : NSObject

@property (nonatomic, assign) NSNumber *gameMapId;

//@property (nonatomic, retain) NSMutableArray *fellowPlayers;
@property (nonatomic, retain) TypedObject *fellowPlayers;
@property (nonatomic, assign) bool eligibileFWOTD, leaver, afk, premadeTeam, invalid, ranked;
@property (nonatomic, retain) NSDate *createDate;
@property (nonatomic, assign) NSNumber *kCoefficient, *predictedWinPercent, *id; //Doubles
@property (nonatomic, retain) NSMutableDictionary *statistics;
@property (nonatomic, assign) NSNumber *experienceEarned, *spell1, *spell2, *teamID, *userServerPing, *adjustedRating, *premadeSize, *boostXPEarned, *boostIPEarned,
*gameID, *timeInQueue, *dataVersion, *eloChange, *IPEarned, *teamRating, *rating, *championID, *skinIndex, *level, *summonerID, *userId; //Integers
@property (nonatomic, retain) NSString *gameType, *gameMode, *difficultyString, *subType, *queueType, *gameTypeEnum, *skinName;

//Object difficulty, futureData, rawStatsJSON;
//String gameType, gameMode, difficultyString, subType, queueType, gameTypeEnum, skinName;

-(id)initWithGameData:(TypedObject *)gameData;
-(void)parseRecentGameData:(TypedObject *)recentGameData;

@end