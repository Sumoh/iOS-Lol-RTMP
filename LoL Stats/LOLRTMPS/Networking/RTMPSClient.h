//
// Created by Tristan Pollard on 2013-10-11.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AMF3Decoder.h"
#import "AMF3Encoder.h"
#import "TypedObject.h"
#import "RTMPPacket.h"

//        protected RTMPPacketReader pr;
//

@interface RTMPSClient : NSObject <NSStreamDelegate>

@property (nonatomic, assign) bool debug;

@property (nonatomic, retain) NSString *passphrase;
@property (nonatomic, retain) NSString *server;
@property (nonatomic, retain) NSString *app;
@property (nonatomic, retain) NSString *swfUrl;
@property (nonatomic, retain) NSString *pageurl;
@property (nonatomic, assign) int port;

@property (nonatomic, retain) NSString *DSId;

@property (nonatomic, retain) NSStream *stream;
@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;
@property (nonatomic, retain) AMF3Decoder *packetDecoder;
@property (nonatomic, retain) AMF3Encoder *packetEncoder;

@property (nonatomic, assign) bool connected;
@property (nonatomic, assign) bool reconnecting;
@property (nonatomic, assign) int invokeId;

@property (nonatomic, retain) AMF3Encoder *aec;
@property (nonatomic, retain) AMF3Decoder *adc;
//@property (nonatomic, assign)

@property (nonatomic, retain) NSMutableArray *pendingInvokes;
@property (nonatomic, retain) NSMutableDictionary *results;
@property (nonatomic, retain) NSMutableDictionary *callbacks;

@property (nonatomic, retain) NSMutableDictionary *packets;

@property (nonatomic, assign) uint8_t lastHeader;
@property (nonatomic, assign) bool isNewPacket;

-(TypedObject *)wrapBody:(id)body destination:(NSString *)destination operation:(id)operation;
-(TypedObject *)getResult:(int)id;
-(int)invokeObject:(TypedObject *)packet;
-(int)invoke:(NSString *)destination operation:(NSString *)operation body:(id)body;
-(void)cancel:(int)id;
-(void)connect;
-(void)setConnectionInfo:(NSString *)server port:(int)port app:(NSString *)app swfUrl:(NSString *)swfUrl pageUrl:(NSString *)pageUrl;

@end
///** Receive handler */
//protected volatile Callback receiveCallback = null;