//
// Created by Tristan Pollard on 2013-10-11.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RTMPSClient.h"


@implementation RTMPSClient {

}

-(id)init {
    if ((self = [super init])){
        self.debug = false;
        self.pendingInvokes = [[NSMutableArray alloc] init];
        self.results = [[NSMutableDictionary alloc] init];
        self.callbacks = [[NSMutableDictionary alloc] init];

        self.aec = [[AMF3Encoder alloc] init];
        self.adc = [[AMF3Decoder alloc] init];

        self.packets = [[NSMutableDictionary alloc] init];

        self.invokeId = 2;
    }

    return self;
}

-(id)initWithServer:(NSString *)server port:(int)port app:(NSString *)app swfUrl:(NSString *)swfUrl pageUrl:(NSString *)pageUrl{
    if ((self = [super init])){
        self.debug = false;
        self.pendingInvokes = [[NSMutableArray alloc] init];
        self.results = [[NSMutableDictionary alloc] init];
        self.callbacks = [[NSMutableDictionary alloc] init];

        self.aec = [[AMF3Encoder alloc] init];
        self.adc = [[AMF3Decoder alloc] init];

        self.packets = [[NSMutableDictionary alloc] init];

        self.server = server;
        self.port = port;
        self.app = app;
        self.swfUrl = swfUrl;
        self.pageurl = pageUrl;

        self.invokeId = 2;

    }

    return self;
}


-(void)setConnectionInfo:(NSString *)server port:(int)port app:(NSString *)app swfUrl:(NSString *)swfUrl pageUrl:(NSString *)pageUrl{
    self.server = server;
    self.port = port;
    self.app = app;
    self.swfUrl = swfUrl;
    self.pageurl = pageUrl;
}

-(void)disconnect{
    self.connected = false;
    [self.inputStream close];
    [self.outputStream close];;
}

-(void)connect{

    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.server, self.port, &readStream, &writeStream);

    /* Set the properties for the SSL Connection */
    NSDictionary *sslSettings = @{(NSString *)kCFStreamSSLLevel: (NSString *)kCFStreamSocketSecurityLevelNegotiatedSSL,
            (NSString *)kCFStreamSSLAllowsExpiredCertificates: @(YES),
            (NSString *)kCFStreamSSLAllowsExpiredRoots: @(YES),
            (NSString *)kCFStreamSSLAllowsAnyRoot: @(YES),
            (NSString *)kCFStreamSSLValidatesCertificateChain: @(NO),
            (NSString *)kCFStreamSSLPeerName: [NSNull null]};

    CFReadStreamSetProperty((CFReadStreamRef)readStream, kCFStreamPropertySSLSettings, (__bridge CFTypeRef)(sslSettings));
    CFWriteStreamSetProperty((CFWriteStreamRef)writeStream, kCFStreamPropertySSLSettings, (__bridge CFTypeRef)(sslSettings));

    /* Take advantage of NSSocket + CFStream Toll Free bridging */
    self.inputStream = (__bridge_transfer NSInputStream *)readStream;
    self.outputStream = (__bridge_transfer NSOutputStream *)writeStream;


    //-----------------------------------
    // Error Check streams
    //-----------------------------------
    if (!self.outputStream || !self.inputStream)
    {
        //*error = [NSError errorWithDomain:@"com.RTMPSClient.Connect" code:503 userInfo:@{NSLocalizedDescriptionKey: @"Failed to create output/input stream"}];
        NSLog(@"SOmething wen't wrong");
        return;
    }

    if ([self.outputStream streamError])
    {
        //*error = [self.outputStream streamError];
        NSLog(@"output stream error");
        return;
    }

    if ([self.inputStream streamError])
    {
        //*error = [self.inputStream streamError];
        NSLog(@"Input stream error");
        return;
    }
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];

    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
    [self.outputStream open];

    NSLog(@"Connected");

    [self doHandshake];

    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        [self startPacketListening];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI

        });
    });


