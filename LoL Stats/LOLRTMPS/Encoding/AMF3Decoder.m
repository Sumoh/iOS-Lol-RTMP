//
// Created by Tristan Pollard on 2013-10-10.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AMF3Decoder.h"


@implementation AMF3Decoder {

}

-(id)init {

    if ((self = [super init])){
        self.dataBuffer = [[NSMutableData alloc] init];
        self.objectReferences = [[NSMutableArray alloc] init];
        self.stringReferences = [[NSMutableArray alloc] init];
        self.classDefinitions = [[NSMutableArray alloc] init];
       // self.dataPos = [[NSNumber alloc] init];
    }

    return self;

}

-(void)reset{
    [self.objectReferences removeAllObjects];
    [self.stringReferences removeAllObjects];
    [self.classDefinitions removeAllObjects];
}

-(TypedObject *)decodeConnect:(NSData *)data{
    [self reset];

    self.dataBuffer = [data mutableCopy];
    self.dataPos = 0;

    TypedObject *result = [[TypedObject alloc] initWithType:@"Invoke"];
    [result.dictionary setObject:[self decodeAMF0] forKey:@"result"];
    [result.dictionary setObject:[self decodeAMF0] forKey:@"invokeId"];
    [result.dictionary setObject:[self decodeAMF0] forKey:@"serviceCall"];
    [result.dictionary setObject:[self decodeAMF0] forKey:@"data"];

    if (self.dataPos != self.dataBuffer.length){
        NSLog(@"Data Pos != Data Buffer Len");
    }

    return result;

}

-(TypedObject *)decodeInvoke:(NSData *)data{
    [self reset];

    self.dataBuffer = [data mutableCopy];
    self.dataPos = 0;

    TypedObject *result = [[TypedObject alloc] initWithType:@"Invoke"];
    uint8_t byte;
    NSRange range = NSMakeRange(0, 1);
    [self.dataBuffer getBytes:&byte range:range];
    if (byte == 0x00){
        self.dataPos++;
        [result.dictionary setObject:[NSNumber numberWithInteger:0x00] forKey:@"version"];
    }

    [result.dictionary setObject:[self decodeAMF0] forKey:@"result"];
    [result.dictionary setObject:[self decodeAMF0] forKey:@"invokeId"];
    [result.dictionary setObject:[self decodeAMF0] forKey:@"serviceCall"];
    [result.dictionary setObject:[self decodeAMF0] forKey:@"data"];

    if (self.dataPos != self.dataBuffer.length){
        NSLog(@"Data Pos != Data Buffer Len");
    }

    return result;

}

-(id)decode:(NSData *)data{
    self.dataBuffer = [data mutableCopy];
    self.dataPos = 0;

    id result = [self decode];

    if (self.dataPos != self.dataBuffer.length){
        NSLog(@"Data Pos != Data Buffer Len");
    }

    return result;
}

-(id)decode{
    if (self.dataPos >= self.dataBuffer.length-1){
        return [NSNull null];
    }
    uint8_t type = [self readByte];
    switch (type){
        case 0x00:
            NSLog(@"Undefined");
            break;
        case 0x01:
            return [NSNull null];
        case 0x02:
            return [NSNumber numberWithBool:false];
        case 0x03:
            return [NSNumber numberWithBool:true];
        case 0x04:
            return [self readInt];
        case 0x05:
            return [self readDouble];
        case 0x06:
            return [self readString];
        case 0x07:
            return [self readXml];
        case 0x08:
            return [self readDate];
        case 0x09:
            return [self readArray];
        case 0x0A:
            return [self readObject];
        case 0x0B:
            return [self readXmlString];
        case 0x0C:
            return [self readByteArray];
    }

    NSLog(@"Unexpected Data Type");
    return nil;
}

-(uint8_t)readByte{
    uint8_t byte;
    [self.dataBuffer getBytes:&byte range:NSMakeRange(self.dataPos, 1)];
    self.dataPos++;
    return byte;
}

-(NSNumber *)readByteAsInt{
    int ret = [self readByte];
    if (ret < 0){
        ret += 256;
    }

    return [NSNumber numberWithInteger:ret];
}

