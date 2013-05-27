//
//  ClearAllUnhandlePushNotification.h
//  SchoolNews
//
//  Created by Jerry on 3月8星期五.
//
//

#import "WebService.h"
@protocol ClearPushNotificationWebserviceDelegate<NSObject>

- (void)clearPushNotification:(BOOL )sender;

@end
@interface ClearPushNotificationWebservice : WebService
@property (nonatomic,assign)id<ClearPushNotificationWebserviceDelegate> delegate;
@end
