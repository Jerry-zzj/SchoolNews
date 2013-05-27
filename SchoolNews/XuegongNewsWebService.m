//
//  XuegongNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 12月29星期六.
//
//

#import "XuegongNewsWebService.h"

@implementation XuegongNewsWebService
XuegongNewsWebService* g_XuegongNewsWebService;
+ (id)singleton
{
    if (g_XuegongNewsWebService == nil) {
        g_XuegongNewsWebService = [[XuegongNewsWebService alloc] init];
    }
    return g_XuegongNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:XUEGONG_END_UPDATE_WITH_WEBSERVICEE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
