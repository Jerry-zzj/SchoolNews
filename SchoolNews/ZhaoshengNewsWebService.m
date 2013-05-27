//
//  ZhaoshengNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "ZhaoshengNewsWebService.h"

@implementation ZhaoshengNewsWebService
ZhaoshengNewsWebService* g_ZhaoshengNewsWebService;
+ (id)singleton
{
    if (g_ZhaoshengNewsWebService == nil) {
        g_ZhaoshengNewsWebService = [[ZhaoshengNewsWebService alloc] init];
    }
    return g_ZhaoshengNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:ZHAOSHENG_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
