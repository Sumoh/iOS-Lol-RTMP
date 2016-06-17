//
// Created by Tristan Pollard on 11/10/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LoLRTMPSClient.h"
#import "ChatMessageViewController.h"


@interface ChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, LoLChatDelegate, LoLChatMessageDelegate>

@property (nonatomic, retain) LoLRTMPSClient *client;
@property (nonatomic, retain) UITableView *tableView;

@end