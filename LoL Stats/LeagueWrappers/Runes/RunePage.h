//
// Created by Tristan Pollard on 2013-10-22.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TypedObject.h"
#import "RuneSlotEntry.h"

@interface RunePage : NSObject

@property (nonatomic, retain) NSNumber *pageId;
@property (nonatomic, retain) NSString *pageName;

@property (nonatomic, retain) NSDate *dateCreated;
@property (nonatomic, assign) bool current;
@property (nonatomic, retain) NSMutableArray *slots;
@property (nonatomic, retain) NSArray *futureData;
@property (nonatomic, retain) NSNumber *summonerId;
@property (nonatomic, retain) NSNumber *dataVersion;

-(id)initWithRunePageData:(TypedObject *)runePage;


@end