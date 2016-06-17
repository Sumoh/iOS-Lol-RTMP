//
// Created by Tristan Pollard on 2013-10-11.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AMF3Encoder.h"

@implementation AMF3Encoder {

}

-(id)init {
    if ((self = [super init])){
        self.startTime = (long long)[[NSDate date] timeIntervalSince1970] * 1000;
    }

    return self;
}

-(NSData *)addHeaders:(NSData *)data{

    NSMutableData *result = [[NSMutableData alloc] init];

    uint8_t byte = 0x03;
    [result appendBytes:&byte length:sizeof(byte)];

    long long timediff = ((long long)[[NSDate date] timeIntervalSince1970] * 1000) - self.startTime;
    byte = (uint8_t )((timediff & 0xFF0000) >> 16);
    [result appendBytes:&byte length:sizeof(byte)];
    byte = (uint8_t )((timediff & 0x00FF00) >> 8);
    [result appendBytes:&byte length:sizeof(byte)];
    byte = (uint8_t )((timediff & 0x0000FF));
    [result appendBytes:&byte length:sizeof(byte)];

    byte = (uint8_t )((data.length & 0xFF0000) >> 16);
    [result appendBytes:&byte length:sizeof(byte)];
    byte = (uint8_t )((data.length & 0x00FF00) >> 8);
    [result appendBytes:&byte length:sizeof(byte)];
    byte = (uint8_t )((data.length & 0x0000FF));
    [result appendBytes:&byte length:sizeof(byte)];

    byte = 0x11;
    [result appendBytes:&byte length:sizeof(byte)];


    byte = 0x00;
    [result appendBytes:&byte length:sizeof(byte)];
    [result appendBytes:&byte length:sizeof(byte)];
    [result appendBytes:&byte length:sizeof(byte)];
    [result appendBytes:&byte length:sizeof(byte)];

    for (int i = 0; i < data.length; i++){
        [data getBytes:&byte range:NSMakeRange(i, 1)];
        [result appendBytes:&byte length:sizeof(byte)];
        if (i % 128 == 127 && i != data.length - 1){
            byte = 0xC3;
            [result appendBytes:&byte length:sizeof(byte)];
        }
    }

    return [result copy];

}

-(NSData *)encodeConnect:(NSDictionary *)params{
    NSMutableData *result = [[NSMutableData alloc] init];

    uint8_t byte;

    [result appendData:[self writeStringAMF0:@"connect"]];
    [result appendData:[self writeIntAMF0:1]];

    byte = 0x11;
    [result appendBytes:&byte length:sizeof(byte)];
    byte = 0x09;
    [result appendBytes:&byte length:sizeof(byte)];
    [result appendData:[self writeAssociativeArray:params]];

    byte = 0x01;
    [result appendBytes:&byte length:sizeof(byte)];
    byte = 0x00;
    [result appendBytes:&byte length:sizeof(byte)];

    [result appendData:[self writeStringAMF0:@"nil"]];
    [result appendData:[self writeStringAMF0:@""]];

    TypedObject *cm = [[TypedObject alloc] initWithType:@"flex.messaging.messages.CommandMessage"];
    [cm.dictionary setObject:[NSNull null] forKey:@"messageRefType"];
    [cm.dictionary setObject:[NSNumber numberWithInteger:5] forKey:@"operation"];
    [cm.dictionary setObject:@"" forKey:@"correlationId"];
    [cm.dictionary setObject:[NSNull null] forKey:@"clientId"];
    [cm.dictionary setObject:@"" forKey:@"destination"];
    [cm.dictionary setObject:[self randomUID] forKey:@"messageId"];
    [cm.dictionary setObject:[NSNumber numberWithDouble:0] forKey:@"timestamp"];
    [cm.dictionary setObject:[NSNumber numberWithDouble:0] forKey:@"timeToLive"];
    [cm.dictionary setObject:[[TypedObject alloc] init] forKey:@"body"];

    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers setObject:[NSNumber numberWithDouble:1] forKey:@"DSMessagingVersion"];
    [headers setObject:@"my-rtmps" forKey:@"DSId"];
    [cm.dictionary setObject:headers forKey:@"headers"];

    byte = 0x11;
    [result appendBytes:&byte length:sizeof(byte)];

    [result appendData:[self encodeObject:cm]];

    NSMutableData *test;
   // test =  [self addHeaders:result];
    test = [NSMutableData dataWithData:[self addHeaders:result]];
    //[result appendData:[self addHeaders:result]];
    byte = 0x14;
    [test replaceBytesInRange:NSMakeRange(7, 1) withBytes:&byte];

    return [test copy];
}

