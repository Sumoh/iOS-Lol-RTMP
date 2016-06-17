//
// Created by Tristan Pollard on 2013-10-11.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


///** Server information */
//private static final int port = 2099; // Must be 2099
//private String server;
//        private String region;
//
///** Login information */
//        private boolean loggedIn = false;
//private String loginQueue;
//        private String user;
//        private String pass;
//
///** Garena information */
//        private boolean useGarena = false;
//private String garenaToken;
//        private String userID;
//
///** Secondary login information */
//        private String clientVersion;
//        private String ipAddress;
//        private String locale;
//
///** Connection information */
//        private String authToken;
//        private String sessionToken;
//        private int accountID;

#import "LoLRTMPSClient.h"


@implementation LoLRTMPSClient {

}

+ (id)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    if ((self = [super init])){
        self.loggedIn = false;
        self.port = 2099;
        self.locale = @"en_US";
    }

    return self;
}

-(id)initWithUsername:(NSString *)user andPassword:(NSString *)pass forRegion:(regionTypes)regionId withClientVersion:(NSString *)clientVersion{
    if ((self = [super init])){
        self.loggedIn = false;
        self.user = user;
        self.pass = pass;
        self.region = regionId;
        self.clientVersion = clientVersion;
        self.port = 2099;
        self.locale = @"en_US";
        [self setupServerDetails];
    }

    return self;
}

-(void)setUsername:(NSString *)user andPassword:(NSString *)pass forRegion:(regionTypes)regionId withClientVersion:(NSString *)clientVersion{
    self.user = user;
    self.pass = pass;
    self.region = regionId;
    self.clientVersion = clientVersion;
    [self setupServerDetails];
    //self.chat = [[LoLChat alloc] initWithUsername:self.user andPassword:self.pass];
}



-(void)setupServerDetails{
    switch (self.region){
        case kRegionNA:
            self.server = @"prod.na1.lol.riotgames.com";
            self.loginQueue = @"https://lq.na1.lol.riotgames.com/";
            break;
        case kRegionEUW:
            self.server = @"prod.eu.lol.riotgames.com";
            self.loginQueue = @"https://lq.eu.lol.riotgames.com/";
            break;
        case kRegionEUN:
        case kRegionEUNE:
            self.server = @"prod.eun1.lol.riotgames.com";
            self.loginQueue = @"https://lq.eun1.lol.riotgames.com/";
            break;
        default:
            break;

    }

    [self setConnectionInfo:self.server port:self.port app:@"" swfUrl:@"app:/mod_ser.dat" pageUrl:@""];
   // this.server, port, "", "app:/mod_ser.dat", null
}

//    if (region.equals("NA"))
//    {
//        this.server = "prod.na1.lol.riotgames.com";
//        this.loginQueue = "https://lq.na1.lol.riotgames.com/";
//    }
//    else if (region.equals("EUW"))
//    {
//        this.server = "prod.eu.lol.riotgames.com";
//        this.loginQueue = "https://lq.eu.lol.riotgames.com/";
//    }
//    else if (region.equals("EUN") || region.equals("EUNE"))
//    {
//        this.server = "prod.eun1.lol.riotgames.com";
//        this.loginQueue = "https://lq.eun1.lol.riotgames.com/";
//    }
//    else if (region.equals("KR"))
//    {
//        this.server = "prod.kr.lol.riotgames.com";
//        this.loginQueue = "https://lq.kr.lol.riotgames.com/";
//    }
//    else if (region.equals("BR"))
//    {
//        this.server = "prod.br.lol.riotgames.com";
//        this.loginQueue = "https://lq.br.lol.riotgames.com/";
//    }
//    else if (region.equals("TR"))
//    {
//        this.server = "prod.tr.lol.riotgames.com";
//        this.loginQueue = "https://lq.tr.lol.riotgames.com/";
//    }
//    else if (region.equals("PBE"))
//    {
//        this.server = "prod.pbe1.lol.riotgames.com";
//        this.loginQueue = "https://lq.pbe1.lol.riotgames.com/";
//    }
//    else if (region.equals("SG") || region.equals("MY") || region.equals("SG/MY"))
//    {
//        this.server = "prod.lol.garenanow.com";
//        this.loginQueue = "https://lq.lol.garenanow.com/";
//        this.useGarena = true;
//    }
//    else if (region.equals("TW"))
//    {
//        this.server = "prodtw.lol.garenanow.com";
//        this.loginQueue = "https://loginqueuetw.lol.garenanow.com/";
//        this.useGarena = true;
//    }
//    else if (region.equals("TH"))
//    {
//        this.server = "prodth.lol.garenanow.com";
//        this.loginQueue = "https://lqth.lol.garenanow.com/";
//        this.useGarena = true;
//    }
//    else if (region.equals("PH"))
//    {
//        this.server = "prodph.lol.garenanow.com";
//        this.loginQueue = "https://storeph.lol.garenanow.com/";
//        this.useGarena = true;
//    }
//    else if (region.equals("VN"))
//    {
//        this.server = "prodvn.lol.garenanow.com";
//        this.loginQueue = "https://lqvn.lol.garenanow.com/";
//        this.useGarena = true;
//    }
//    else
//    {
//        System.out.println("Invalid region: " + region);
//        System.out.println("Valid region are: NA, EUW, EUN/EUNE, KR, BR, TR, PBE, SG/MY, TW, TH, PH, VN");
//        System.exit(0);
//    }
//
//    setConnectionInfo(this.server, port, "", "app:/mod_ser.dat", null);
//}


