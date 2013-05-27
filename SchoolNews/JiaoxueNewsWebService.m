//
//  JiaoxueNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 12月29星期六.
//
//

#import "JiaoxueNewsWebService.h"

@implementation JiaoxueNewsWebService
JiaoxueNewsWebService* g_JiaoxueNewsWebService;
+ (id)singleton
{
    if (g_JiaoxueNewsWebService == nil) {
        g_JiaoxueNewsWebService = [[JiaoxueNewsWebService alloc] init];
    }
    return g_JiaoxueNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:JIAOXUE_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
