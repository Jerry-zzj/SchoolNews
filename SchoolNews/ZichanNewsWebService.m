//
//  ZichanNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "ZichanNewsWebService.h"

@implementation ZichanNewsWebService
ZichanNewsWebService* g_ZichanNewsWebService;
+ (id)singleton
{
    if (g_ZichanNewsWebService == nil) {
        g_ZichanNewsWebService = [[ZichanNewsWebService alloc] init];
    }
    return g_ZichanNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:ZICHAN_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
