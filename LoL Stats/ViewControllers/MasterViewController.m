//
//  MasterViewController.m
//  LoL Stats
//
//  Created by Tristan Pollard on 2013-09-09.
//  Copyright (c) 2013 SurrealApplications. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController () {

}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.keyChainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"LoLStatsLoginData" accessGroup:nil];

    CGRect screeSize = [[UIScreen mainScreen] bounds];

    self.client = [LoLRTMPSClient sharedInstance];

    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    self.navigationItem.leftBarButtonItem = menuItem;

    self.view.backgroundColor = [UIColor grayColor];

    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake((screeSize.size.width / 2) - 50, 150, 100, 40)];
    self.statusLabel.text = @"Waiting...";
    self.statusLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.statusLabel];

    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake((screeSize.size.width / 2) - 100, 200, 200, 40)];
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameField.delegate = self;
    [self.view addSubview:self.usernameField];

    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake((screeSize.size.width / 2) - 100, 250, 200, 40)];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.delegate = self;
    [self.view addSubview:self.passwordField];

    self.rememberMe = [[UISwitch alloc] initWithFrame:CGRectMake((screeSize.size.width / 2) - 25, 300, 50, 40)];
    self.rememberMe.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.rememberMe];

    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginButton.frame = CGRectMake((screeSize.size.width / 2) - 50, 350, 100, 40);
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.loginButton.backgroundColor = [UIColor whiteColor];
    [self.loginButton addTarget:self action:@selector(performLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];

    if ([self.keyChainWrapper objectForKey:(__bridge id)kSecAttrAccount]){ //check to see if acc info is stored
        self.usernameField.text = [self.keyChainWrapper objectForKey:(__bridge id)kSecAttrAccount];
        self.passwordField.text = [self.keyChainWrapper objectForKey:(__bridge id)kSecValueData];
        self.rememberMe.on = true;
    }

    if (self.client.connected){
        [self.statusLabel setText:@"Already Connected"];
        [self.loginButton setUserInteractionEnabled:NO];
    }
}

- (void)openButtonPressed
{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return YES;
}

-(void)onLogin{
    self.statusLabel.text = @"Logged in!";

    NSArray *cf = [NSArray arrayWithObjects:nil];
    int c = [self.client invoke:@"clientFacadeService" operation:@"getLoginDataPacketForUser" body:cf];
    TypedObject *d = [self.client getResult:c];
    d = [[d objectForKey:@"data"] objectForKey:@"body"];

    if (self.rememberMe.isOn){
        [self.keyChainWrapper setObject:self.usernameField.text forKey:(__bridge id)kSecAttrAccount];
        [self.keyChainWrapper setObject:self.passwordField.text forKey:(__bridge id)kSecValueData];
    }else{
        [self.keyChainWrapper resetKeychainItem];
    }

    LoggedInSummoner *loggedInSummoner = [LoggedInSummoner getLoggedInSummoner];
    [loggedInSummoner parseLoggedInSummonerData:d];
    NSLog(@"Login Name = %@ IP = %i RP = %i", loggedInSummoner.summonerName, loggedInSummoner.ipBalance.integerValue, loggedInSummoner.rpBalance.integerValue);;

}

-(void)onFailedLogin{
    self.statusLabel.text = @"Login Failed";
    self.loginButton.userInteractionEnabled = true;
}

-(void)performLogin{
    self.loginButton.userInteractionEnabled = false;
    self.statusLabel.text = @"Logging in...";

    [self.client setUsername:self.usernameField.text andPassword:self.passwordField.text forRegion:kRegionNA withClientVersion:@"3.14.13_11_19_11_32"];

    dispatch_queue_t myQueue = dispatch_queue_create("RTMPSClient",NULL);
    dispatch_async(myQueue, ^{

        [self.client connect];
        bool didLogin = [self.client login];

        dispatch_async(dispatch_get_main_queue(), ^{

            if (didLogin){
                [self onLogin];
                self.client.chat = [[LoLChat alloc] initWithUsername:self.client.user andPassword:self.client.pass];
            }else{
                [self onFailedLogin];
            }

        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end