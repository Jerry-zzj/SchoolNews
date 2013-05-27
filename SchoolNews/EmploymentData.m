//
//  EmploymentData.m
//  SchoolNews
//
//  Created by Jerry on 4月10星期三.
//
//

#import "EmploymentData.h"
#import "JobObject.h"

@implementation EmploymentData
{
    NSMutableDictionary* employmentDictionary_;
    
}
EmploymentData* g_EmploymentData;
+ (EmploymentData* )singleton
{
    if (g_EmploymentData == nil) {
        g_EmploymentData = [[EmploymentData alloc] init];
    }
    return g_EmploymentData;
}

- (id)init
{
    self = [super init];
    if (self) {
        employmentDictionary_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSDictionary* )getDataForType:(NSString* )sender
{
    if ([[employmentDictionary_ allKeys] containsObject:sender]) {
        NSDictionary* notifications = [employmentDictionary_ objectForKey:sender];
        return notifications;
    }
    else
    {
        return nil;
    }
}

- (void)addEmploymentDatas:(NSArray* )employments ForType:(NSString* )typeSender
{
    for (JobObject* object in employments) {
        object.type = typeSender;
        if (![[employmentDictionary_ allKeys] containsObject:typeSender]) {
            NSMutableDictionary* employments = [NSMutableDictionary dictionary];
            [employmentDictionary_ setObject:employments forKey:typeSender];
        }
        NSMutableDictionary* employments = [employmentDictionary_ objectForKey:typeSender];
        if ([[employments allKeys] containsObject:object.date]) {
            NSMutableArray* jobsInDate = [employments objectForKey:object.date];
            BOOL add = YES;
            for (JobObject* oldJob in jobsInDate) {
                if ([oldJob.ID isEqualToString:object.ID]) {
                    add = NO;
                }
            }
            if (add) {
                [jobsInDate addObject:object];
            }
        }
        else
        {
            NSMutableArray* jobInDate = [NSMutableArray array];
            [jobInDate addObject:object];
            [employments setObject:jobInDate forKey:object.date];
        }
    }
}

@end
