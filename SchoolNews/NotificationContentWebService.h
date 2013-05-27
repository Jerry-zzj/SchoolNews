//
//  NotificationContentWebService.h
//  SchoolNews
//
//  Created by Jerry on 3月28星期四.
//
//

#import "WebService.h"
@protocol NotificationContentWebServiceDelegate<NSObject>

- (void)getNotificationContent:(id)sender;

@end
@interface NotificationContentWebService : WebService
@property (nonatomic,assign)id<NotificationContentWebServiceDelegate> delegate;
@end
