//
//  MasterViewController.h
//  LoL Stats
//
//  Created by Tristan Pollard on 2013-09-09.
//  Copyright (c) 2013 SurrealApplications. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoLRTMPSClient.h"
#import "TWTSideMenuViewController.h"
#import "Summoner.h"
#import "LoggedInSummoner.h"
#import "KeychainItemWrapper.h"

@interface MasterViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) LoLRTMPSClient *client;
@property (nonatomic, retain) UITextField *usernameField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) UISwitch *rememberMe;
@property (nonatomic, retain) KeychainItemWrapper *keyChainWrapper;

@end