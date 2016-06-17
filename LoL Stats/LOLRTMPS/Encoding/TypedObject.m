//
// Created by Tristan Pollard on 2013-10-10.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TypedObject.h"


@implementation TypedObject {

}

-(id)init{
    if ((self = [super init])){
        self.dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(id)initWithType:(NSString *)type{
    if ((self = [super init])){
        self.type = type;
        self.dictionary = [[NSMutableDictionary alloc] init];
    }

    return self;
}

-(id)initWithArrayCollection:(NSArray *)data{
    if ((self = [super init])){
        self.type = @"flex.messaging.io.ArrayCollection";
        self.dictionary = [[NSMutableDictionary alloc] init];
        [self.dictionary setObject:data forKey:@"array"];
    }

    return self;
}


-(NSDictionary *)getPrintableDictionary{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

    for (id key in self.dictionary){
        id obj = [self.dictionary objectForKey:key];
        [dic setObject:[self getObject:obj] forKey:key];
    }

    return [dic copy];
}


-(id)getObject:(id)obj{
    if ([obj isKindOfClass:[TypedObject class]]){
        TypedObject *daObj;
        daObj = (TypedObject *)obj;
        NSDictionary *dic = daObj.dictionary;
        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
        for (id key in dic){
            id obj = [dic objectForKey:key];
            [mutDic setObject:[self getObject:obj] forKey:key];
        }

        return [NSDictionary dictionaryWithDictionary:mutDic];

    }else if([obj isKindOfClass:[NSArray class]]){
        NSArray *arr = (NSArray *)obj;
        NSMutableArray *mutArr = [[NSMutableArray alloc] init];
        for (id obj in arr){
            [mutArr addObject:[self getObject:obj]];
        }
        return [NSArray arrayWithArray:mutArr];
    }

    return obj;
}

-(id)objectForKey:(NSString *)key{
    return [self.dictionary objectForKey:key];
}

-(void)setObject:(id)object forKey:(id <NSCopying>)key{
    [self.dictionary setObject:object forKey:key];
}

-(int)integerForKey:(NSString *)key {
    NSNumber *integer = [self objectForKey:key];
    return integer.integerValue;
}

-(double)doubleForKey:(NSString *)key {
    NSNumber *dbl = [self objectForKey:key];
    return dbl.doubleValue;
}

-(bool)boolForKey:(NSString *)key{
    NSNumber *boolean = [self objectForKey:key];
    return boolean.boolValue;
}

-(NSString *)description {
    return [[self getPrintableDictionary] description];
}


//public static TypedObject makeArrayCollection(Object[] data) {
//    TypedObject ret = new TypedObject("flex.messaging.io.ArrayCollection");
//    ret.put("array", data);
//    return ret;
//}

@end