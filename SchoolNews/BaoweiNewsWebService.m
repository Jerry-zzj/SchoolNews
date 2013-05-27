//
//  BaoweiNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "BaoweiNewsWebService.h"

@implementation BaoweiNewsWebService
BaoweiNewsWebService* g_BaoweiNewsWebService;
+ (id)singleton
{
    if (g_BaoweiNewsWebService == nil) {
        g_BaoweiNewsWebService = [[BaoweiNewsWebService alloc] init];
    }
    return g_BaoweiNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:BAOWEI_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
