//
// Created by Tristan Pollard on 2013-10-11.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TypedObject.h"
#import <Foundation/Foundation.h>


@interface AMF3Encoder : NSObject

@property (nonatomic, assign) long long startTime;

-(NSData *)encodeConnect:(NSDictionary *)params;
//-(NSData *)encodeInvoke:(id)obj;
-(NSString *)randomUID;
-(NSData *)encodeInvoke:(int)id obj:(id)obj;

@end