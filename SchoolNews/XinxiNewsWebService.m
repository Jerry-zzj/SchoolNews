//
//  XinxiNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "XinxiNewsWebService.h"

@implementation XinxiNewsWebService
XinxiNewsWebService* g_XinxiNewsWebService;
+ (id)singleton
{
    if (g_XinxiNewsWebService == nil) {
        g_XinxiNewsWebService = [[XinxiNewsWebService alloc] init];
    }
    return g_XinxiNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:XINXI_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
