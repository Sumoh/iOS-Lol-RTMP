//
// Created by Tristan Pollard on 2013-10-18.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "LoggedInSummoner.h"


@implementation LoggedInSummoner {

}

+ (id)getLoggedInSummoner
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)parseLoggedInSummonerData:(TypedObject *)summonerData {

    //NSLog(@"PARSING = %@", summonerData.getPrintableDictionary);

    self.loggedInSummoner = true;

    [super parseSummonerData:[summonerData objectForKey:@"allSummonerData"]];

    self.ipBalance = [summonerData objectForKey:@"ipBalance"];
    self.rpBalance = [summonerData objectForKey:@"rpBalance"];


    TypedObject *masteryTo = [[summonerData objectForKey:@"allSummonerData"] objectForKey:@"masteryBook"];
    self.masteryBook = [[MasteryBook alloc] initWithMasteryBook:masteryTo];

}

@end