//public void login() throws IOException
//{
//    if (useGarena)
//        body.put("partnerCredentials", "8393 " + garenaToken);
//    else
//        body.put("partnerCredentials", null);
//    int id = invoke("loginService", "login", new Object[] { body });
//
//    body = result.getTO("data").getTO("body");
//    sessionToken = body.getString("token");
//    accountID = body.getTO("accountSummary").getInt("accountId");

-(bool)login{
    if (self.useGarena){
        //[self getGarenaToken];
    }

    [self getIpAddress];

    if (![self getAuthToken]){
        return false;
    }

    NSLog(@"auth token = %@", self.authToken);

    TypedObject *result, *body;
    body = [[TypedObject alloc] initWithType:@"com.riotgames.platform.login.AuthenticationCredentials"];

    if (self.useGarena){
        [body setObject:self.userId forKey:@"username"];
    }else{
        [body setObject:self.user forKey:@"username"];
    }
    [body setObject:self.pass forKey:@"password"];
    [body setObject:self.authToken forKey:@"authToken"];
    [body setObject:self.clientVersion forKey:@"clientVersion"];
    [body setObject:self.ipAddress forKey:@"ipAddress"];
    [body setObject:self.locale forKey:@"locale"];
    [body setObject:@"lolclient.lol.riotgames.com" forKey:@"domain"];
    [body setObject:@"LoLRTMPSClient" forKey:@"operatingSystem"];
    [body setObject:[NSNull null] forKey:@"securityAnswer"];
    [body setObject:[NSNull null] forKey:@"oldPassword"];


    if (self.useGarena){
        [body setObject:[NSString stringWithFormat:@"%i%@", 8393, self.garenaToken] forKey:@"partnerCredentials"];
    }else{
       [body setObject:[NSNull null] forKey:@"partnerCredentials"];
    }

//    NSLog(@"Login packet = %@", body);

    NSArray *test = [NSArray arrayWithObjects:body, nil];
    int id = [self invoke:@"loginService" operation:@"login" body:test];
    result = [self getResult:id];

    if ([((NSString *) [result objectForKey:@"result"]) isEqualToString:@"_error"]){
        NSLog(@"Error getting message!");
    }else{
        NSLog(@"Login Succesfull");
    }

    TypedObject *bla = [result objectForKey:@"data"];
    bla = [bla objectForKey:@"body"];
    self.sessionToken = [bla objectForKey:@"token"];
    bla = [bla objectForKey:@"accountSummary"];
    self.accountId = [bla objectForKey:@"accountId"];

    NSLog(@"Session = %@ ACC Id = %i", self.sessionToken, self.accountId);

    NSMutableData *encbuff = [[NSMutableData alloc] init];

    if (self.useGarena){
        NSString *encBuffStr = [NSString stringWithFormat:@"%@:%@", self.userId, self.sessionToken];
        [encbuff appendData:[encBuffStr dataUsingEncoding:NSUTF8StringEncoding]];
    }else{
        NSString *encBuffStr = [NSString stringWithFormat:@"%@:%@", self.user.lowercaseString, self.sessionToken];
        [encbuff appendData:[encBuffStr dataUsingEncoding:NSUTF8StringEncoding]];
    }

    body = [self wrapBody:[encbuff base64EncodedStringWithOptions:0] destination:@"auth" operation:[NSNumber numberWithInteger:8]]; //base64
    body.type = @"flex.messaging.messages.CommandMessage";

    id = [self invokeObject:body];
    result = [self getResult:id];

    NSArray *bodyArr = [NSArray arrayWithObjects:[[TypedObject alloc] init], nil];
    body = [self wrapBody:bodyArr destination:@"messagingDestination" operation:[NSNumber numberWithInteger:0]];
    body.type = @"flex.messaging.messages.CommandMessage";
    TypedObject *headers = [body objectForKey:@"headers"];

    [headers setObject:@"bc" forKey:@"DSSubtopic"];
    [body setObject:[NSString stringWithFormat:@"bc-%i", self.accountId] forKey:@"clientId"];
    id = [self invokeObject:body];
    result = [self getResult:id];

    [headers setObject:[NSString stringWithFormat:@"cn-%i", self.accountId] forKey:@"DSSubtopic"];
    [body setObject:[NSString stringWithFormat:@"cn-%i", self.accountId] forKey:@"clientId"];
    id = [self invokeObject:body];
    result = [self getResult:id];

    [headers setObject:[NSString stringWithFormat:@"gn-%i", self.accountId] forKey:@"DSSubtopic"];
    [body setObject:[NSString stringWithFormat:@"gn-%i", self.accountId] forKey:@"clientId"];
    id = [self invokeObject:body];
    result = [self getResult:id];

    NSLog(@"running heartbeat...");

    self.heartBeat = [[HeartBeat alloc] initWithClient:self];
    dispatch_queue_t myQueue = dispatch_queue_create("RTMPSClient",NULL);
    dispatch_async(myQueue, ^{
        [self.heartBeat startHeartBeat];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI

        });
    });

    self.loggedIn = true;
    NSLog(@"Connected to region");
