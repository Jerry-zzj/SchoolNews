//
//  ZixunNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "ZixunNewsWebService.h"

@implementation ZixunNewsWebService
ZixunNewsWebService* g_ZixunNewsWebService;
+ (id)singleton
{
    if (g_ZixunNewsWebService == nil) {
        g_ZixunNewsWebService = [[ZixunNewsWebService alloc] init];
    }
    return g_ZixunNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:ZIXUN_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