-(NSData *)encodeObject:(id)obj{
    NSMutableData *ret = [[NSMutableData alloc] init];
    uint8_t appendByte;
    if (obj == nil || [obj isKindOfClass:[NSNull class]]){
        appendByte = 0x01;
        [ret appendBytes:&appendByte length:sizeof(appendByte)];
    }else if([obj isKindOfClass:[NSNumber class]]){
        NSNumber *num = (NSNumber *)obj;
        NSString *type = [NSString stringWithCString:[num objCType] encoding:NSUTF8StringEncoding];

        if ([type isEqualToString:@"i"]){ //Integer
            appendByte = 0x04;
            [ret appendBytes:&appendByte length:sizeof(appendByte)];
            [ret appendData:[self writeInt:num.integerValue]];
        }else if([type isEqualToString:@"d"]){ //Double
            appendByte = 0x05;
            [ret appendBytes:&appendByte length:sizeof(appendByte)];
            [ret appendData:[self writeDouble:num.doubleValue]];
        }else if([type isEqualToString:@"c"]){ //Bool
            if (num.boolValue){
                appendByte = 0x03;
                [ret appendBytes:&appendByte length:sizeof(appendByte)];
            }else{
                appendByte = 0x02;
                [ret appendBytes:&appendByte length:sizeof(appendByte)];
            }
        }

    }else if([obj isKindOfClass:[NSString class]]){
        appendByte = 0x06;
        [ret appendBytes:&appendByte length:sizeof(appendByte)];
        [ret appendData:[self writeString:(NSString *)obj]];
    }else if([obj isKindOfClass:[NSData class]]){
        appendByte = 0x0C;
        [ret appendBytes:&appendByte length:sizeof(appendByte)];
        NSData *dat = (NSData *)obj;
       //[ret appendData:dat];
        [ret appendData:[self writeByteArray:dat]];
    }else if([obj isKindOfClass:[NSDate class]]){
        appendByte = 0x08;
        [ret appendBytes:&appendByte length:sizeof(appendByte)];
        [ret appendData:[self writeDate:(long long)[[obj date] timeIntervalSince1970] * 1000]];
        //todo write date
    }else if([obj isKindOfClass:[NSArray class]]){
        appendByte = 0x09;
        [ret appendBytes:&appendByte length:sizeof(appendByte)];
        [ret appendData:[self writeArray:(NSArray *)obj]];
    }else if([obj isKindOfClass:[NSDictionary class]]){
        appendByte = 0x09;
        [ret appendBytes:&appendByte length:sizeof(appendByte)];
        [ret appendData:[self writeAssociativeArray:(NSDictionary *)obj]];
    }else if([obj isKindOfClass:[TypedObject class]]){
        TypedObject *to = (TypedObject *)obj;
        appendByte = 0x0A;
        [ret appendBytes:&appendByte length:sizeof(appendByte)];
        [ret appendData:[self writeObject:to]];
    }

    return ret;
}

-(NSData *)encodeInvoke:(int)id obj:(id)obj{
    NSMutableData *result = [[NSMutableData alloc] init];
    uint8_t byte = 0x00;

    [result appendBytes:&byte length:sizeof(byte)];
    byte = 0x05;
    [result appendBytes:&byte length:sizeof(byte)];
    [result appendData:[self writeIntAMF0:id]];
    [result appendBytes:&byte length:sizeof(byte)];

    byte = 0x11;
    [result appendBytes:&byte length:sizeof(byte)];
    [result appendData:[self encodeObject:obj]];

    NSData *test = [NSData dataWithData:[self addHeaders:result]];
    //[result appendData:[self addHeaders:result]];

    return test;
}

-(NSData *)writeInt:(int)val{
    NSMutableData *result = [[NSMutableData alloc] init];
    uint8_t byte;
    if (val < 0 || val >= 0x200000){
        byte = (uint8_t )(((val >> 22) & 0x7f) | 0x80);
        [result appendBytes:&byte length:sizeof(byte)];
        byte = (uint8_t )(((val >> 15) & 0x7f) | 0x80);
        [result appendBytes:&byte length:sizeof(byte)];
        byte = (uint8_t )(((val >> 8) & 0x7f) | 0x80);
        [result appendBytes:&byte length:sizeof(byte)];
        byte = (uint8_t )(val & 0xFF);
        [result appendBytes:&byte length:sizeof(byte)];
    }else{
        if (val >= 0x4000){
            byte = (uint8_t )(((val >> 14) & 0x7f) | 0x80);
            [result appendBytes:&byte length:sizeof(byte)];
        }
        if (val >= 0x80){
            byte = (uint8_t )(((val >> 7) & 0x7f) | 0x80);
            [result appendBytes:&byte length:sizeof(byte)];
        }
        byte = (uint8_t )(val & 0x7f);
        [result appendBytes:&byte length:sizeof(byte)];
    }

    return [result copy];
}

-(NSData *)writeDouble:(double)val{
    NSMutableData *ret = [[NSMutableData alloc] init];
    if (isnan(val)){
        uint8_t bytes[8];
        bytes[0] = 0x7F;
        bytes[1] = 0xFF;
        bytes[2] = 0xFF;
        bytes[3] = 0xFF;
        bytes[4] = 0xE0;
        bytes[5] = 0x00;
        bytes[6] = 0x00;
        bytes[7] = 0x00;
        [ret appendBytes:&bytes length:sizeof(bytes)];
    }else{
        //[ret appendBytes:&val length:sizeof(val)];
        long long bits = 0;
        memcpy(&bits, &val, sizeof(bits));;
        uint8_t bytes[8];
        for (int i = 0; i < 8; i++){
            bytes[i] = (uint8_t) (bits >> (56 - (i * 8)));
        }

        [ret appendBytes:&bytes length:sizeof(bytes)];
    }

    return [ret copy];

}

