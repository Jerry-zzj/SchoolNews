
//
//  RenshiNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "RenshiNewsWebService.h"

@implementation RenshiNewsWebService
RenshiNewsWebService* g_RenshiNewsWebService;
+ (id)singleton
{
    if (g_RenshiNewsWebService == nil) {
        g_RenshiNewsWebService = [[RenshiNewsWebService alloc] init];
    }
    return g_RenshiNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:RENSHI_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
