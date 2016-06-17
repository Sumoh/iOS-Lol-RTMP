//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "MasteryBook.h"


@implementation MasteryBook {

}

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

-(id)initWithMasteryBook:(TypedObject *)masteryBook{
    if ((self = [super init])){
        self.dataVersion = [masteryBook objectForKey:@"dataVersion"];
        self.dateString = [masteryBook objectForKey:@"dateVersion"];
        self.summonerId = [masteryBook objectForKey:@"summonerId"];
        self.pages = [[NSMutableArray alloc] init];

        for (TypedObject *thePage in [[masteryBook objectForKey:@"bookPages"] objectForKey:@"array"]){
            MasteryPage *page = [[MasteryPage alloc] initWithMasteryPage:thePage];
            [self.pages addObject:page];
        }
    }

    return self;
}

@end