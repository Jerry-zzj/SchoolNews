//
//  DataBaseOperating.m
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataBaseOperating.h"
#import "FMDatabase.h"
#import "AboutTime.h"
//informationObject
#import "NewsObject.h"
#import "NotificationObject.h"
#import "LectureObject.h"
#import "MeetObject.h"
//
#define NOT_EXIT                            100000
@interface DataBaseOperating(private)

@end

@implementation DataBaseOperating
DataBaseOperating* g_DataBaseOperating;
+ (DataBaseOperating* )singleton
{
    if (g_DataBaseOperating == nil) {
        g_DataBaseOperating = [[DataBaseOperating alloc] init];
    }
    return g_DataBaseOperating;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"SchoolNews" ofType:@"sqlite"];
        database_ = [[FMDatabase alloc] initWithPath:filePath];
        if (![database_ open]) {
            NSLog(@"Open failed");
        }
    }
    return self;
}

//get function array
- (NSArray* )getFunctions
{
    FMResultSet* result = [database_ executeQuery:@"SELECT Name FROM FunctionTable"];
    NSMutableArray* temp = [[NSMutableArray alloc] init];
    while ([result next])
    {
        NSString* functionName = [result stringForColumn:@"Name"];
        [temp addObject:functionName];
    }
    
    //[self test];
    return [NSArray arrayWithArray:temp];
}

//get subtitle array for function called |string|
- (NSArray* )getSubtitleForFunction:(NSString* )string
{
    int functionIndex = [self indexForFunction:string];
    if (functionIndex == NOT_EXIT) {
        return nil;
    }
    FMResultSet* subtitleResult = [database_ executeQuery:@"SELECT Name FROM NewsSubtitleTable WHERE FunctionIndex = ?",[NSNumber numberWithInt:functionIndex]];
    NSMutableArray* temp = [[NSMutableArray alloc] init];
    while ([subtitleResult next]) {
        NSString* name = [subtitleResult stringForColumn:@"Name"];
        [temp addObject:name];
    }
    return [NSArray arrayWithArray:temp];
    
}


//get campus hotline
- (NSDictionary* )getCampusHotline
{
    FMResultSet* result = [database_ executeQuery:@"SELECT * FROM CampusHotline"];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    while ([result next]) {
        NSMutableDictionary* campusHotline = [NSMutableDictionary dictionary];
        NSString* department = [result stringForColumn:@"Department"];
        [campusHotline setValue:department forKey:@"Department"];
        
        NSString* hotLineName = [result stringForColumn:@"HotlineName"];
        [campusHotline setValue:hotLineName forKey:@"HotlineName"];
        NSString* phoneNumber = [result stringForColumn:@"phoneNumber"];
        [campusHotline setValue:phoneNumber forKey:@"PhoneNumber"];
        if ([[dictionary allKeys] containsObject:department]) {
            NSMutableArray* array = [dictionary objectForKey:department];
            [array addObject:campusHotline];
        }
        else
        {
            NSMutableArray* array = [NSMutableArray array];
            [array addObject:campusHotline];
            [dictionary setValue:array forKey:department];
        }
    }
    return dictionary;
}

//------------------------------------------------------------------------------
- (int )indexForFunction:(NSString* )function
{
    FMResultSet* functionResult = [database_ executeQuery:@"SELECT FunctionIndex FROM FunctionTable WHERE Name == ?",function];
    int functionIndex = 100;
    if ([functionResult next]) {
        functionIndex = [functionResult intForColumn:@"FunctionIndex"]; 
    }
    else {
        return NOT_EXIT;
    }
    return functionIndex;
}

- (int )indexForSubtitleInFunction:(NSString *)function Subtitle:(NSString* )subtitle
{
    int functionIndex = [self indexForFunction:function];
    if (functionIndex == NOT_EXIT) {
        return NOT_EXIT;
    }
    FMResultSet* result = [database_ executeQuery:@"SELECT SubtitleIndex FROM NewsSubtitleTable WHERE FunctionIndex = ? AND Name = ?",[NSNumber numberWithInt:functionIndex],subtitle];
    int subtitleIndex = NOT_EXIT;
    if ([result next]) {
        subtitleIndex = [result intForColumn:@"SubtitleIndex"];
    }
    return subtitleIndex;
}

- (void )test
{
    BOOL test = [database_ executeUpdate:@"UPDATE Lectures SET Date = ?",[NSDate date]];
    if (!test) {
        NSLog(@"test faild");
    }
}

//get contact information dictionary from all property
- (NSDictionary* )getDictionaryWithName:(NSString* )name
                             Department:(NSString* )department
                                   CMCC:(NSString* )cmcc
                               CHINANET:(NSString* )chinanet
                                 UNICOM:(NSString* )unicom
                        MainPhoneNumber:(NSString* )mainPhoneNumber
                            OfficePhone:(NSString* )officePhone
                             HousePhone:(NSString* )housePhone
                                    Job:(NSString* )job
                     ReservePhoneNumber:(NSString* )reservePhoneNumber
                           XiaShaNumber:(NSString* )xiassaNumber
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithCapacity:11];
    if (name)
    {
        [dictionary setValue:name forKey:@"姓名"];
    }
    if (department)
    {
        [dictionary setValue:department forKey:@"部门"];
    }
    if (cmcc) {
        [dictionary setValue:cmcc forKey:@"移动"];
    }
    if (chinanet) {
        [dictionary setValue:chinanet forKey:@"电信"];
    }
    if (unicom) {
        [dictionary setValue:unicom forKey:@"联通"];
    }
    if (mainPhoneNumber) {
        [dictionary setValue:mainPhoneNumber forKey:@"主要电话"];
    }
    if (officePhone) {
        [dictionary setValue:officePhone forKey:@"办公室号码"];
    }
    if (housePhone) {
        [dictionary setValue:housePhone forKey:@"家庭电话"];
    }
    if (job) {
        [dictionary setValue:job forKey:@"职务"];
    }
    if (reservePhoneNumber)
    {
        [dictionary setValue:reservePhoneNumber forKey:@"备用电话"];
    }
    if (xiassaNumber) {
        [dictionary setValue:xiassaNumber forKey:@"下沙短号"];
    }
    return dictionary;
}

@end
