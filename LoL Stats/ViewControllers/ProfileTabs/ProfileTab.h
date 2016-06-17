//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LoggedInSummoner.h"

//#import "ProfileViewController.h"
//#import "RecentGamesTab.h"
//#import "RunesTab.h"

@class ProfileViewController;
@class RecentGamesTab;
@class RunesTab;
@class MasteryTab;

@interface ProfileTab : UIViewController <UITabBarDelegate>

@property (nonatomic, retain) UITabBar *summonerTabs;
@property (nonatomic, retain) LoggedInSummoner *summoner;

@property (nonatomic, retain) UITabBarItem *profileItem;
@property (nonatomic, retain) UITabBarItem *recentGamesItem;
@property (nonatomic, retain) UITabBarItem *rankedStatsItem;
@property (nonatomic, retain) UITabBarItem *runesItem;
@property (nonatomic, retain) UITabBarItem *masteriesItem;

@property (nonatomic, retain) UITabBarItem *theSelectedItem;

-(id)initWithSummoner:(LoggedInSummoner *)theSummoner;

@end