//    dispatch_async(dispatch_get_main_queue(), ^{
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSLog(@"listening for packets...");
//            [self startPacketListening];
//
//        });
//    });

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"" forKey:@"app"];
    [dic setObject:@"WIN 10,1,85,3" forKey:@"flashVer"];
    [dic setObject:self.swfUrl forKey:@"swfUrl"];
    [dic setObject:[NSString stringWithFormat:@"rtmps://%@:%i", self.server, self.port] forKey:@"tcUrl"];
    [dic setObject:[NSNumber numberWithBool:NO] forKey:@"fpad"];
    [dic setObject:[NSNumber numberWithInteger:239] forKey:@"capabilities"];
    [dic setObject:[NSNumber numberWithInteger:3191] forKey:@"audioCodecs"];
    [dic setObject:[NSNumber numberWithInteger:252] forKey:@"videoCodecs"];
    [dic setObject:[NSNumber numberWithInteger:1] forKey:@"videoFunction"];
    [dic setObject:[NSNull null] forKey:@"pageUrl"];
    [dic setObject:[NSNumber numberWithInteger:3] forKey:@"objectEncoding"];

    NSData *connectPacket = [self.aec encodeConnect:dic];

    [self.outputStream write:[connectPacket bytes] maxLength:[connectPacket length]];

//    while (!results.containsKey(1))
//        sleep(10);
//    TypedObject result = results.get(1);
//    DSId = result.getTO("data").getString("id");
    while (![self.results objectForKey:[NSNumber numberWithInteger:1]]){
       // NSLog(@"waiting...");
        usleep(10);
    }


    TypedObject *result;
    result = [self.results objectForKey:[NSNumber numberWithInteger:1]];
    //NSLog(@"CONNECT RESULT = %@", [result getPrintableDictionary]);
    TypedObject *data = [result.dictionary objectForKey:@"data"];
    self.DSId = [data.dictionary objectForKey:@"id"];
    //NSLog(@"DSID = %@", self.DSId);

    self.connected = true;

}

-(void)doHandshake{
    // C0
    uint8_t C0 = 0x03;
    [self.outputStream write:&C0 maxLength:sizeof(C0)];

    //C1
    uint8_t randC1[1528];
    arc4random_buf(&randC1, 1528);

    NSData *data = [NSData dataWithBytes:&randC1 length:1528];
    int zero = 0x00;

    [self.outputStream write:&zero maxLength:sizeof(zero)];
    [self.outputStream write:&zero maxLength:sizeof(zero)];
    [self.outputStream write:&randC1 maxLength:1528];

// S0
    uint8_t S0 = 0x09;
    [self.inputStream read:&S0 maxLength:sizeof(S0)];
    NSAssert(S0 == 0x03, @"Server returned incorrect version in handshake: %x", S0);

    // S1
    uint8_t S1[1536];
    [self.inputStream read:&S1 maxLength:1536];

    // C2
    uint8_t S1Truncate[1528];
    for (int i = 0; i < 1528; i++)
        S1Truncate[i] = S1[i+8];

    [self.outputStream write:&S1 maxLength:4];
    [self.outputStream write:&zero maxLength:sizeof(zero)];
    [self.outputStream write:&S1Truncate maxLength:1528];

    uint8_t S2[1536];
    [self.inputStream read:&S2 maxLength:1536];

    // Validate Handshake
    bool valid = YES;
    for (int i = 8; i < 1536; i++) {
        if (randC1[i - 8] != S2[i]) {
            NSLog(@"i = %i : %x - %x", i, randC1[i - 8], S2[i]);
            valid = NO;
            break;
        }
    }

    NSAssert(valid, @"Server returned invalid handshake");

    NSLog(@"Handshake Success");


}

