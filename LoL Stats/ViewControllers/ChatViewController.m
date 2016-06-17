//
// Created by Tristan Pollard on 11/10/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "ChatViewController.h"
#import "TWTSideMenuViewController.h"


@implementation ChatViewController {

}

-(id)init {

    if ((self = [super init])){
        self.client = [LoLRTMPSClient sharedInstance];
        self.client.chat.delegate = self;
        self.client.chat.messageDelegate = self;

        self.tableView = [[UITableView alloc] init];
        self.tableView.frame = [[UIScreen mainScreen] bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }

    return self;

}

-(void)viewDidLoad {
    [super viewDidLoad];

    CGRect screenSize = [[UIScreen mainScreen] bounds];

    UIBarButtonItem *menuitem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed)];
    self.navigationItem.leftBarButtonItem = menuitem;

}

- (void)menuButtonPressed
{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

-(void)buddiesDidChange{
    [self.tableView reloadData];
}

-(void)didReceieveMessageForBuddy:(LoLChatBuddy *)buddy {
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LoLChatBuddy *buddy = [self.client.chat.buddies objectForKey:[[self.client.chat.buddies allKeys] objectAtIndex:indexPath.row]];
    buddy.isNewMessage = false;
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[[ChatMessageViewController alloc] initWithBuddy:buddy]];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.client.chat.buddies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LoLChatBuddy *buddy = [self.client.chat.buddies objectForKey:[[self.client.chat.buddies allKeys] objectAtIndex:indexPath.row]];
    [cell.textLabel setText:buddy.displayName];

    if (buddy.isNewMessage){
        cell.backgroundColor = [UIColor yellowColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }



    return cell;
}

@end