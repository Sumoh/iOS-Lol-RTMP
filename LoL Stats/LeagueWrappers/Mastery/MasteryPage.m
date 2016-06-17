//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "MasteryPage.h"


@implementation MasteryPage {

}

-(id)initWithMasteryPage:(TypedObject *)masteryPage{
    if ((self = [super init])){
        self.pageId = [masteryPage objectForKey:@"pageId"];
        self.name = [masteryPage objectForKey:@"name"];
        self.current = [masteryPage boolForKey:@"current"];
        self.createDate = [masteryPage objectForKey:@"createDate"];
        self.summonerId = [masteryPage objectForKey:@"summonerId"];
        self.futureData = [masteryPage objectForKey:@"futureData"];
        self.dataVersion = [masteryPage objectForKey:@"dataVersion"];
    }

    return self;
}

//public MasteryPage(TypedObject ito) {
//    super(ito);
//    masteries = new ArrayList<SummonerMastery>();
//    for (TypedObject mastery : getArray("talentEntries")) {
//        masteries.add(new SummonerMastery(mastery));
//    }
//    pageID = getDouble("pageId");
//    name = getString("name");
//    current = getBool("current");
//    createDate = getDate("createDate");
//    summonerID = getDouble("summonerId");
//    futureData = getObject("futureData");
//    dataVersion = getInt("dataVersion");
//    checkFields();
//}

@end