-(int)invokeObject:(TypedObject *)packet{
    int id = [self nextInvokeId];
    [self.pendingInvokes addObject:[NSNumber numberWithInteger:id]];

    //NSLog(@"INVOKE DIC = %@", [packet stringOutputForTypedObject:packet]);
    //NSLog(@"invoke = %@", [TypedObject getTypedObjectAsDictionary:packet]);
    NSData *data = [self.aec encodeInvoke:id obj:packet];

    [self.outputStream write:[data bytes] maxLength:[data length]];

    return id;
}

-(int)invoke:(NSString *)destination operation:(NSString *)operation body:(id)body{
    TypedObject *obj = [self wrapBody:body destination:destination operation:operation];
    return [self invokeObject:obj];
}


-(TypedObject *)wrapBody:(id)body destination:(NSString *)destination operation:(id)operation{
    TypedObject *headers = [[TypedObject alloc] init];
    [headers.dictionary setObject:[NSNumber numberWithInteger:60] forKey:@"DSRequestTimeout"];
    [headers.dictionary setObject:self.DSId forKey:@"DSId"];
    [headers.dictionary setObject:@"my-rtmps" forKey:@"DSEndpoint"];

    TypedObject *ret = [[TypedObject alloc] initWithType:@"flex.messaging.messages.RemotingMessage"];
    [ret.dictionary setObject:destination forKey:@"destination"];
    [ret.dictionary setObject:operation forKey:@"operation"];
    [ret.dictionary setObject:[NSNull null] forKey:@"source"];
    [ret.dictionary setObject:[NSNumber numberWithInteger:0] forKey:@"timestamp"];
    [ret.dictionary setObject:[self.aec randomUID] forKey:@"messageId"];
    [ret.dictionary setObject:[NSNumber numberWithInteger:0] forKey:@"timeToLive"];
    [ret.dictionary setObject:[NSNull null] forKey:@"clientId"];
    [ret.dictionary setObject:headers forKey:@"headers"];
    [ret.dictionary setObject:body forKey:@"body"];

    //NSLog(@"WRAPPED = %@", ret.dictionary);

    return ret;
}

-(int)nextInvokeId{
    return self.invokeId++;
}

-(bool)isConnected{
    return self.connected;
}

-(TypedObject *)peekResult:(int)id{
    TypedObject *ret;
    if ((ret = [self.results objectForKey:[NSNumber numberWithInteger:id]])){
        [self.results removeObjectForKey:[NSNumber numberWithInteger:id]];
        return ret;
    }
    return nil;
}

-(TypedObject *)getResult:(int)id{

    if (!self.connected){
        return nil;
    }
    //NSLog(@"getting result for %i", id);
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    while (self.isConnected && ![self.results objectForKey:[NSNumber numberWithInteger:id]]){
        usleep(100);

        if ([[NSDate date] timeIntervalSince1970] - startTime > 10){
            return nil;
        }
    }

    TypedObject *ret = [self.results objectForKey:[NSNumber numberWithInteger:id]];
    [self.results removeObjectForKey:[NSNumber numberWithInteger:id]];

    return ret;
}

-(void)join{
    while (self.pendingInvokes.count > 0){
        sleep(10);
    }
}

-(void)join:(int)id{
    while (self.connected && [self.pendingInvokes containsObject:[NSNumber numberWithInteger:id]]){
        sleep(10);
    }
}

-(void)cancel:(int)id{
    [self.pendingInvokes removeObject:[NSNumber numberWithInteger:id]];

    if ([self peekResult:id] != nil){
        return;
    }else{
        [self.callbacks setObject:[NSNull null] forKey:[NSNumber numberWithInteger:id]];

        if ([self peekResult:id] != nil){
            [self.callbacks removeObjectForKey:[NSNumber numberWithInteger:id]];
        }
    }

}


/*CUSTOM METHODS*/

//-(void)startPacketListening{
//[self bytesAvailable];
//}

-(void)startPacketListening{
//    self.packetOffset = 0;
//    self.totalPacketLen = 0;
    self.isNewPacket = true;
    while (true){
        if ([self.inputStream hasBytesAvailable]){
            [self bytesAvailable];
        }
    }
}

