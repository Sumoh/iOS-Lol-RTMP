//
// Created by Tristan Pollard on 11/11/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "LoLChatTableViewCell.h"


@implementation LoLChatTableViewCell {

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
        self.senderAndTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
        self.senderAndTimeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.senderAndTimeLabel];

        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.bgImageView];

        self.messageContentView = [[UITextView alloc] init];
        self.messageContentView.backgroundColor = [UIColor clearColor];
        self.messageContentView.editable = NO;
        self.messageContentView.scrollEnabled = NO;
        [self.messageContentView sizeToFit];
        [self.contentView addSubview:self.messageContentView];
    }
    return self;
}

@end