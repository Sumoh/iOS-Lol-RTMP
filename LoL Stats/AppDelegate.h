//
//  AppDelegate.h
//  LoL Stats
//
//  Created by Tristan Pollard on 2013-09-09.
//  Copyright (c) 2013 SurrealApplications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTSideMenuViewController.h"
#import "MasterViewController.h"
#import "MenuViewController.h"
#import "TestFlight.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) TWTSideMenuViewController *sideMenuViewController;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) MasterViewController *mainViewController;

@end