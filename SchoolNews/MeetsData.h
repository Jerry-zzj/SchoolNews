//
//  MeetsData.h
//  SchoolNews
//
//  Created by Jerry on 3月27星期三.
//
//

#import <Foundation/Foundation.h>

@interface MeetsData : NSObject
+ (MeetsData* )singleton;
- (NSDictionary* )getMeetDataForWeek:(int )week AndWeekday:(int )weekday;
- (void )setMeetData:(NSMutableDictionary* )meets ForWeek:(int )week Weekday:(int )weekday;
- (void )addMeets:(NSMutableArray* )meets;
- (void )setInitialWeek:(int )weekSender initialWeekday:(int )weekdaySender date:(NSDate* )date;
- (NSDate* )getDateForWeek:(int )weekSender weekDay:(int )weekdaySender;

- (int )getTodayWeekDay;
- (int )getTodayWeek;
@end
