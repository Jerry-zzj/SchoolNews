//
//  ContactsDictionaryTransform.h
//  SchoolNews
//
//  Created by Jerry on 1月15星期二.
//
//

#import <Foundation/Foundation.h>

@interface ContactsDictionaryTransform : NSObject
+ (id)singleton;
- (NSDictionary* )getContractFromContractDictionary:(NSDictionary* )sender;

@end
