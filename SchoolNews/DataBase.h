//
//  DataBase.h
//  SchoolNews
//
//  Created by Jerry on 4月24星期三.
//
//

#import <Foundation/Foundation.h>
#import "UsersInformation.h"
@interface DataBase : NSObject
+ (id)singleton;

- (UserType )getUserTypeWithString:(NSString* )sender;
- (NSSet* )getUserRightForType:(UserType )sender;
- (NSSet* )getSubFunctionNameArray:(NSSet* )codeArray;
- (NSString* )getFunctionName:(NSString* )code;
@end
