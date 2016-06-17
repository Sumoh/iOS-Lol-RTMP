//
// Created by Tristan Pollard on 2013-10-10.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

///** Stores the data to be consumed while decoding */
//private byte[] dataBuffer;
//        private int dataPos;
//
///** Lists of references and class definitions seen so far */
//        private List<String> stringReferences = new ArrayList<String>();
//private List<Object> objectReferences = new ArrayList<Object>();
//        private List<ClassDefinition> classDefinitions = new ArrayList<ClassDefinition>();


#import <Foundation/Foundation.h>
#import "TypedObject.h"
#import "ClassDefinition.h"


@interface AMF3Decoder : NSObject

@property (nonatomic, retain) NSMutableData *dataBuffer;
@property (nonatomic, assign) int dataPos;

@property (nonatomic, retain) NSMutableArray *stringReferences;
@property (nonatomic, retain) NSMutableArray *objectReferences;
@property (nonatomic, retain) NSMutableArray *classDefinitions;

-(TypedObject *)decodeConnect:(NSData *)data;
-(TypedObject *)decodeInvoke:(NSData *)data;

@end