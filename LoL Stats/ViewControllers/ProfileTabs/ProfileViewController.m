//
// Created by Tristan Pollard on 2013-10-18.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "ProfileViewController.h"


@implementation ProfileViewController {

}

-(id)initWithSummoner:(Summoner *)theSummoner{
    if ((self = [super init])){
        self.summoner = (LoggedInSummoner *)theSummoner;
        self.client = [LoLRTMPSClient sharedInstance];
        self.isLoggedIn = false;
    }

    return self;
}

-(id)init {
    if ((self = [super init])){
        self.client = [LoLRTMPSClient sharedInstance];
        self.summoner = [LoggedInSummoner getLoggedInSummoner];
        self.isLoggedIn = true;
    }

    return self;
}

-(void)viewDidLoad {

    [super viewDidLoad];

    self.summonerTabs.selectedItem = self.profileItem;
    self.theSelectedItem = self.profileItem;

    self.view.backgroundColor = [UIColor grayColor];

    self.title = self.summoner.summonerName;

    CGRect screenSize = [[UIScreen mainScreen] bounds];
}

-(void)openMenu{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

-(void)awakeFromNib {

}

@end