-(NSData *)readDataForLength:(int)length{
    NSData *data;
    //NSLog(@"read pso = %i Data = %@",self.dataPos, [self.dataBuffer subdataWithRange:NSMakeRange(self.dataPos, self.dataBuffer.length - self.dataPos)]);
    data = [self.dataBuffer subdataWithRange:NSMakeRange(self.dataPos, length)];
    self.dataPos += length;
    return data;
}


-(NSNumber *)readInt{
    int ret = [self readByteAsInt].integerValue;
    int tmp;

    if (ret < 128){
        return [NSNumber numberWithInteger:ret];
    }else{
        ret = (ret & 0x7f) << 7;
        tmp = [self readByteAsInt].integerValue;
        if (tmp < 128){
            ret = ret | tmp;
        }else{
            ret = (ret | (tmp & 0x7f)) << 7;
            tmp = [self readByteAsInt].integerValue;
            if (tmp < 128){
                ret = ret | tmp;
            }else{
                ret = (ret | (tmp & 0x7f)) << 8;
                tmp = [self readByteAsInt].integerValue;
                ret = ret | tmp;
            }
        }

        int mask = 1 << 28;
        int r = -(ret & mask) | ret;
        return [NSNumber numberWithInteger:r];
    }
}

-(NSNumber *)readDouble{
    long long value = 0;
    for (int i = 0; i < 8; i++){
        value = (value << 8) + [self readByteAsInt].integerValue;
    }

    double doubleValue;
    memcpy(&doubleValue, &value, sizeof doubleValue);

    return [NSNumber numberWithDouble:doubleValue];
}

-(NSString *)readString{
    int handle = [self readInt].integerValue;
    bool isInline = ((handle & 1) != 0);
    handle = handle >> 1;

    if (isInline){
        if (handle == 0){
            return @"";
        }

        NSData *data = [self readDataForLength:handle];

        NSString *str = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        [self.stringReferences addObject:str];

        return str;

    }

    if (handle > self.stringReferences.count){
        return @"POTATOSTR";
    }

    return [self.stringReferences objectAtIndex:handle];

}

-(NSString *)readXml{
    NSLog(@"Not implemented: XML");
    return nil;
}

-(NSDate *)readDate{
    int handle = [self readInt].integerValue;
    bool isInline = ((handle & 1) != 0);
    handle = handle >> 1;

    if (isInline){
        long long ms = (long long)[self readDouble];
        NSTimeInterval dTime = ms / 1000;
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:dTime];

        [self.objectReferences addObject:d];

        return d;
    }

    return (NSDate *)[self.objectReferences objectAtIndex:handle];
}

-(NSArray *)readArray{
    int handle = [self readInt].integerValue;
    bool isInline = ((handle & 1) != 0);
    handle = handle >> 1;

    if (isInline){
        NSString *key = [self readString];
        if (key != nil && ![key isEqualToString:@""]){
            NSLog(@"Associative arrays not supported");
            return nil;
        }

        NSMutableArray *ret = [[NSMutableArray alloc] init];
        for (int i = 0; i < handle; i++){
            [ret addObject:[self decode]];
        }
        [self.objectReferences addObject:ret];

        return ret;
    }

    return [self.objectReferences objectAtIndex:handle];
}

