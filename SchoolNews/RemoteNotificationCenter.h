//
//  RemoteNotificationCenter.h
//  SchoolNews
//
//  Created by Jerry on 5月14星期二.
//
//

#import <Foundation/Foundation.h>
#import "RemotePushNotificationWebService.h"
#import "RegisterWebService.h"
#import "ClearPushNotificationWebservice.h"
@class RemotePushNotificationObject;
@interface RemoteNotificationCenter : NSObject<RemotePushNotificationWebService,RegisterWebServiceDelegate,ClearPushNotificationWebserviceDelegate>
{
    NSMutableDictionary* unhandleRemoteNotificationDictionary_;
}
+ (RemoteNotificationCenter* )singleton;
- (void)loadAllUnHandleRemoteNotifcation;
- (int )getAllUnHandleRemoteNotifcationCount;
- (void)receiveNewRemotePushNotification:(RemotePushNotificationObject* )sender;
- (void)handInTheDeviceTokenToTheServerWithAccount:(NSString* )deviceToken;
- (NSDictionary* )getAllUnHandleRemoteNotifcation;
- (void)clearTheRemotePushNotificationsForFunctionCode:(NSString* )functionCode;
- (NSArray* )getRemoteNotificationForFunctionCode:(NSString* )functionCode;
@end
