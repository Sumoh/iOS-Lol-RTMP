//
// Created by Tristan Pollard on 2013-10-10.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


//I can't fuckign subclass nsdictionary
//fuck me right?
@interface TypedObject : NSObject

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSMutableDictionary *dictionary;

-(id)initWithType:(NSString *)type;
-(id)initWithArrayCollection:(NSArray *)data;
-(NSDictionary *)getPrintableDictionary;
-(id)objectForKey:(NSString *)key;
-(void)setObject:(id)object forKey:(id <NSCopying>)key;
-(int)integerForKey:(NSString *)key;
-(double)doubleForKey:(NSString *)key;
-(bool)boolForKey:(NSString *)key;

@end