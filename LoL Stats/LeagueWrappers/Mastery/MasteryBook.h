//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TypedObject.h"
#import "MasteryPage.h"


@interface MasteryBook : NSObject
//
//ArrayList<MasteryPage> pages;
//Object bookPagesJson;
//int dataVersion;
//String dateString;
//Object futureData;
//double summonerID;
//
//public MasteryBook(TypedObject ito) {
//    super(ito);
//    bookPagesJson = getProbablyNull("bookPagesJson");
//    dataVersion = getInt("dataVersion");
//    dateString = getString("dateString");
//    futureData = getProbablyNull("futureData");
//    summonerID = getDouble("summonerId");
//    pages = new ArrayList<MasteryPage>();
//    for (TypedObject page : getArray("bookPages")) {
//        pages.add(new MasteryPage(page));
//    }
//    Collections.sort(pages);
//    checkFields();
//}

@property (nonatomic, retain) NSMutableArray *pages;
@property (nonatomic, retain) NSNumber *dataVersion;
@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain) NSNumber *summonerId; //double?

-(id)initWithMasteryBook:(TypedObject *)masteryBook;

@end