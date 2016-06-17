//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "ProfileTab.h"
#import "TWTSideMenuViewController.h"
#import "ProfileViewController.h"
#import "RunesTab.h"
#import "MasteryTab.h"


@implementation ProfileTab {

}

-(id)initWithSummoner:(LoggedInSummoner *)theSummoner {

    if ((self = [super init])){
        self.summoner = theSummoner;
    }

    return self;

}

-(void)viewDidLoad {
    [self initTabBar];

    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(openMenu)];
    self.navigationItem.leftBarButtonItem = menuItem;
}

-(void)initTabBar{

    self.profileItem = [[UITabBarItem alloc] initWithTitle:@"Main" image:nil tag:1];
    self.recentGamesItem = [[UITabBarItem alloc] initWithTitle:@"Recent" image:nil tag:2];
    self.rankedStatsItem = [[UITabBarItem alloc] initWithTitle:@"Stats" image:nil tag:3];
    self.runesItem = [[UITabBarItem alloc] initWithTitle:@"Runes" image:nil tag:4];
    self.masteriesItem = [[UITabBarItem alloc] initWithTitle:@"Masteries" image:nil tag:5];

    CGRect screenSize = [[UIScreen mainScreen] bounds];
    self.summonerTabs = [[UITabBar alloc] initWithFrame:CGRectMake(0, screenSize.size.height - 40, screenSize.size.width, 40)];
    self.summonerTabs.backgroundColor = [UIColor whiteColor];
    self.summonerTabs.delegate = self;
    [self.summonerTabs setItems:@[self.profileItem, self.recentGamesItem, self.rankedStatsItem, self.runesItem, self.masteriesItem]];

    [self.view addSubview:self.summonerTabs];

}

-(void)openMenu{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {

    if (item.tag == self.theSelectedItem.tag){
        NSLog(@"THE SAME");
        return;
    }

    switch (item.tag){
        case 1:
            [self loadProfileViewController];
            break;
        case 2:
            [self loadRecentGames];
            break;
        case 3:

            break;

        case 4:
            [self loadRunesTab];
            break;
        case 5:
            [self loadMasteryTab];
            break;
    }
}

-(void)loadProfileViewController{
    ProfileViewController *profileView = [[ProfileViewController alloc] initWithSummoner:self.summoner];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:profileView];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:NO];
}

-(void)loadRecentGames{
    RecentGamesTab *recentGamesTab = [[RecentGamesTab alloc] initWithSummoner:self.summoner];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:recentGamesTab];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:NO];
}

-(void)loadRunesTab{
    RunesTab *runesTab = [[RunesTab alloc] initWithSummoner:self.summoner];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:runesTab];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:NO];
}

-(void)loadMasteryTab{
    MasteryTab *masteryTab = [[MasteryTab alloc] initWithSummoner:self.summoner];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:masteryTab];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:NO];
}

@end