//
//  SchoolTimeTableModel.m
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

//test account:090708105     password:045416

#import "SchoolTimeTableModel.h"
#import "ClassWebService.h"
#import "WeekIndexWebService.h"
#import "ClassObject.h"
#import "PublicDefines.h"
#import "UsersInformation.h"
@interface SchoolTimeTableModel(privateAPI)

- (NSDictionary* )transformClassArrayToClassesDictionary:(NSArray* )sender;
- (NSString* )getKeyFromClass:(ClassObject* )sender;
- (int )getWeekFromKey:(NSString* )key;
- (int )getWeekDayFromKey:(NSString* )key;
- (void)getWeekIndexFromServerWithWebservice;
- (NSArray* )orderClasses:(NSArray* )sender;

@end

@implementation SchoolTimeTableModel
{
    NSMutableDictionary* classDictionary_;
    ClassWebService* classWebService_;
}
static int weekIndex_;
SchoolTimeTableModel* g_SchoolTimeTableModel;
+ (id )singleton
{
    if (g_SchoolTimeTableModel == nil) {
        g_SchoolTimeTableModel = [[SchoolTimeTableModel alloc] init];
    }
    return g_SchoolTimeTableModel;
}

- (id)init
{
    self = [super init];
    if (self) {
        classDictionary_ = [[NSMutableDictionary alloc] init];
        classWebService_ = [[ClassWebService alloc] init];
        classWebService_.delegate = self;
        weekIndex_ = INT_MAX;
    }
    return self;
}

- (NSDictionary* )getClassesInWeek:(int )week WeekDay:(int )weekDay
{
    NSString* key = [NSString stringWithFormat:@"%i_%i",week,weekDay];
    NSDictionary* class = [classDictionary_ objectForKey:key];
    if (class != nil) {
        return class;
    }
    else
    {
        //没有数据，通过webservice获取
        NSString* studentNumber = [UsersInformation singleton].accountNumber;
        NSString* url = GET_STUDENT_CLASSES(studentNumber, week, weekDay, @"2012-2013", @"2");
        [classWebService_ setURLWithString:url];
        [classWebService_ getWebServiceData];
    }
    return nil;
}

- (int )getTheWeekIndex
{
    if (weekIndex_ == INT_MAX) {
        [self getWeekIndexFromServerWithWebservice];
    }
    return weekIndex_;
}



#pragma mark week index webservice delegate
- (void)getTheWeekIndex:(int )weekIndex
{
    weekIndex_ = weekIndex;
    [self.delegate getTheWeekIndexByWebService:weekIndex];
}

#pragma mark webservice delegate
- (void)finishGetClassData:(id)sender
{
    NSArray* classes = (NSArray* )sender;
    NSDictionary* classDictionary = [self transformClassArrayToClassesDictionary:classes];
    if ([classes count] > 0) {
        NSString* key = [self getKeyFromClass:[classes objectAtIndex:0]];
        [classDictionary_ setObject:classDictionary forKey:key];
        int week = [self getWeekFromKey:key];
        int weekDay = [self getWeekDayFromKey:key];
        [self.delegate getTheClasses:classDictionary AtWeek:week Weekday:weekDay];
    }
}

#pragma mark private api
- (NSDictionary* )transformClassArrayToClassesDictionary:(NSArray* )sender
{
    NSArray* sortedArray = [self orderClasses:sender];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:sortedArray,@"上午", nil];
    return dictionary;
}

- (NSString* )getKeyFromClass:(ClassObject* )sender
{
    NSString* week = sender.week;
    NSString* weekday = sender.weekDay;
    NSString* key = [NSString stringWithFormat:@"%@_%@",week,weekday];
    return key;
}

- (int )getWeekFromKey:(NSString* )key
{
    int index = [key rangeOfString:@"_"].location;
    NSString* weekString = [key substringToIndex:index];
    return [weekString intValue];
}

- (int )getWeekDayFromKey:(NSString* )key
{
    int index = [key rangeOfString:@"_"].location;
    NSString* weekdayString = [key substringFromIndex:index + 1];
    return [weekdayString intValue];
}

- (void)getWeekIndexFromServerWithWebservice
{
    WeekIndexWebService* webservice = [WeekIndexWebService singleton];
    webservice.delegate = self;
    NSString* today = [[[NSDate date] description] substringToIndex:10];
    NSString* urlString = GET_WEEK_INDEX_URL(today);
    [webservice setURLWithString:urlString];
    [webservice getWebServiceData];
}

- (NSArray* )orderClasses:(NSArray* )sender
{
    NSArray* result = [sender sortedArrayUsingSelector:@selector(compare:)];
    return result;
}
@end
