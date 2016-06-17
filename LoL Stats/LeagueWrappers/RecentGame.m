//
// Created by Tristan Pollard on 2013-10-20.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "RecentGame.h"


@implementation RecentGame {

}

-(id)initWithGameData:(TypedObject *)gameData{
    if ((self = [super init])){
        self.fellowPlayers = [[NSMutableArray alloc] init];
        self.statistics = [[NSMutableDictionary alloc] init];
        [self parseRecentGameData:gameData];
    }

    return self;
}

-(void)parseRecentGameData:(TypedObject *)recentGameData{


    self.gameType = [recentGameData objectForKey:@"gameType"];
    self.experienceEarned = [recentGameData objectForKey:@"experienceEarned"];
    self.eligibileFWOTD = [recentGameData boolForKey:@"eligibleFirstWinOfDay"];
    self.difficultyString = [recentGameData objectForKey:@"difficulty"];
    self.gameMapId = [recentGameData objectForKey:@"gameMapId"];
    self.leaver = [recentGameData boolForKey:@"leaver"];
    self.spell1 = [recentGameData objectForKey:@"spell1"];
    self.spell2 = [recentGameData objectForKey:@"spell2"];
    self.teamID = [recentGameData objectForKey:@"teamId"];
    self.summonerID = [recentGameData objectForKey:@"summonerId"];
    self.afk = [recentGameData boolForKey:@"afk"];
    self.boostXPEarned = [recentGameData objectForKey:@"boostXpEarned"];
    self.level = [recentGameData objectForKey:@"level"];
    self.invalid = [recentGameData boolForKey:@"invalid"];
    self.dataVersion = [recentGameData objectForKey:@"dataVersion"];
    self.userId = [recentGameData objectForKey:@"userId"];
    self.createDate = [recentGameData objectForKey:@"createDate"];
    self.userServerPing = [recentGameData objectForKey:@"userServerPing"];
    self.adjustedRating = [recentGameData objectForKey:@"adjustedRating"];
    self.premadeSize = [recentGameData objectForKey:@"premadeSize"];
    self.boostIPEarned = [recentGameData objectForKey:@"boostIpEarned"];
    self.gameID = [recentGameData objectForKey:@"gameId"];
    self.timeInQueue = [recentGameData objectForKey:@"timeInQueue"];
    self.IPEarned = [recentGameData objectForKey:@"ipEarned"];
    self.eloChange = [recentGameData objectForKey:@"eloChange"];
    self.gameMode = [recentGameData objectForKey:@"gameMode"];
    self.kCoefficient = [recentGameData objectForKey:@"KCoefficient"];
    self.teamRating = [recentGameData objectForKey:@"teamRating"];
    self.subType = [recentGameData objectForKey:@"subType"];
    self.queueType = [recentGameData objectForKey:@"queueType"];
    self.premadeTeam = [recentGameData boolForKey:@"premadeTeam"];
    self.predictedWinPercent = [recentGameData objectForKey:@"predictedWinPct"];
    self.rating = [recentGameData objectForKey:@"rating"];
    self.championID = [recentGameData objectForKey:@"championId"];
    self.skinIndex = [recentGameData objectForKey:@"skinIndex"];
    self.ranked = [recentGameData boolForKey:@"ranked"];
    self.skinName = [recentGameData objectForKey:@"skinName"];
    self.id = [recentGameData objectForKey:@"id"];

    self.fellowPlayers = [recentGameData objectForKey:@"fellowPlayers"];

}

@end