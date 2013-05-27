//
//  DataBase.m
//  SchoolNews
//
//  Created by Jerry on 4月24星期三.
//
//

#import "DataBase.h"
#import "FMDatabase.h"
@implementation DataBase
{
    FMDatabase* database_;
}
DataBase* g_DataBase;
+ (id)singleton
{
    if (g_DataBase == nil) {
        g_DataBase = [[DataBase alloc] init];
    }
    return g_DataBase;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString* sqlitePath = [[NSBundle mainBundle] pathForResource:@"SchoolNews" ofType:@"sqlite"];
        database_ = [[FMDatabase alloc] initWithPath:sqlitePath];
        if ([database_ open]) {
            NSLog(@"数据库打开正常");
        }
        else
        {
            NSLog(@"数据库打开失败");
        }
    }
    return self;
}

- (UserType )getUserTypeWithString:(NSString *)sender
{
    NSString* sql = @"select ID from UserTypeTable where Name = ?";
    FMResultSet* result = [database_ executeQuery:sql,sender];
    int index = 1000;
    while ([result next]) {
        NSString* ID = [result stringForColumn:@"ID"];
        index = [ID intValue];
        break;
    }
    switch (index) {
        case 1:
            return Teacher;
            break;
        case 2:
            return Student;
            break;
        default:
            break;
    }
    NSLog(@"解析用户角色失败");
    return 0;
}

- (NSSet* )getUserRightForType:(UserType )sender
{
    NSString* userTypeID;
    switch (sender) {
        case Teacher:
            userTypeID = @"1";
            break;
        case Student:
            userTypeID = @"2";
            break;
        case Visitor:
            userTypeID = @"3";
        default:
            break;
    }
    
    NSMutableSet* subFunctionCode = [NSMutableSet set];
    NSString* sql = @"select SubFunctionID from UserCompetence where AvailableUserType = ?";
    FMResultSet* result = [database_ executeQuery:sql,userTypeID];
    while ([result next]) {
        NSString* code = [result stringForColumn:@"SubFunctionID"];
        [subFunctionCode addObject:code];
    }
    NSSet* subFunctionNames = [self getSubFunctionNameArray:subFunctionCode];
    return subFunctionNames;
}

- (NSSet* )getSubFunctionNameArray:(NSSet* )codeArray
{
    NSMutableSet* nameSet = [NSMutableSet set];
    [codeArray enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSString* sql = @"select Name from SubFunctionTable where ID = ?";
        FMResultSet* result = [database_ executeQuery:sql,obj];
        while ([result next]) {
            NSString* name = [result stringForColumn:@"Name"];
            [nameSet addObject:name];
        }
        //*stop = YES;
    }];
    return nameSet;
}

- (NSString* )getFunctionName:(NSString* )code
{
    NSString* sql;
    if ([code length] == 2) {
        sql = @"select FunctionName from MainFunctionTable where FunctionID = ?";
    }
    else if ([code length] == 4)
    {
        sql = @"select Name from SubFunctionTable where ID = ?";
    }
    FMResultSet* result = [database_ executeQuery:sql,code];
    while ([result next]) {
        NSString* name = [result objectForColumnIndex:0];
        return name;
    }
    return nil;

}
@end
