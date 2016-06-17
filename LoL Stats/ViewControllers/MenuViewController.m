//
// Created by Tristan Pollard on 2013-10-18.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//


#import "MenuViewController.h"


@implementation MenuViewController {

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.menuItems = [NSArray arrayWithObjects:@"Home", @"Profile", @"Search", @"Chat", @"Another Item", nil];

    CGRect imageViewRect = [[UIScreen mainScreen] bounds];

    self.view.backgroundColor = [UIColor grayColor];

    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"galaxy"]];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundImageView.frame = imageViewRect;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];

//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;


    int startPos = imageViewRect.size.height / 2;
    startPos = startPos - (self.menuItems.count * 20);
    CGRect rect = CGRectMake(0, startPos, 225.0f, imageViewRect.size.height);
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];

//    CGRect imageViewRect = [[UIScreen mainScreen] bounds];
//    imageViewRect.size.width += 589;
//    self.backgroundImageView.frame = imageViewRect;
//    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:self.backgroundImageView];
//
//    NSDictionary *viewDictionary = @{ @"imageView" : self.backgroundImageView };
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
//
//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    closeButton.frame = CGRectMake(10.0f, 100.0f, 200.0f, 44.0f);
//    [closeButton setBackgroundColor:[UIColor whiteColor]];
//    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [closeButton setTitle:@"Home" forState:UIControlStateNormal];
//    [closeButton addTarget:self action:@selector(homeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:closeButton];
//
//    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    changeButton.frame = CGRectMake(10.0f, 200.0f, 200.0f, 44.0f);
//    [changeButton setTitle:@"Search" forState:UIControlStateNormal];
//    [changeButton setBackgroundColor:[UIColor greenColor]];
//    [changeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [changeButton addTarget:self action:@selector(searchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:changeButton];
}

-(void)profileView{
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[ProfileViewController new]];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

-(void)searchView{
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[SummonerSearchViewController new]];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

- (void)homeView
{
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[MasterViewController new]];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

-(void)chatView{
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[ChatViewController new]];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row){
        case 0:
            [self homeView];
            break;
        case 1:
            [self profileView];
            break;
        case 2:
            [self searchView];
            break;
        case 3:
            [self chatView];
            break;

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setText:[self.menuItems objectAtIndex:indexPath.row]];

    return cell;
}


@end