//
//  MeetObject.m
//  SchoolNews
//
//  Created by Jerry on 12月26星期三.
//
//

#import "MeetObject.h"
#define ID_KEY                                          @"ID"
#define WEEK_KEY                                        @"week"
#define DATE_kEY                                        @"date"
#define WEEKDAY_KEY                                     @"weekDay"
#define PLACE_KEY                                       @"place"
#define CONTENT_KEY                                     @"content"
#define HOST_KEY                                        @"host"
#define EXECUTIVE_DEPARTMENTS_KEY                       @"executiveDepartments"
#define PARTICIPANTS_KEY                                @"participants"


@implementation MeetObject
@synthesize ID;
@synthesize week;
@synthesize date;
@synthesize weekDay;
@synthesize place;
@synthesize content;
@synthesize host;
@synthesize executiveDepartments;
@synthesize participants;
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:ID forKey:ID_KEY];
    [aCoder encodeInt32:week forKey:WEEK_KEY];
    [aCoder encodeObject:date forKey:DATE_kEY];
    [aCoder encodeObject:weekDay forKey:WEEKDAY_KEY];
    [aCoder encodeObject:place forKey:PLACE_KEY];
    [aCoder encodeObject:content forKey:CONTENT_KEY];
    [aCoder encodeObject:host forKey:HOST_KEY];
    [aCoder encodeObject:executiveDepartments forKey:EXECUTIVE_DEPARTMENTS_KEY];
    [aCoder encodeObject:participants forKey:PARTICIPANTS_KEY];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.ID = [aDecoder decodeObjectForKey:ID_KEY];
        self.week = [aDecoder decodeInt32ForKey:WEEK_KEY];
        self.date = [aDecoder decodeObjectForKey:DATE_kEY];
        self.weekDay = [aDecoder decodeObjectForKey:WEEKDAY_KEY];
        self.place = [aDecoder decodeObjectForKey:PLACE_KEY];
        self.content = [aDecoder decodeObjectForKey:CONTENT_KEY];
        self.host = [aDecoder decodeObjectForKey:HOST_KEY];
        self.executiveDepartments = [aDecoder decodeObjectForKey:EXECUTIVE_DEPARTMENTS_KEY];
        self.participants = [aDecoder decodeObjectForKey:PARTICIPANTS_KEY];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    MeetObject* meet = [[MeetObject allocWithZone:zone] init];
    meet.ID = [self.ID copyWithZone:zone];
    meet.week = self.week;
    meet.date = [self.date copyWithZone:zone];
    meet.weekDay = [self.weekDay copyWithZone:zone];
    meet.place = [self.place copyWithZone:zone];
    meet.content = [self.content copyWithZone:zone];
    meet.host = [self.host copyWithZone:zone];
    meet.executiveDepartments = [self.executiveDepartments copyWithZone:zone];
    meet.participants = [self.participants copyWithZone:zone];
    return meet;
}

@end
