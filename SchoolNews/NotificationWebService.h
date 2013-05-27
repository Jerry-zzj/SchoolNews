//
//  NotificationWebService.h
//  SchoolNews
//
//  Created by Jerry on 12月29星期六.
//
//

#import "WebService.h"
#define NOTIFICATION_END_UPDATE_WITH_WEBSERVICE              @"NotificationEndUpdate"

@protocol NotificationWebServiceDelegate <NSObject>

- (void)getNotifications:(id)sender;

@end

@interface NotificationWebService : WebService
@property(nonatomic,assign)id<NotificationWebServiceDelegate> delegate;
@end
