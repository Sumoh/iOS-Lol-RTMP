//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "RunesTab.h"


@implementation RunesTab {

}

-(id)initWithSummoner:(LoggedInSummoner *)theSummoner {
    if ((self = [super init])){
        self.summoner = theSummoner;
    }

    return self;
}

-(void)viewDidLoad {

    [super viewDidLoad];
    self.theSelectedItem = self.runesItem;
    self.summonerTabs.selectedItem = self.runesItem;

    self.tableView = [[UITableView alloc] init];
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    self.tableView.frame = CGRectMake(screenSize.origin.x, screenSize.origin.y + 60, screenSize.size.width, screenSize.size.height - 100);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    self.view.backgroundColor = [UIColor grayColor];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.summoner.runePages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    RunePage *page = [self.summoner.runePages objectAtIndex:indexPath.row];

    [cell.textLabel setText:page.pageName];

    if (page.current){
        cell.backgroundColor = [UIColor yellowColor];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end