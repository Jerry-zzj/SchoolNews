//
//  LiuxueshengNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "LiuxueshengNewsWebService.h"

@implementation LiuxueshengNewsWebService
LiuxueshengNewsWebService* g_LiuxueshengNewsWebService;
+ (id)singleton
{
    if (g_LiuxueshengNewsWebService == nil) {
        g_LiuxueshengNewsWebService = [[LiuxueshengNewsWebService alloc] init];
    }
    return g_LiuxueshengNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:LIUXUESHENG_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
