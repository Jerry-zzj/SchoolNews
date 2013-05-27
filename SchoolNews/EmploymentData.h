//
//  EmploymentData.h
//  SchoolNews
//
//  Created by Jerry on 4月10星期三.
//
//
/*
 type:
 招聘信息
 实习信息
 转载信息
 
 */

#import <Foundation/Foundation.h>

@interface EmploymentData : NSObject
+ (EmploymentData* )singleton;
- (NSDictionary* )getDataForType:(NSString* )sender;
- (void)addEmploymentDatas:(NSArray* )employments ForType:(NSString* )typeSender;
@end
