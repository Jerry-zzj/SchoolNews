//
//  NotificationData.h
//  SchoolNews
//
//  Created by Jerry on 3月28星期四.
//
//

#import <Foundation/Foundation.h>

@interface NotificationData : NSObject
+ (NotificationData* )singleton;
- (NSDictionary* )getNotificationForTitle:(NSString* )sender;
- (void)addNotifications:(NSArray* )notificationsSender ForTitle:(NSString* )titleSender;
@end