//holy shit this is full of brutal hacks

-(void)bytesAvailable{

    uint8_t buff[18432];
    while (self.inputStream.hasBytesAvailable){
        int bytesRead = [self.inputStream read:&buff maxLength:sizeof(buff)];
        if (bytesRead < 0){
            //Failed
            break;
        }else if(bytesRead == 0){
            break;
        }else{
            NSData *bytes = [NSData dataWithBytes:buff length:bytesRead];
            [self parsePackets:bytes];
        }

    }

}

-(void)parsePackets:(NSData *)packet{
    NSMutableData *data = [packet mutableCopy];

    uint8_t basicHeader;
    if (self.isNewPacket){
        [data getBytes:&basicHeader range:NSMakeRange(0, 1)];
        [data replaceBytesInRange:NSMakeRange(0,1) withBytes:nil length:0];
        self.lastHeader = basicHeader;
    }else{
        basicHeader = self.lastHeader;
    }

    int channel = basicHeader & 0x2F;
    int headerType = basicHeader & 0xC0;
    //NSLog(@"basic header = %x type = %x", basicHeader, headerType);

    int headerSize = 0;

    switch (headerType){
        case 0x00:
            headerSize = 12;
            break;
        case 0x40:
            headerSize = 8;
            break;
        case 0x80:
            headerSize = 4;
            break;
        case 0xC0:
            headerSize = 1;
            break;
    }

    if (!self.isNewPacket){
        headerSize = 0;
    }

    if (![self.packets objectForKey:[NSNumber numberWithInteger:channel]]){
        [self.packets setObject:[[RTMPPacket alloc] init] forKey:[NSNumber numberWithInteger:channel]];
    }else{
//        NSLog(@"already got ze packet %i",channel);
    }

    RTMPPacket *p = [self.packets objectForKey:[NSNumber numberWithInteger:channel]];

    if (headerSize > 1){
        uint8_t header[headerSize - 1];

        [data getBytes:&header length:sizeof(header)];
        NSData *headerData = [NSData dataWithBytes:&header length:sizeof(header)];

        NSRange replace2 = NSMakeRange(0, sizeof(header));
        [data replaceBytesInRange:replace2 withBytes:nil length:0];

        if (headerSize >= 8){
            int size = 0;
            uint8_t byte;
            for (int i = 3; i < 6; i++){
                [headerData getBytes:&byte range:NSMakeRange(i, 1)];
                size = size * 256 + (byte & 0xFF);
            }
            [p setDataSize:size];
            [p setMessageType:header[6]];
        }
    }

    [p.dataBuffer appendData:data];

//    self.totalPacketLen += data.length;
//
//    if (self.packetOffset > 0){
//        int removeBytes = (int)((data.length - self.packetOffset) / 128);
//        int removeBytesFix = (int)(((data.length - self.packetOffset) - removeBytes) / 128);
//        removeBytes = removeBytes - (removeBytes - removeBytesFix);
//        self.totalPacketLen -= removeBytes;
//        int currPos = 0;
//
//        NSLog(@"data len = %i offset = %i", data.length, self.packetOffset);
//        [data replaceBytesInRange:NSMakeRange(self.packetOffset, 1) withBytes:nil length:0];
//        for (int i = 1; i <= removeBytes; i++){
//            currPos = (i * 128) + self.packetOffset;
//            NSRange range = NSMakeRange(currPos, 1);
//            //        [data getBytes:&testByte range:range];
//            //NSLog(@"byte = %x", testByte);
//            [data replaceBytesInRange:range withBytes:nil length:0];
//        }
//
//        self.packetOffset = (128 - ((data.length - removeBytes) - (removeBytes * 128)));
//        self.daFlag = true;
//        NSLog(@"offsetxxx = %i",self.packetOffset);
//    }else{
//        int removeBytes = (int)(data.length / 128);
//        int currPos = 0;
//        int removeBytesFix = (int)((data.length - removeBytes) / 128);
//        removeBytes = removeBytes - (removeBytes - removeBytesFix);
//        self.totalPacketLen -= removeBytes;
//        self.packetOffset = (128 - ((data.length - removeBytes) - (removeBytes * 128)));
//        //NSLog(@"removeBytes = %i", removeBytes);
//
//        //NSLog(@"size = %i dataLength = %i remove = %i removed = %i", p.dataSize, data.length, removeBytes, data.length - removeBytes);
//
//        uint8_t testByte;
//        for (int i = 1; i <= removeBytes; i++){
//            currPos = i * 128;
//            NSRange range = NSMakeRange(currPos, 1);
//        //        [data getBytes:&testByte range:range];
//            //NSLog(@"byte = %x", testByte);
//            [data replaceBytesInRange:range withBytes:nil length:0];
//        }
//    }

//    if (p.dataSize > data.length){
//        [p.dataBuffer appendData:data];
//    }else{
//        [p.dataBuffer appendData:[data subdataWithRange:NSMakeRange(0, p.dataSize)]];
//    }

//    uint8_t bytes[data.length - 1];
//    uint8_t byte;
//    [data getBytes:bytes];
//
//    for (int i = 0; i < data.length; i++){
//        if (i % 128 == 0 && i > 0){
//            NSLog(@"skipping %x", bytes[i]);
//        }else{
//            byte = bytes[i];
//            [p.dataBuffer appendBytes:&byte length:1];
//        }
//    }

    //NSLog(@"length = %i size = %i", p.dataBuffer.length, p.dataSize);
    int removeBytes = (int)(p.dataBuffer.length / 128);
    int removeBytesFix = (int)((p.dataBuffer.length - removeBytes) / 128);
    removeBytes = removeBytes - (removeBytes - removeBytesFix);

    if (p.dataSize < p.dataBuffer.length ){
        p.dataBuffer = [[p.dataBuffer subdataWithRange:NSMakeRange(0, p.dataSize + removeBytes)] mutableCopy];
//        if (!self.isNewPacket){
//        p.dataBuffer = [[data subdataWithRange:NSMakeRange(0, p.dataSize + removeBytes)] mutableCopy];
//        }else{
//            [p.dataBuffer appendData:[data subdataWithRange:NSMakeRange(0, p)]];
//        }
    }

//    if (!self.isNewPacket){
//        NSLog(@"length = %i data size = %i", p.dataBuffer.length, p.dataSize);
//    }

    if ((p.dataBuffer.length - removeBytes) != p.dataSize){
        self.isNewPacket = false;
        return;
    }

    int currPos = 0;

    for (int i = 1; i <= removeBytes; i++){
        currPos = i * 128;
        NSRange range = NSMakeRange(currPos, 1);

        if (currPos <= p.dataBuffer.length){
            [p.dataBuffer replaceBytesInRange:range withBytes:nil length:0];
        }
    }

    self.isNewPacket = true;

    [self.packets removeObjectForKey:[NSNumber numberWithInteger:channel]];

    TypedObject *result = [[TypedObject alloc] init];
    if (p.messageType == 0x14){
        NSLog(@"connect packet");
        result = [self.adc decodeConnect:p.dataBuffer];
    }else if(p.messageType == 0x11){
        result = [self.adc decodeInvoke:p.dataBuffer];
    }else if(p.messageType == 0x06){
        NSLog(@"peer bandwidth?");
        //Don't think this is needed?
    }else if(p.messageType == 0x03){
        NSLog(@"ack");
        //this isn't needed either?
    }else{
        NSLog(@"unrecognized message type = %x", p.messageType);
    }

    int id = [[result.dictionary objectForKey:@"invokeId"] integerValue];

    if (id == 0 || id == nil){

    }else if([self.callbacks objectForKey:[NSNumber numberWithInteger:id]]){

    }else{
        //NSLog(@"adding result for id = %i", id);
        [self.results setObject:result forKey:[NSNumber numberWithInteger:id]];
    }

}



@end