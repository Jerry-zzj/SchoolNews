//
//  RemotePushNotificationWebService.h
//  SchoolNews
//
//  Created by Jerry on 3月5星期二.
//
//

#import "WebService.h"
//#define GET_REMOTE_PUSH_NOTIFICATION                @"GetRemotePushNotification"
@protocol RemotePushNotificationWebService<NSObject>

- (void)getAllRemotePushNotificationAboutDevice:(id)sender;

@end
@interface RemotePushNotificationWebService : WebService
@property (nonatomic,assign)id<RemotePushNotificationWebService> delegate;
@end
