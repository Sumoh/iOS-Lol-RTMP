//
// Created by Tristan Pollard on 11/11/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface LoLChatTableViewCell : UITableViewCell
@property (nonatomic, retain) UILabel *senderAndTimeLabel;
@property (nonatomic, retain) UITextView *messageContentView;
@property (nonatomic, retain) UIImageView *bgImageView;

@end