-(id)readObject{
    int handle = [self readInt].integerValue;
    bool isInline = ((handle & 1) != 0);
    handle = handle >> 1;

    if (isInline){
        bool inlineDefine = ((handle & 1) != 0);
        handle = handle >> 1;

        ClassDefinition *cd;
        if (inlineDefine){
            cd = [[ClassDefinition alloc] init];
            cd.type = [self readString];

            cd.externalizable = ((handle & 1) != 0);
            handle = handle >> 1;
            cd.dynamic = ((handle & 1) != 0);
            handle = handle >> 1;

            for (int i = 0; i < handle; i++){
                [cd.members addObject:[self readString]];
            }

            [self.classDefinitions addObject:cd];
        }else{
            //NSLog(@"han = %i classDef = %@", handle, self.classDefinitions);
            cd = [self.classDefinitions objectAtIndex:handle];
        }

        TypedObject *ret = [[TypedObject alloc] initWithType:cd.type];

        if (cd.externalizable){
            if ([cd.type isEqualToString:@"DSK"]){
                ret = [self readDSK];
            }else if([cd.type isEqualToString:@"DSA"]){
                ret = [self readDSA];
            }else if([cd.type isEqualToString:@"flex.messaging.io.ArrayCollection"]){
                id obj = [self decode];
                ret = [[TypedObject alloc] initWithArrayCollection:obj];
            }else if([cd.type isEqualToString:@"com.riotgames.platform.systemstate.ClientSystemStatesNotification"] || [cd.type isEqualToString:@"com.riotgames.platform.broadcast.BroadcastNotification"]){
                int size = 0;
                for (int i = 0; i < 4; i++){
                    size = size * 256 + [self readByteAsInt].integerValue;
                }
                ret = (TypedObject *)[NSJSONSerialization JSONObjectWithData:[self readDataForLength:size] options:0 error:nil];
            }else{

            }
        }else{
            for (int i = 0; i < cd.members.count; i++){
                NSString *key = [cd.members objectAtIndex:i];
                id val = [self decode];
                if (val == nil){
                    val = [NSNull null];
                }
                [ret.dictionary setObject:val forKey:key];
            }

            if (cd.dynamic){
                NSString *key;
                while ( [key = [self readString] length] != 0){
                    id val = [self decode];
                    [ret.dictionary setObject:val forKey:key];
                }
            }
        }

//        objectReferences.add(ret);
        [self.objectReferences addObject:ret];

        return ret;
    }

    //NSLog(@"handle = %i", handle);
    //TODO FIX THIS
    //it makes me cringe
    if (handle > self.objectReferences.count){
        NSLog(@"HANDLE > COUNT");
        return @"POTOTO";
    }
    return [self.objectReferences objectAtIndex:handle-1];
}

-(NSString *)readXmlString{
    NSLog(@"Not implemented yet");
    return nil;
}

-(NSData *)readByteArray{
    int handle = [self readInt].integerValue;
    bool isInline = ((handle & 1) != 0);
    handle = handle >> 1;

    if (isInline){
        NSData *ret = [self readDataForLength:handle];
        [self.objectReferences addObject:ret];
        return ret;
    }

    return (NSData *)[self.objectReferences objectAtIndex:handle];
}

-(TypedObject *)readDSA{
    TypedObject *ret = [[TypedObject alloc] initWithType:@"DSA"];

    NSNumber * flagNS;
    int flag;
    NSMutableArray *flags = [[self readFlags] mutableCopy];
    for (int i = 0; i < flags.count; i++){
        flagNS = (NSNumber *)[flags objectAtIndex:i];
        flag = flagNS.integerValue;
        int bits = 0;
        if (i == 0){
            if ((flag & 0x01) != 0){
                [ret.dictionary setObject:[self decode] forKey:@"body"];
            }
            if ((flag & 0x02) != 0){
                [ret.dictionary setObject:[self decode] forKey:@"clientId"];
            }
            if ((flag & 0x04) != 0){
                [ret.dictionary setObject:[self decode] forKey:@"destination"];
            }
            if ((flag & 0x08) != 0){
                [ret.dictionary setObject:[self decode] forKey:@"headers"];
            }
            if ((flag & 0x10) != 0){
                [ret.dictionary setObject:[self decode] forKey:@"messageId"];
            }
            if ((flag & 0x20) != 0){
                [ret.dictionary setObject:[self decode] forKey:@"timeStamp"];
            }
            if ((flag & 0x40) != 0){
                [ret.dictionary setObject:[self decode] forKey:@"timeToLive"];
            }
            bits = 7;
        }else if(i == 1){
           if ((flag & 0x01) != 0){
               [self readByte];
               NSData *temp = [self readByteArray];
               [ret.dictionary setObject:temp forKey:@"clientIdBytes"];
               [ret.dictionary setObject:[self byteArrayToId:temp] forKey:@"clientId"];
           }
            if ((flag & 0x02) != 0){
                [self readByte];
                NSData *temp = [self readByteArray];
                [ret.dictionary setObject:temp forKey:@"messageIdBytes"];
                [ret.dictionary setObject:[self byteArrayToId:temp] forKey:@"messageId"];
            }
            bits = 2;
        }

        [self readReamining:flag bits:bits];
    }

    flags = [[self readFlags] mutableCopy];
    for (int i = 0; i < flags.count; i++){
        flagNS = (NSNumber *)[flags objectAtIndex:i];
        flag = flagNS.integerValue;
        int bits = 0;

        if (i == 0){
            if ((flag & 0x01) != 0){
                [ret.dictionary setObject:[self decode] forKey:@"correlationid"];
            }
            if ((flag & 0x02) != 0){
                [self readByte];
                NSData *temp = [self readByteArray];
                [ret.dictionary setObject:temp forKey:@"correlationIdBytes"];
                [ret.dictionary setObject:[self byteArrayToId:temp] forKey:@"correlationId"];
            }
            bits = 2;
        }

        [self readReamining:flag bits:bits];
    }

    return ret;
}

