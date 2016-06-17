//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TypedObject.h"


//ArrayList<SummonerMastery> masteries;
//double pageID;
//String name;
//boolean current;
//Date createDate;
//double summonerID;
//Object futureData;
//int dataVersion;
//

@interface MasteryPage : NSObject

@property (nonatomic, retain) NSMutableArray *masteries;
@property (nonatomic, retain) NSNumber *pageId, *summonerId; //double?
@property (nonatomic, retain) NSNumber *dataVersion;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) bool current;
@property (nonatomic, retain) NSArray *futureData;
@property (nonatomic, retain) NSDate *createDate;

-(id)initWithMasteryPage:(TypedObject *)masteryPage;


@end