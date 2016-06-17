//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ProfileTab.h"


@interface MasteryTab : ProfileTab <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@end