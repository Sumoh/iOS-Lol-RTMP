//
// Created by Tristan Pollard on 11/11/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "ChatMessageViewController.h"
#import "TWTSideMenuViewController.h"


@implementation ChatMessageViewController {

}


-(id)initWithBuddy:(LoLChatBuddy *)buddy {

    if ((self = [super init])){
        self.buddy = buddy;
        self.title = self.buddy.displayName;
        self.tableView = [[UITableView alloc] init];

        self.client = [LoLRTMPSClient sharedInstance];
        self.client.chat.messageDelegate = self;

        self.myUsername = self.client.chat.username;

        CGRect screenSize = [[UIScreen mainScreen] bounds];
        CGRect screenSize2 = screenSize;
//
        screenSize2.size.height -= 18;

        self.tableView.frame = screenSize2;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.userInteractionEnabled = YES;
        [self.tableView setScrollEnabled:YES];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [self.view addSubview:self.tableView];

        self.messageField = [[UITextField alloc] initWithFrame:CGRectMake(0, 568-20, screenSize.size.width, 20)];
        self.messageField.placeholder = @"MESSAGE HERE";
        self.messageField.borderStyle = UITextBorderStyleRoundedRect;
        self.messageField.delegate = self;
        [self.view addSubview:self.messageField];

        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(openMenuPressed)];
        self.navigationItem.leftBarButtonItem = menuItem;
    }

    return self;

}

-(void)sendChatMessage:(NSString *)chatMessage{

    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:chatMessage];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@", self.buddy.username, @"@pvp.net"]];
    [message addChild:body];
    [self.client.chat.xmppStream sendElement:message];

    LoLChatBuddy *buddy = [self.client.chat.buddies objectForKey:self.buddy.displayName];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:chatMessage forKey:@"msg"];
    [dic setObject:[NSDate date] forKey:@"date"];
    [dic setObject:self.myUsername forKey:@"sender"];
    [buddy.messageHistory addObject:dic];

    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.buddy.messageHistory.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateTextView:YES];
    if (self.buddy.messageHistory.count > 0){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.buddy.messageHistory.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void) animateTextView:(BOOL) up
{
    const int movementDistance = 216; // tweak as needed
    const float movementDuration = 0.4f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);

    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.messageField.frame = CGRectOffset(self.messageField.frame, 0, movement);
    CGRect newSize = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + movement);
    self.tableView.frame = newSize;
    [UIView commitAnimations];
}

-(void)textFieldShouldReturn:(UITextField *)textField {
    [self sendChatMessage:self.messageField.text];
    [textField resignFirstResponder];
    [self animateTextView:NO];
}

-(void)didReceieveMessageForBuddy:(LoLChatBuddy *)buddy{
    if (buddy.displayName == self.buddy.displayName){
//        [self.client.chat.buddies objectForKey:buddy.d]
        buddy.isNewMessage = false;
        [self.tableView reloadData];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.buddy.messageHistory.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)openMenuPressed{
//    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[ChatViewController new]];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buddy.messageHistory.count;
}

static CGFloat padding = 20.0;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";

    LoLChatTableViewCell *cell = (LoLChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[LoLChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }


    NSDictionary *msg = [self.buddy.messageHistory objectAtIndex:indexPath.row];
    NSString *msgTxt = [msg objectForKey:@"msg"];
    NSString *sender = [msg objectForKey:@"sender"];
    NSDate *date = [msg objectForKey:@"date"];

    NSLog(@"MYUSER = %@ SENDER = %@", self.myUsername, sender);

    CGSize  textSize = CGSizeMake(260.0, CGFLOAT_MAX);
    CGRect size = [msgTxt boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:16.0f]} context:nil];

    size.size.width += padding/2;
    CGSize test = size.size;

    CGFloat height = ceilf(test.height);
    CGFloat width = ceilf(test.width);

    cell.userInteractionEnabled = NO;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.messageContentView.text = msgTxt;

    UIImage *bgImage = nil;

    if ([sender isEqualToString:self.myUsername]){

        bgImage = [[UIImage imageNamed:@"orange.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];

        [cell.messageContentView setFrame:CGRectMake(padding, padding + padding/2, width, height+padding)];

        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
                cell.messageContentView.frame.origin.y - padding/4,
                width+padding,
                height+padding)];

    }else{
        bgImage = [[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];

        [cell.messageContentView setFrame:CGRectMake(320 - width - padding,
                padding + padding/2,
                width,
               height+padding)];

        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
                cell.messageContentView.frame.origin.y - padding/4,
               width+padding,
               height+padding)];

    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *dateStr = [dateFormatter stringFromDate:date];

    cell.senderAndTimeLabel.text = dateStr;

    cell.bgImageView.image = bgImage;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *msg = [self.buddy.messageHistory objectAtIndex:indexPath.row];
    NSString *msgTxt = [msg objectForKey:@"msg"];

    CGSize  textSize = CGSizeMake(260.0, CGFLOAT_MAX);
    CGRect size = [msgTxt boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:16.0f]} context:nil];

    size.size.height += padding*2;

    CGSize test = size.size;

    CGFloat height = ceilf(test.height);

    CGFloat heightRet = height < 65 ? 65 : height;
    return heightRet;

}

@end