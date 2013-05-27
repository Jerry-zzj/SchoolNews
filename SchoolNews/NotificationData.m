//
//  NotificationData.m
//  SchoolNews
//
//  Created by Jerry on 3月28星期四.
//
//

#import "NotificationData.h"
#import "NotificationObject.h"
@implementation NotificationData
{
    NSMutableDictionary* notificationDictionary;
    NSMutableArray* notificationTypes;
}
NotificationData* g_NotificationData;
+ (NotificationData* )singleton
{
    if (g_NotificationData == nil) {
        g_NotificationData = [[NotificationData alloc] init];
    }
    return g_NotificationData;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        notificationDictionary = [[NSMutableDictionary alloc] init];
        NSString* notificationTypesFilePath = [[NSBundle mainBundle] pathForResource:@"NotificationSubtitle" ofType:@"plist"];
        notificationTypes = [NSMutableArray arrayWithContentsOfFile:notificationTypesFilePath];
    }
    return self;
}

- (NSDictionary* )getNotificationForTitle:(NSString* )sender
{
    if ([[notificationDictionary allKeys] containsObject:sender]) {
        NSDictionary* notifications = [notificationDictionary objectForKey:sender];
        return notifications;
    }
    else
    {
        return nil;
    }
}

- (void)addNotifications:(NSArray* )notificationsSender ForTitle:(NSString* )titleSender
{
    for (NotificationObject* object in notificationsSender) {
        int type = [object.type intValue];
        NSString* typeString = [notificationTypes objectAtIndex:type - 1];
        if (![[notificationDictionary allKeys] containsObject:typeString]) {
            NSMutableDictionary* notifications = [NSMutableDictionary dictionary];
            [notificationDictionary setObject:notifications forKey:typeString];
        }
        NSMutableDictionary* notifications = [notificationDictionary objectForKey:typeString];
        if ([[notifications allKeys] containsObject:object.date]) {
            NSMutableArray* notificationInDate = [notifications objectForKey:object.date];
            BOOL add = YES;
            for (NotificationObject* oldNotification in notificationInDate) {
                if ([oldNotification.ID isEqualToString:object.ID]) {
                    add = NO;
                }
            }
            if (add) {
                [notificationInDate addObject:object];
                object.type = typeString;
            }
        }
        else
        {
            NSMutableArray* notificationInDate = [NSMutableArray array];
            [notificationInDate addObject:object];
            object.type = typeString;
            [notifications setObject:notificationInDate forKey:object.date];
        }
        
    }
}
@end
