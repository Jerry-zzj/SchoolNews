//
//  AboutTime.h
//  SchoolNews
//
//  Created by shuangchi on 12月17星期一.
//
//

#import <Foundation/Foundation.h>

@interface AboutTime : NSObject
+ (AboutTime* )singleton;
- (NSString* )getWeekDay:(NSDate* )date;
- (int )getWeekDayReturnInt:(NSDate* )date;
- (NSDate* )getCorrectDate:(NSDate* )date;
- (NSInteger )getIntervalFromDBDateToDate:(NSDate* )sender;
- (NSDate* )getDateFromString:(NSString* )sender;
@end
