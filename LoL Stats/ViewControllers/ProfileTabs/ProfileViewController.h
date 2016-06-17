//
// Created by Tristan Pollard on 2013-10-18.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "TWTSideMenuViewController.h"
#import "LoLRTMPSClient.h"
#import "MenuViewController.h"
#import "Summoner.h"
#import "LoggedInSummoner.h"
#import "RecentGamesTab.h"
#import "ProfileTab.h"

@interface ProfileViewController : ProfileTab <UITextFieldDelegate, UITabBarDelegate>

@property (nonatomic, retain) LoLRTMPSClient *client;
@property (nonatomic, assign) bool isLoggedIn;

@end