//
//    NSArray *summoner = [NSArray arrayWithObjects:@"Sumoh", nil];
//    int e = [self invoke:@"summonerService" operation:@"getSummonerByName" body:summoner];
//    TypedObject *f = [self getResult:e];
//    NSLog(@"f = %@", [f getPrintableDictionary]);
//
//    NSArray *pubData = [NSArray arrayWithObjects:[NSNumber numberWithInteger:41872018], nil];
//    int g = [self invoke:@"summonerService" operation:@"getAllPublicSummonerDataByAccount" body:pubData];
//    TypedObject *h = [self getResult:g];
//    NSLog(@"h = %@", [h getPrintableDictionary]);

    [TestFlight passCheckpoint:@"Login"];

/*USe THIS*/
//    NSArray *cf = [NSArray arrayWithObjects:nil];
//    int c = [self invoke:@"clientFacadeService" operation:@"getLoginDataPacketForUser" body:cf];
//    TypedObject *d = [self getResult:c];
//    d = [[d objectForKey:@"data"] objectForKey:@"body"];
//    NSLog(@"body = %@", d.getPrintableDictionary);
//    NSNumber *rpBalance = [d objectForKey:@"rpBalance"];
//    NSNumber *ipBalance = [d objectForKey:@"ipBalance"];
//
//    NSLog(@"rp = %i ip = %i", rpBalance.integerValue, ipBalance.integerValue);


//    "clientFacadeService",
//            "getLoginDataPacketForUser", new Object[] {}

//    NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithInteger:27312037], nil];
//    int a = [self invoke:@"leaguesServiceProxy" operation:@"getAllLeaguesForPlayer" body:arr];
//    TypedObject *b = [self getResult:a];
//    NSLog(@"B = %@", [b getPrintableDictionary]);

//    "leaguesServiceProxy",
//            "getAllLeaguesForPlayer", new Object[] { summoner.getSummonerID() });

    return true;

}

-(void)getIpAddress{
    if (self.ipAddress != nil){
        return;
    }

    NSURL *url = [NSURL URLWithString:@"http://ll.leagueoflegends.com/services/connection_info"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];

    NSURLResponse *resp;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:nil];


            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([jsonData objectForKey:@"ip_address"]){
                //self.authToken = [jsonData objectForKey:@"token"];
                self.ipAddress = [jsonData objectForKey:@"ip_address"];
                //[self performSelectorOnMainThread:@selector(callAuthenticatedDelegate:) withObject:nil waitUntilDone:YES];
            }else{
                self.ipAddress = @"127.0.0.1";
            }

    //NSLog(@"Got ip = %@", self.ipAddress);

}

