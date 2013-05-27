//
//  BenkeshengNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "BenkeshengNewsWebService.h"

@implementation BenkeshengNewsWebService
BenkeshengNewsWebService* g_BenkeshengNewsWebService;
+ (id)singleton
{
    if (g_BenkeshengNewsWebService == nil) {
        g_BenkeshengNewsWebService = [[BenkeshengNewsWebService alloc] init];
    }
    return g_BenkeshengNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:BENKESHENG_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
