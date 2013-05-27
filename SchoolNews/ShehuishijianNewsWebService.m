//
//  ShehuishijianNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "ShehuishijianNewsWebService.h"

@implementation ShehuishijianNewsWebService
ShehuishijianNewsWebService* g_ShehuishijianNewsWebService;
+ (id)singleton
{
    if (g_ShehuishijianNewsWebService == nil) {
        g_ShehuishijianNewsWebService = [[ShehuishijianNewsWebService alloc] init];
    }
    return g_ShehuishijianNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:SHEHUISHIJIAN_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
