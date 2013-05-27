//
//  FunctionModuleFactory.h
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunctionViewController.h"
@interface FunctionModuleFactory : NSObject
+ (FunctionModuleFactory* )singleton;

- (FunctionViewController* )produceTheFunctionModuleWithIdentifier:(NSString* )Identifier;
@end
