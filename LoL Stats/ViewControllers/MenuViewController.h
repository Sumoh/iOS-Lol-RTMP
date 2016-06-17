//
// Created by Tristan Pollard on 2013-10-18.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MasterViewController.h"
#import "TWTSideMenuViewController.h"
#import "LoginViewController.h"
#import "SummonerSearchViewController.h"
#import "ChatViewController.h"
#import "ProfileViewController.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *menuItems;


@end