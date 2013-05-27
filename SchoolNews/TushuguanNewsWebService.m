//
//  TushuguanNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 12月29星期六.
//
//

#import "TushuguanNewsWebService.h"

@implementation TushuguanNewsWebService
TushuguanNewsWebService* g_TushuguanNewsWebService;
+ (TushuguanNewsWebService* )singleton
{
    if (g_TushuguanNewsWebService == nil) {
        g_TushuguanNewsWebService = [[TushuguanNewsWebService alloc] init];
    }
    return g_TushuguanNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:TUSHUGUAN_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
