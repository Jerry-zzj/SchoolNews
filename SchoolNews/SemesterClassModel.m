//
//  SemesterClassModel.m
//  SchoolNews
//
//  Created by Jerry on 5月9星期四.
//
//

#import "SemesterClassModel.h"
#import "ClassWebService.h"
#import "PublicDefines.h"
#import "UsersInformation.h"
#import "ClassObject.h"
@interface SemesterClassModel(private)

- (void)loadTheWebservice;
- (NSDictionary* )transformToDictionaryFromArray:(NSArray* )classes;

@end

@implementation SemesterClassModel
{
    NSArray* semesterClass_;
    ClassWebService* webservice_;
}
/*+ (SemesterClassModel* )singleton
{
    static SemesterClassModel* g_semesterClassModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_semesterClassModel = [[SemesterClassModel alloc] init];
    });
    return g_semesterClassModel;
}*/

SemesterClassModel* g_semesterClassModel;
+ (SemesterClassModel* )singleton
{
    if (g_semesterClassModel == nil) {
        g_semesterClassModel = [[SemesterClassModel alloc] init];
    }
    return g_semesterClassModel;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self loadTheWebservice];
    }
    return self;
}

- (NSDictionary* )getAllClass
{
    if (semesterClass_ == nil) {
        //通过webservice获取学期课表
        NSString* studentNumber = [UsersInformation singleton].accountNumber;
        NSString* urlString = GET_STUDENT_SEMESTER_CLASSES(studentNumber, @"2012-2013", @"2");
        [webservice_ setURLWithString:urlString];
        [webservice_ getWebServiceData];
        return nil;
    }
    return [self transformToDictionaryFromArray:semesterClass_];
}

#pragma mark webservice delegate
- (void)finishGetClassData:(id)sender
{
    if (semesterClass_ != nil) {
        semesterClass_ = nil;
    }
    semesterClass_ = sender;
    NSDictionary* dictionary = [self transformToDictionaryFromArray:sender];
    NSLog(@"%@",NSStringFromClass([self.delegate class]));
    [self.delegate getTheClassFromWebservice:dictionary];
}

#pragma mark private
- (void)loadTheWebservice
{
    webservice_ = [[ClassWebService alloc] init];
    webservice_.delegate = self;
}

- (NSDictionary* )transformToDictionaryFromArray:(NSArray* )classes
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    NSArray* weekDayArray = [NSArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    for (ClassObject* class in classes) {
        int weekDayInt = [class.weekDay integerValue];
        NSString* weekDay = [weekDayArray objectAtIndex:weekDayInt - 1];
        if ([[dictionary allKeys] containsObject:weekDay]) {
            NSMutableArray* classesForWeekDay = [dictionary objectForKey:weekDay];
            [classesForWeekDay addObject:class];
        }
        else
        {
            NSMutableArray* classesForWeekDay = [NSMutableArray array];
            [classesForWeekDay addObject:class];
            [dictionary setObject:classesForWeekDay forKey:weekDay];
        }
    }
    return dictionary;
}
@end
