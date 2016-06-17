//
// Created by Tristan Pollard on 2013-10-10.
// Copyright (c) 2013 SurrealApplications. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

//public class ClassDefinition
//{
//    public String type;
//    public boolean externalizable = false;
//    public boolean dynamic = false;
//    public List<String> members = new ArrayList<String>();
//}


#import <Foundation/Foundation.h>


@interface ClassDefinition : NSObject

@property (nonatomic, retain) NSString *type;
@property (nonatomic, assign) bool externalizable;
@property (nonatomic, assign) bool dynamic;
@property (nonatomic, retain) NSMutableArray *members;

@end