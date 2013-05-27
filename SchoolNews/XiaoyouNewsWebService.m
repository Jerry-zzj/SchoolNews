//
//  XiaoyouNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "XiaoyouNewsWebService.h"

@implementation XiaoyouNewsWebService
XiaoyouNewsWebService* g_XiaoyouNewsWebService;
+ (id)singleton
{
    if (g_XiaoyouNewsWebService == nil) {
        g_XiaoyouNewsWebService = [[XiaoyouNewsWebService alloc] init];
    }
    return g_XiaoyouNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:XIAOYOU_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
