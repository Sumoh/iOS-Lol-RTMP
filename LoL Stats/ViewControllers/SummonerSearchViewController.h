//
// Created by Tristan Pollard on 2013-10-18.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TWTSideMenuViewController.h"
#import "LoLRTMPSClient.h"
#import "Summoner.h"
#import "RecentGame.h"
#import "RuneType.h"
#import "ProfileViewController.h"

@interface SummonerSearchViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) LoLRTMPSClient *client;

@property (nonatomic, retain) UITextField *searchField;
@property (nonatomic, retain) UIButton *searchButton;

@end