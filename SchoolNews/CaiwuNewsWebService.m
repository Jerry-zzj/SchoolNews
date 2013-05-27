//
//  CaiwuNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 12月29星期六.
//
//

#import "CaiwuNewsWebService.h"

@implementation CaiwuNewsWebService
CaiwuNewsWebService* g_CaiwuNewsWebService;
+ (id)singleton
{
    if (g_CaiwuNewsWebService == nil) {
        g_CaiwuNewsWebService = [[CaiwuNewsWebService alloc] init];
    }
    return g_CaiwuNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:CAIWU_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
