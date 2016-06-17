//
// Created by Tristan Pollard on 12/4/2013.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "MasteryTab.h"


@implementation MasteryTab {

}

-(void)viewDidLoad {

    [super viewDidLoad];

    self.view.backgroundColor = [UIColor grayColor];

    self.tableView = [[UITableView alloc] init];
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    self.tableView.frame = CGRectMake(screenSize.origin.x, screenSize.origin.y + 60, screenSize.size.width, screenSize.size.height - 100);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    MasteryPage *page = [self.summoner.masteryBook.pages objectAtIndex:indexPath.row];

    [cell.textLabel setText:page.name];

    if (page.current){
        cell.backgroundColor = [UIColor yellowColor];
    }

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.summoner.masteryBook.pages.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end