//
// Created by Tristan Pollard on 2013-10-18.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Summoner.h"
#import "TypedObject.h"
#import "MasteryBook.h"

@interface LoggedInSummoner : Summoner



@property (nonatomic, nonatomic) NSNumber *rpBalance;
@property (nonatomic, nonatomic) NSNumber *ipBalance;

@property (nonatomic, retain) MasteryBook *masteryBook;


+(id)getLoggedInSummoner;
-(void)parseLoggedInSummonerData:(TypedObject *)summonerData;

@end