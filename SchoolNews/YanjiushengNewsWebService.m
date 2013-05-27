//
//  YanjiushengNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "YanjiushengNewsWebService.h"

@implementation YanjiushengNewsWebService
YanjiushengNewsWebService* g_YanjiushengNewsWebService;
+ (id)singleton
{
    if (g_YanjiushengNewsWebService == nil) {
        g_YanjiushengNewsWebService = [[YanjiushengNewsWebService alloc] init];
    }
    return g_YanjiushengNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:YANJIUSHENG_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
