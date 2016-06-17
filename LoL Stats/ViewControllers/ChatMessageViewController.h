//
// Created by Tristan Pollard on 11/11/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LoLChatBuddy.h"
#import "LoLRTMPSClient.h"
#import "LoLChatTableViewCell.h"
#import "ChatViewController.h"

@interface ChatMessageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, LoLChatMessageDelegate, UITextFieldDelegate>

@property (nonatomic, retain) LoLChatBuddy *buddy;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) LoLRTMPSClient *client;
@property (nonatomic, retain) NSString *myUsername;

@property (nonatomic, retain) UITextField *messageField;

-(id)initWithBuddy:(LoLChatBuddy *)buddy;

@end