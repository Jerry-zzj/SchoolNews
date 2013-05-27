//
//  RemotePushNotification.m
//  SchoolNews
//
//  Created by Jerry on 3月5星期二.
//
//

#import "RemotePushNotificationObject.h"
#define ID_KEY                          @"ID"
#define TITLE_KEY                       @"Title"
#define TYPE_KEY                        @"Type"
#define CONTENT_ID_KEY                  @"ConyentID"
@implementation RemotePushNotificationObject
@synthesize ID;
@synthesize title;
@synthesize type;
@synthesize contentID;
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:ID forKey:ID_KEY];
    [aCoder encodeObject:title forKey:TITLE_KEY];
    [aCoder encodeObject:type forKey:TYPE_KEY];
    [aCoder encodeObject:contentID forKey:CONTENT_ID_KEY];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.ID = [aDecoder decodeObjectForKey:ID_KEY];
        self.title = [aDecoder decodeObjectForKey:TITLE_KEY];
        self.type = [aDecoder decodeObjectForKey:TYPE_KEY];
        self.contentID = [aDecoder decodeObjectForKey:CONTENT_ID_KEY];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    RemotePushNotificationObject* notification = [[RemotePushNotificationObject alloc] init];
    notification.ID = [self.ID copyWithZone:zone];
    notification.title = [self.title copyWithZone:zone];
    notification.type = [self.type copyWithZone:zone];
    notification.contentID = [self.contentID copyWithZone:zone];
    return notification;
}

- (NSDictionary* )changeToDictiontion
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    NSString* notificationType = self.type;
    [dictionary setObject:notificationType forKey:@"Type"];
    NSString* notificationID = self.ID;
    [dictionary setObject:notificationID forKey:@"ID"];
    [dictionary setObject:self.contentID forKey:@"ContentID"];
    return dictionary;
}

- (RemotePushNotificationObject* )initWithDictionary:(NSDictionary* )sender
{
    NSString* notificationType = [sender objectForKey:@"ContentType"];
    NSString* contentIDString = [sender objectForKey:@"ContentID"];
    NSDictionary* aps = [sender objectForKey:@"aps"];
    NSString* alert = [aps objectForKey:@"alert"];
    RemotePushNotificationObject* remoteNotification = [[RemotePushNotificationObject alloc] init];
    remoteNotification.ID = [sender objectForKey:@"ID"];
    remoteNotification.contentID = contentIDString;
    remoteNotification.type = notificationType;
    remoteNotification.title = alert;
    return remoteNotification;
}
@end
