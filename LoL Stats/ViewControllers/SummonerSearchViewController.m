//
// Created by Tristan Pollard on 2013-10-18.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "SummonerSearchViewController.h"


@implementation SummonerSearchViewController {

}

-(void)viewDidLoad {
    CGRect screenSize = [[UIScreen mainScreen] bounds];

    self.client = [LoLRTMPSClient sharedInstance];

    self.view.backgroundColor = [UIColor grayColor];

    UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(openMenu)];
    self.navigationItem.leftBarButtonItem = openItem;

    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake((screenSize.size.width / 2) - 100, 200, 200, 50)];
    self.searchField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchField.delegate = self;
    [self.view addSubview:self.searchField];

    self.searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    self.searchButton.frame = CGRectMake((screenSize.size.width / 2) - 50 , 300, 100, 50);
    [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
    self.searchButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchButton];
}

-(void)awakeFromNib {

}

-(void)search{
    self.searchButton.userInteractionEnabled = NO;

    dispatch_queue_t myQueue = dispatch_queue_create("RTMPSClient",NULL);
    dispatch_async(myQueue, ^{

        NSError *err = nil;
        Summoner *summoner = [[Summoner alloc] initWithSummonerName:self.searchField.text error:&err];

        if (err != nil){
            NSLog(@"error = %@", [err localizedDescription]);
        }else{
            [summoner loadPublicSummonerData:&err];
            [summoner loadLeaguesData:&err];
            [summoner loadRecentGames:&err];
        }

//        NSL

        for (RecentGame *game in summoner.recentGames){
            NSLog(@"Queue = %@ Ping = %i", game.queueType, game.userServerPing.integerValue);
        }
//
        for (Divisions *div in summoner.summonerLeagues){
            NSLog(@"Name = %@ Queue = %@ Rank = %@ Tier = %@", div.divisionName, div.divisionQueue, div.divisionRank, div.divisionTier);
        }

        for (RunePage *runePage in summoner.runePages){
            NSLog(@"Page Id = %i Name = %@", runePage.pageId.integerValue, runePage.pageName);
//            for (RuneSlotEntry *slot in runePage.slots){
//                NSLog(@"RUNEID = %@ NAME = %@ DESCRIP = %@", slot.runeId, slot.rune.name, slot.rune.baseType, slot.rune.description);
//                NSLog(@"GOOD NAME = %@", [summoner.runeNames objectForKey:slot.runeId]);
//                NSLog(@"GOOD DESCRIP = %@", [summoner.runeDescriptions objectForKey:slot.runeId]);
//                for (RuneItemEffect *ie in slot.rune.itemEffects){
//                    NSLog(@"ITEMEFFECT: %@", ie.itemid);
//                }
//            }
        }


        //NSLog(@"Summoner = %@ Sum Id = %i Acc id = %i level = %i", summoner.summonerName, summoner.summonerId.integerValue, summoner.accountId.integerValue, summoner.summonerLevel.integerValue);


        dispatch_async(dispatch_get_main_queue(), ^{
            self.searchButton.userInteractionEnabled = YES;
            [self loadSummoner:summoner];
        });

    });
}

-(void)openMenu{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

-(void)loadSummoner:(Summoner *)summoner{
    ProfileViewController *profileView = [[ProfileViewController alloc] initWithSummoner:summoner];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:profileView];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];

    return YES;
}
@end