-(NSData *)writeString:(NSString *)string{
    NSMutableData *result = [[NSMutableData alloc] init];
    NSData *strData = [string dataUsingEncoding:NSUTF8StringEncoding];

    [result appendData:[self writeInt:((strData.length << 1) | 1)]];
    [result appendData:strData];
    return [result copy];
}

-(NSData *)writeDate:(long long)date{
    NSMutableData *result = [[NSMutableData alloc] init];
    uint8_t byte = 0x01;
    [result appendBytes:&byte length:sizeof(byte)];
    [result appendData:[self writeDouble:(double)date]];

    return [result copy];
}

-(NSData *)writeArray:(NSArray *)obj{
    NSMutableData *result = [[NSMutableData alloc] init];
    uint8_t byte;
    [result appendData:[self writeInt:((obj.count << 1) | 1)]];
    byte = 0x01;
    [result appendBytes:&byte length:sizeof(byte)];

    for (id ob in obj){
        [result appendData:[self encodeObject:ob]];
    }

    return [result copy];
}

-(NSData *)writeAssociativeArray:(NSDictionary *)dic{
    NSMutableData *result = [[NSMutableData alloc] init];
    uint8_t byte = 0x01;
    [result appendBytes:&byte length:sizeof(byte)];
    for (id key in dic){
        id val = [dic objectForKey:key];
        [result appendData:[self writeString:key]];
        [result appendData:[self encodeObject:val]];
    }
    byte = 0x01;
    [result appendBytes:&byte length:sizeof(byte)];

    return [result copy];

}

-(NSData *)writeObject:(TypedObject *)val{
    NSMutableData *result = [[NSMutableData alloc] init];
    uint8_t byte;

    if (val.type == nil || [val.type isEqualToString:@""]){
        byte = 0x0B;
        [result appendBytes:&byte length:sizeof(byte)];
        byte = 0x01;
        [result appendBytes:&byte length:sizeof(byte)];

        for (id key in val.dictionary){
            [result appendData:[self writeString:key]];
            [result appendData:[self encodeObject:[val.dictionary objectForKey:key]]];
        }

        byte = 0x01;
        [result appendBytes:&byte length:sizeof(byte)];
    }else if([val.type isEqualToString:@"flex.messaging.io.ArrayCollection"]){
        byte = 0x07;
        [result appendBytes:&byte length:sizeof(byte)];
        [result appendData:[self writeString:val.type]];
        [result appendData:[self encodeObject:[val.dictionary objectForKey:@"array"]]];
    }else{
        [result appendData:[self writeInt:((val.dictionary.count << 4) | 3)]];
        [result appendData:[self writeString:val.type]];

        NSMutableArray *keyOrder = [[NSMutableArray alloc] init];
        for (id key in val.dictionary){
            [keyOrder addObject:key];
            [result appendData:[self writeString:key]];
        }

        for (id key in keyOrder){
            [result appendData:[self encodeObject:[val.dictionary objectForKey:key]]];
        }
    }

    return [result copy];
}

-(NSData *)writeByteArray:(NSData *)bytes{
    NSLog(@"bbyte array not supported");
    return nil;
}

-(NSData *)writeIntAMF0:(int)val{
    double valDbl = (double)val;
    NSMutableData *result = [[NSMutableData alloc] init];
    uint8_t appendByte = 0x00;
    [result appendBytes:&appendByte length:sizeof(appendByte)];

    long long bits = 0;
    memcpy(&bits, &valDbl, sizeof(bits));;
    uint8_t bytes[8];
    for (int i = 0; i < 8; i++){
        bytes[i] = (uint8_t) (bits >> (56 - (i * 8)));
    }

    [result appendBytes:&bytes length:sizeof(bytes)];

    return [result copy];
}

-(NSData *)writeStringAMF0:(NSString *)str{

    NSData *stringBytes = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *bytes = [[NSMutableData alloc] init];

    uint8_t byte = 0x02;

    [bytes appendBytes:&byte length:sizeof(byte)];

    byte = (uint8_t )((stringBytes.length & 0xFF00) >> 8);
    [bytes appendBytes:&byte length:sizeof(byte)];
    byte = (uint8_t )((stringBytes.length & 0x00FF));
    [bytes appendBytes:&byte length:sizeof(byte)];

    [bytes appendData:stringBytes];

    return [bytes copy];
}

-(NSString *)randomUID{
    uint8_t bytes[16];
    arc4random_buf(bytes, sizeof(bytes));

    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i = 0; i < sizeof(bytes); i++){
        if ( i == 4 || i == 6 || i == 8 || i == 10){
            [str appendString:@"-"];
        }
        [str appendString:[NSString stringWithFormat:@"%02X", bytes[i]]];
    }

    return [str copy];
}
@end