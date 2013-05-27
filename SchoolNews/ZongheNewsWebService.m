//
//  ZongheNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 12月26星期三.
//
//

#import "ZongheNewsWebService.h"

@implementation ZongheNewsWebService
ZongheNewsWebService* g_ZongheNewsWebService;
+ (id)singleton
{
    if (g_ZongheNewsWebService == nil) {
        g_ZongheNewsWebService = [[ZongheNewsWebService alloc] init];
    }
    return g_ZongheNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:ZONGHE_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
