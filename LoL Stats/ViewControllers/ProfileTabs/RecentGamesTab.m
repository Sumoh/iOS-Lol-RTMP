//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "RecentGamesTab.h"
#import "TWTSideMenuViewController.h"


@implementation RecentGamesTab {

}
-(id)init{
    if ((self = [super init])){

    }

    return self;
}

-(void)viewDidLoad {

    [super viewDidLoad];

    self.summonerTabs.selectedItem = self.recentGamesItem;
    self.theSelectedItem = self.recentGamesItem;

    self.view.backgroundColor = [UIColor grayColor];

    self.tableView = [[UITableView alloc] init];
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    self.tableView.frame = CGRectMake(screenSize.origin.x, screenSize.origin.y + 60, screenSize.size.width, screenSize.size.height - 100);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}

-(void)openMenu{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.summoner.recentGames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    RecentGame *game = [self.summoner.recentGames objectAtIndex:indexPath.row];

    [cell.textLabel setText:game.queueType];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end