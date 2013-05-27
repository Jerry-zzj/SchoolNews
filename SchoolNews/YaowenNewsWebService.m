//
//  YaowenNewsWebService.m
//  SchoolNews
//
//  Created by Jerry on 12月26星期三.
//
//

#import "YaowenNewsWebService.h"

@implementation YaowenNewsWebService
YaowenNewsWebService* g_YaowenNewsWebService;
+ (id)singleton
{
    if (g_YaowenNewsWebService == nil) {
        g_YaowenNewsWebService = [[YaowenNewsWebService alloc] init];
    }
    return g_YaowenNewsWebService;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    NSNotification* notification = [NSNotification
                                    notificationWithName:YAOWEN_END_UPDATE_WITH_WEBSERVICE
                                    object:object
                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
