//
//  AboutTime.m
//  SchoolNews
//
//  Created by shuangchi on 12月17星期一.
//
//

#import "AboutTime.h"

@implementation AboutTime
AboutTime* g_AboutTime;
+ (AboutTime* )singleton
{
    if (g_AboutTime == nil) {
        g_AboutTime = [[AboutTime alloc] init];
    }
    return g_AboutTime;
}

- (NSDate* )getCorrectDate:(NSDate* )date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

- (NSString* )getWeekDay:(NSDate *)date
{
    //不知道为什么这里不需要调整到正确的时间
    /*
    NSDateComponents* test = [[NSDateComponents alloc]init];
    [test setTimeZone:[NSTimeZone systemTimeZone]];
    [test setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [test setYear:2012];
    [test setMonth:12];
    [test setDay:17];
    [test setHour:15];
    [test setMinute:12];
    NSDate* testDate = [self getCorrectDate:[test date]];
    
    */
    //NSDate* localDate = [self getCorrectDate:date];
    //NSLog(@"%@",[localDate description]);
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    [calendar setLocale:[NSLocale systemLocale]];
    [calendar setFirstWeekday:0];
    NSDateComponents* dateComponents = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    NSArray* weekDays = [[NSArray alloc] initWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    int weekDayInt = dateComponents.weekday - 1;
    NSString* weekDay = [weekDays objectAtIndex:weekDayInt];
    return weekDay;
    
}

- (int )getWeekDayReturnInt:(NSDate* )date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    [calendar setLocale:[NSLocale systemLocale]];
    [calendar setFirstWeekday:2];
    //[calendar setMinimumDaysInFirstWeek:7];
    int weekDay = [calendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date];
    //NSArray* weekDays = [[NSArray alloc] initWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    return weekDay;
}

- (NSInteger )getIntervalFromDBDateToDate:(NSDate* )sender
{
    NSDateComponents* test = [[NSDateComponents alloc]init];
    [test setTimeZone:[NSTimeZone systemTimeZone]];
    [test setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [test setYear:1970];
    [test setMonth:1];
    [test setDay:1];
    [test setHour:8];
    [test setMinute:33];
    NSDate* dbDate = [self getCorrectDate:[test date]];
    
    NSInteger interval = [sender timeIntervalSinceDate:dbDate];
    return interval;
}

- (NSDate* )getDateFromString:(NSString *)sender
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+8"]];
    //[NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CMT"]];
    //[dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if ([sender length] == 19) {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else if ([sender length] == 10)
    {
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate* date = [dateformatter dateFromString:sender];
    return [self getCorrectDate:date];
}
@end
