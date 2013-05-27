//
//  NotificationObject.m
//  SchoolNews
//
//  Created by Jerry on 12月26星期三.
//
//

#import "NotificationObject.h"

#define ID_KEY                                  @"ID"
#define TITLE_KEY                               @"Title"
#define CONTENT_KEY                             @"Content"
#define DATE_KEY                                @"Date"
#define DEPARTMENT_KEY                          @"Department"
#define TYPE_KEY                                @"Type"

@implementation NotificationObject
@synthesize ID;
@synthesize title;
@synthesize content;
@synthesize date;
@synthesize department;
@synthesize type;
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:ID forKey:ID_KEY];
    [aCoder encodeObject:title forKey:TITLE_KEY];
    [aCoder encodeObject:content forKey:CONTENT_KEY];
    [aCoder encodeObject:date forKey:DATE_KEY];
    [aCoder encodeObject:department forKey:DEPARTMENT_KEY];
    [aCoder encodeObject:type forKey:TYPE_KEY];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.ID = [aDecoder decodeObjectForKey:ID_KEY];
        self.title = [aDecoder decodeObjectForKey:TITLE_KEY];
        self.content = [aDecoder decodeObjectForKey:CONTENT_KEY];
        self.date = [aDecoder decodeObjectForKey:DATE_KEY];
        self.department = [aDecoder decodeObjectForKey:DEPARTMENT_KEY];
        self.type = [aDecoder decodeObjectForKey:TYPE_KEY];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    NotificationObject* notification = [[NotificationObject allocWithZone:zone] init];
    notification.ID = [self.ID copyWithZone:zone];
    notification.title = [self.title copyWithZone:zone];
    notification.content = [self.content copyWithZone:zone];
    notification.date = [self.date copyWithZone:zone];
    notification.department = [self.department copyWithZone:zone];
    notification.type = [self.type copyWithZone:zone];
    return notification;
}


@end