-(bool)getAuthToken{
//    NSString *payload;
//    if (self.useGarena){
//        payload = self.garenaToken;
//    }else{
//        payload = [NSString stringWithFormat:@"user=%@,password=%@", self.user, self.pass];
//    }
//    NSString *query = [NSString stringWithFormat:@"payload=%@"]

    NSString *innerPostBody = [NSString stringWithFormat:@"user=%@,password=%@", self.user, self.pass];
    NSString *postBody = [NSString stringWithFormat:@"payload=%@",innerPostBody];

    NSString *authUrl = [NSString stringWithFormat:@"%@login-queue/rest/queue/authenticate", self.loginQueue];

    NSURL *url = [NSURL URLWithString:authUrl];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[postBody dataUsingEncoding:NSASCIIStringEncoding]];

    NSError *error;
    NSURLResponse *urlResp;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&urlResp error:&error];
        if ([data length] > 0 && error == nil){
            NSError *err2 = nil;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err2];
            //NSLog(@"jsonData = %@", jsonData);

            if ([[jsonData objectForKey:@"status"] isEqualToString:@"FAILED"]){
                NSLog(@"failed auth");
            }

            if ([jsonData objectForKey:@"token"] != nil){
                self.authToken = [jsonData objectForKey:@"token"];
                return true;
                //[self performSelectorOnMainThread:@selector(callAuthenticatedDelegate:) withObject:nil waitUntilDone:YES];
            }else{
                //login queue
                int node = [[jsonData objectForKey:@"node"] integerValue];
                NSString *nodeStr = [jsonData objectForKey:@"node"];
                NSString *champ = [jsonData objectForKey:@"champ"];
                int rate = [[jsonData objectForKey:@"rate"] integerValue];
                int delay = [[jsonData objectForKey:@"delay"] integerValue];

                int idInt = 0;
                int cur = 0;
                NSArray *tickers = [jsonData objectForKey:@"tickers"];
                for (id ticker in tickers){
                    TypedObject *to = [[TypedObject alloc] init];
                    to = (NSMutableDictionary *)ticker;
                    NSString *test = [to objectForKey:@"node"];
                    int tnode = test.integerValue;
                    if (tnode != node){
                        continue;
                    }
                    idInt = [[to objectForKey:@"id"] integerValue];
                    cur = [[to objectForKey:@"current"] integerValue];
                }

                NSLog(@"in queue #%i in line", (idInt - cur));

                while (idInt - cur > rate){
                    usleep(delay);
                    
                    NSURL *champUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@login-queue/rest/queue/ticker/%@", self.loginQueue, champ]];

                    NSMutableURLRequest *champReq = [NSMutableURLRequest requestWithURL:champUrl];
                    NSURLResponse *resp;
                    NSData *data = [NSURLConnection sendSynchronousRequest:champReq returningResponse:&resp error:nil];
                    NSDictionary *jsonTemp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                    if (jsonTemp == nil || jsonTemp.count == 0){
                        continue;
                    }

                    cur = [[jsonTemp objectForKey:@"nodeStr"] integerValue];
                    NSLog(@"in login queue #%i", idInt - cur);
                }

                bool hasToken = false;

                while (!hasToken){
                    NSURL *tokenUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@login-queue/rest/queue/authToken/%@", self.loginQueue, self.user.lowercaseString]];
                    NSMutableURLRequest *tokenReq = [NSMutableURLRequest requestWithURL:tokenUrl];
                    NSURLResponse *tokenResp;
                    NSData *tokenData = [NSURLConnection sendSynchronousRequest:tokenReq returningResponse:&tokenResp error:nil];
                    NSDictionary *jsonToken = [NSJSONSerialization JSONObjectWithData:tokenData options:0 error:nil];

                    if ([jsonToken objectForKey:@"token"]){
                        self.authToken = [jsonToken objectForKey:@"token"];
                        hasToken = true;
                        return true;
                    }else{
                        usleep(delay / 10);
                    }
                }

            }
        }
        else if ([data length] == 0 && error == nil)
            NSLog(@"Nothing");
        else if (error != nil)
            NSLog(@"error");

    return false;

}


@end