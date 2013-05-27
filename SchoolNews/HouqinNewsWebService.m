//
//  HouqinNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 12月29星期六.
//
//

#import "HouqinNewsWebService.h"

@implementation HouqinNewsWebService
HouqinNewsWebService* g_HouqinNewsWebService;
+ (id)singleton
{
    if (g_HouqinNewsWebService == nil) {
        g_HouqinNewsWebService = [[HouqinNewsWebService alloc] init];
    }
    return g_HouqinNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:HOUQIN_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