-(TypedObject *)readDSK{
    //dsk = dsa + extra flags
    TypedObject * ret = [self readDSA];
    ret.type = @"DSK";

    NSMutableArray *flags = [[self readFlags] mutableCopy];
    for (int i = 0; i < flags.count; i++){
        NSNumber *num = (NSNumber *)[flags objectAtIndex:i];
        [self readReamining:num.integerValue bits:0];
    }

   return ret;
}

-(NSArray *)readFlags{
    NSMutableArray *flags = [[NSMutableArray alloc] init];
    NSNumber *flag;
    do {
        flag = [self readByteAsInt];
        [flags addObject:flag];
    } while ((flag.integerValue & 0x80) != 0);

    return flags;
}

-(void)readReamining:(int)flag bits:(int)bits{
    if ((flag >> bits) != 0){
        for (int i = bits; i < 6; i++){
            if (((flag >> i) & 1) != 0){
                [self decode];
            }
        }
    }
}

-(NSString *)byteArrayToId:(NSData *)data{
    NSMutableString *ret = [[NSMutableString alloc] init];
    for (int i = 0; i < data.length; i++){
        if (i == 4 || i == 6 || i ==8 || i == 10){
            [ret appendString:@"-"];
        }
        uint8_t byte;
        [data getBytes:&byte range:NSMakeRange(i, 1)];
        [ret appendFormat:@"%02x", byte];
    }

    return ret;
}

-(id)decodeAMF0{
    int type = [self readByte];
    switch (type){
        case 0x00:
            return [self readIntAMF0];
        case 0x02:
            return [self readStringAMF0];
        case 0x03:
            return [self readObjectAMF0];
        case 0x05:
            return [NSNull null];
        case 0x11:
            return [self decode];
    }

    NSLog(@"AMF0 Type not supported");
    return nil;
}

-(NSString *)readStringAMF0{
    int readLength1= [self readByteAsInt].integerValue;
    int readLength2 = [self readByteAsInt].integerValue;
    int length = (readLength1 << 8) + readLength2;

    if (length == 0){
        return @"";
    }

    NSData *data = [self readDataForLength:length];

    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    //NSString *str = [[NSString alloc] initWithData:data encoding:NSUnicodeStringEncoding];
    return str;
}

-(NSNumber *)readIntAMF0{
    return [NSNumber numberWithInteger:[self readDouble].integerValue];
}

-(TypedObject *)readObjectAMF0{

    TypedObject *body = [[TypedObject alloc] initWithType:@"Body"];
    NSString *key;
    while ((key = [self readStringAMF0])){
        if (![key isEqualToString:@""]){
            uint8_t b = [self readByte];
            if (b == 0x00){
                [body.dictionary setObject:[self readDouble] forKey:key];
            }else if(b == 0x02){
                NSString *test = [self readStringAMF0];
                [body.dictionary setObject:test forKey:key];
            }else if(b == 0x05){
                [body.dictionary setObject:@"" forKey:key];
            }else{
                NSLog(@"AMFO type not supported %i", b);
            }
        }else{
            break;
        }
    }
    [self readByte];
    return body;
}


@end