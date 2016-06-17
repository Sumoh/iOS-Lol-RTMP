//
// Created by Tristan Pollard on 2013-10-11.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

//class Packet
//{
//    private byte[] dataBuffer;
//    private int dataPos;
//    private int dataSize;
//    private int messageType;
//
//    public void setSize(int size)
//    {
//        dataSize = size;
//        dataBuffer = new byte[dataSize];
//    }
//
//    public void setType(int type)
//    {
//        messageType = type;
//    }
//
//    public void add(byte b)
//    {
//        dataBuffer[dataPos++] = b;
//    }
//
//    public boolean isComplete()
//    {
//        return (dataPos == dataSize);
//    }
//
//    public int getSize()
//    {
//        return dataSize;
//    }
//
//    public int getType()
//    {
//        return messageType;
//    }
//
//    public byte[] getData()
//    {
//        return dataBuffer;
//    }
//}


@interface RTMPPacket : NSObject

@property (nonatomic, retain) NSMutableData *dataBuffer;
@property (nonatomic, assign) int dataPas;
@property (nonatomic, assign) int dataSize;
@property (nonatomic, assign) int messageType;

@end