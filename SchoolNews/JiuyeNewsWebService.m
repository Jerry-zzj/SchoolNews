//
//  JiuyeNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "JiuyeNewsWebService.h"

@implementation JiuyeNewsWebService
JiuyeNewsWebService* g_JiuyeNewsWebService;
+ (id)singleton
{
    if (g_JiuyeNewsWebService == nil) {
        g_JiuyeNewsWebService = [[JiuyeNewsWebService alloc] init];
    }
    return g_JiuyeNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:JIUYE_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
