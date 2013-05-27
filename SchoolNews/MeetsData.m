//
//  MeetsData.m
//  SchoolNews
//
//  Created by Jerry on 3月27星期三.
//
//

#import "MeetsData.h"
#import "AboutTime.h"
#import "MeetObject.h"
#define KEY(week,weekday)                   [NSString stringWithFormat:@"%i_%i",week,weekday]
@implementation MeetsData
{
    NSMutableDictionary* allMeets;
    int initialWeek;
    int initialWeekday;
    NSDate* initialDate;
}
MeetsData* g_MeetsData;
+ (MeetsData* )singleton
{
    if (g_MeetsData == nil) {
        g_MeetsData = [[MeetsData alloc] init];
    }
    return g_MeetsData;
}

- (id)init
{
    self = [super init];
    if (self) {
        allMeets = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSDictionary* )getMeetDataForWeek:(int )week AndWeekday:(int )weekday
{
    NSString* key = KEY(week, weekday);
    if ([[allMeets allKeys] containsObject:key]) {
        return [allMeets objectForKey:key];
    }
    else
    {
        return nil;
        
    }
}

- (void )setMeetData:(NSMutableDictionary* )meets ForWeek:(int )week Weekday:(int )weekday
{
    NSString* key = KEY(week, weekday);
    if (meets != nil) {
        [allMeets setValue:meets forKey:key];
    }
}

- (void )addMeets:(NSMutableArray* )meets
{
    /*for (MeetObject* object in meets) {
        int week = object.week;
        NSString* weekDay = object.weekDay;
        NSString* key = KEY(week, [weekDay intValue]);
        NSMutableDictionary* dictionary = [];
    }*/
}

- (void )setInitialWeek:(int )weekSender initialWeekday:(int )weekdaySender date:(NSDate* )date
{
    initialWeek = weekSender;
    initialWeekday = weekdaySender;
    initialDate = date;
}

#define DAY_SECONDS                         86400
- (NSDate* )getDateForWeek:(int )weekSender weekDay:(int )weekdaySender
{
    int weekGap = weekSender - initialWeek;
    int weekdayGap = weekdaySender - initialWeekday;
    int dayGap = weekGap * 7 + weekdayGap;
    NSDate* resultDate = [initialDate dateByAddingTimeInterval:DAY_SECONDS * dayGap];
    return resultDate;
}

- (int )getTodayWeekDay
{
    NSDate* today = [NSDate date];
    int todayWeekDay = [[AboutTime singleton] getWeekDayReturnInt:today];
    return todayWeekDay;
}

- (int )getTodayWeek
{
    int todayWeekday = [self getTodayWeekDay];
    if (todayWeekday >= initialWeekday) {
        return initialWeek;
    }
    else
    {
        return initialWeek + 1;
    }
}

@end
