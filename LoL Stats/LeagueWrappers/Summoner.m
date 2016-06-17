//
// Created by Tristan Pollard on 2013-10-18.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "Summoner.h"


@implementation Summoner {

}

-(id)init{
    if ((self = [super init])){
        [self setupVars];
    }

    return self;
}

-(id)initWithAccountId:(NSNumber *)acctId error:(NSError **)error{
    if ((self = [super init])){
        [self setupVars];
        self.accountId = acctId;
        [self loadPublicSummonerData:error];
    }

    return self;
}

-(id)initWithSummonerName:(NSString *)name error:(NSError **)error{
    if ((self = [super init])){
        [self setupVars];
        [self loadSummonerByName:name error:error];
    }

    return self;
}

-(void)setupVars{
    self.loggedInSummoner = false;
    self.summonerLeagues = [[NSMutableArray alloc] init];
    self.recentGames = [[NSMutableArray alloc] init];
    self.runePages = [[NSMutableArray alloc] init];
    self.runeNames = [[NSMutableDictionary alloc] init];
    self.runeDescriptions = [[NSMutableDictionary alloc] init];
}

-(void)loadSummonerByName:(NSString *)name error:(NSError **)error{
    LoLRTMPSClient *client = [LoLRTMPSClient sharedInstance];
    NSArray *summonerArr = [NSArray arrayWithObjects:name, nil];
    int ret = [client invoke:@"summonerService" operation:@"getSummonerByName" body:summonerArr];
    TypedObject *sumIdData = [client getResult:ret];
    NSNumber *accId = [[[sumIdData objectForKey:@"data"] objectForKey:@"body"] objectForKey:@"acctId"];
    self.accountId = accId;

    if (self.accountId == nil){
        *error = [NSError errorWithDomain:@"Summoner" code:200 userInfo:[NSDictionary dictionaryWithObject:@"Error Loading Summoner" forKey:NSLocalizedDescriptionKey]];
    }
}

-(void)loadPublicSummonerData:(NSError **)error{
    LoLRTMPSClient *client = [LoLRTMPSClient sharedInstance];

    if (self.accountId == nil){
        return;
    }

    NSArray *accIdArr = [NSArray arrayWithObjects:self.accountId, nil];
    int ret = [client invoke:@"summonerService" operation:@"getAllPublicSummonerDataByAccount" body:accIdArr];
    TypedObject *summonerData = [client getResult:ret];
    summonerData = [[summonerData objectForKey:@"data"] objectForKey:@"body"];
    [self parseSummonerData:summonerData];
}

-(void)parseSummonerData:(TypedObject *)summonerData {

    self.summonerId = [[summonerData objectForKey:@"summoner"] objectForKey:@"sumId"];
    self.summonerName = [[summonerData objectForKey:@"summoner"] objectForKey:@"name"];
    self.summonerLevel = [[summonerData objectForKey:@"summonerLevel"] objectForKey:@"summonerLevel"];
    self.previousSeasonHighestTier = [[summonerData objectForKey:@"summoner"] objectForKey:@"previousSeasonHighestTier"];

    if (!self.loggedInSummoner){
        NSArray *runePageArr = [[[summonerData objectForKey:@"spellBook"] objectForKey:@"bookPages"] objectForKey:@"array"];
        for (TypedObject *runePageData in runePageArr){
            RunePage *page = [[RunePage alloc] initWithRunePageData:runePageData];
            [self.runePages addObject:page];

            for (RuneSlotEntry *theSlot in page.slots){

                if (![self.runeNames objectForKey:theSlot.runeId] &&theSlot.rune.name != nil){
                    if (![theSlot.rune.name isEqualToString:@"Black"] && ![theSlot.rune.name isEqualToString:@"Blue"] && ![theSlot.rune.name isEqualToString:@"Yellow"]){
                        [self.runeNames setObject:theSlot.rune.name forKey:theSlot.runeId];
                        [self.runeDescriptions setObject:theSlot.rune.description forKey:theSlot.runeId];
                    }
                }

            }
        }
    }
}

-(void)loadLeaguesData:(NSError **)error{
    //TODO leagues class?
    if (self.summonerId == nil){
        *error = [NSError errorWithDomain:@"Summoner" code:201 userInfo:[NSDictionary dictionaryWithObject:@"Summoner has not been loaded yet" forKey:NSLocalizedDescriptionKey]];
        return;
    }

    LoLRTMPSClient *client = [LoLRTMPSClient sharedInstance];
    NSArray *sumidArr = [NSArray arrayWithObjects:self.summonerId, nil];
    int ret = [client invoke:@"leaguesServiceProxy" operation:@"getAllLeaguesForPlayer" body:sumidArr];

    TypedObject *leagues = [client getResult:ret];
    leagues = [[leagues objectForKey:@"data"] objectForKey:@"body"];

    [self parseLeaguesData:leagues];
}

-(void)parseLeaguesData:(TypedObject *)leagueData{

    NSArray *test = [[leagueData objectForKey:@"summonerLeagues"] objectForKey:@"array"];
    for (TypedObject *obj in test){
        Divisions *div = [[Divisions alloc] initWithDivisionData:obj];
        //[self.summonerLeagues setObject:div forKey:div.divisionQueue];
        [self.summonerLeagues addObject:div];
    }
}

-(void)loadRecentGames:(NSError **)error{
    LoLRTMPSClient *client = [LoLRTMPSClient sharedInstance];

    if (self.accountId == nil){
        *error = [NSError errorWithDomain:@"Summoner" code:202 userInfo:[NSDictionary dictionaryWithObject:@"Summoner has not been loaded yet" forKey:NSLocalizedDescriptionKey]];
        return;
    }

    int ret = [client invoke:@"playerStatsService" operation:@"getRecentGames" body:self.accountId];
    TypedObject *recentGames = [client getResult:ret];
    recentGames = [[recentGames objectForKey:@"data"] objectForKey:@"body"];
    recentGames = [recentGames objectForKey:@"gameStatistics"];

    NSArray *recentGamesArr = [recentGames objectForKey:@"array"];

    for (TypedObject *game in recentGamesArr){
        [self.recentGames addObject:[[RecentGame alloc] initWithGameData:game]];
    }

}

@end