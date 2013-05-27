//
//  WebServiceFactory.m
//  SchoolNews
//
//  Created by Jerry on 12月26星期三.
//
//

#import "WebServiceFactory.h"
#import "YaowenNewsWebService.h"
#import "ZongheNewsWebService.h"
#import "JiaoxueNewsWebService.h"
#import "XuegongNewsWebService.h"
#import "CaiwuNewsWebService.h"
#import "TushuguanNewsWebService.h"
#import "HouqinNewsWebService.h"
#import "ZixunNewsWebService.h"
#import "ZhaoshengNewsWebService.h"
#import "JiuyeNewsWebService.h"
#import "BenkeshengNewsWebService.h"
#import "YanjiushengNewsWebService.h"
#import "LiuxueshengNewsWebService.h"
#import "ShehuishijianNewsWebService.h"
#import "XiaoyouNewsWebService.h"
#import "RenshiNewsWebService.h"
#import "ZichanNewsWebService.h"
#import "XinxiNewsWebService.h"
#import "BaoweiNewsWebService.h"

#import "NewsShowWebService.h"

#import "MeetWebService.h"
#import "MeetShowWebService.h"
#import "LectureWebService.h"
#import "NotificationWebService.h"
#import "EmploymentWebservice.h"
#import "VerificationWebService.h"
#import "ModifyPasswordWebService.h"
#import "ContactsWebService.h"
@implementation WebServiceFactory
WebServiceFactory* g_WebServiceFactory;
+ (WebServiceFactory* )singleton
{
    if (g_WebServiceFactory == nil) {
        g_WebServiceFactory = [[WebServiceFactory alloc] init];
    }
    return g_WebServiceFactory;
}

- (WebService* )produceTheWebService:(NSString* )sender
{
    if ([sender isEqualToString:YAOWEN_NEWS_WEBSERVICE]) {
        return [YaowenNewsWebService singleton];
    }
    else if ([sender isEqualToString:ZONGHE_NEWS_WEBSERVICE])
    {
        return [ZongheNewsWebService singleton];
    }
    else if ([sender isEqualToString:JIAOXUE_NEWS_WEBSERVICE])
    {
        return [JiaoxueNewsWebService singleton];
    }
    else if ([sender isEqualToString:XUEGONG_NEWS_WEBSERVICE])
    {
        return [XuegongNewsWebService singleton];
    }
    else if ([sender isEqualToString:CAIWU_NEWS_WEBSERVICE])
    {
        return [CaiwuNewsWebService singleton];
    }
    else if ([sender isEqualToString:TUSHUGuAN_NEWS_WEBSERVICE])
    {
        return [TushuguanNewsWebService singleton];
    }
    else if ([sender isEqualToString:HOUQIN_NEWS_WEBSERVICE])
    {
        return [HouqinNewsWebService singleton];
    }
    else if ([sender isEqualToString:ZIXUN_WEBSERVICE])
    {
        return [ZixunNewsWebService singleton];
    }
    else if ([sender isEqualToString:ZHAOSHENG_NEWS_WEBSERVICE])
    {
        return [ZhaoshengNewsWebService singleton];
    }
    else if ([sender isEqualToString:JIUYE_NEWS_WEBSERVICE])
    {
        return [JiuyeNewsWebService singleton];
    }
    else if ([sender isEqualToString:BENKESHENG_NEWS_WEBSERVICE])
    {
        return [BenkeshengNewsWebService singleton];
    }
    else if ([sender isEqualToString:YANJIUSHENG_NEWS_WEBSERVICE])
    {
        return [YanjiushengNewsWebService singleton];
    }
    else if ([sender isEqualToString:LIUXUESHENG_NEWS_WEBSERVICE])
    {
        return [LiuxueshengNewsWebService singleton];
    }
    else if ([sender isEqualToString:SHEHUISHIJIAN_NEWS_WEBSERVICE])
    {
        return [ShehuishijianNewsWebService singleton];
    }
    else if ([sender isEqualToString:XIAOYOU_NEWS_WEBSERVICE])
    {
        return [XiaoyouNewsWebService singleton];
    }
    else if ([sender isEqualToString:RENSHI_NEWS_WEBSERVICE])
    {
        return [RenshiNewsWebService singleton];
    }
    else if ([sender isEqualToString:ZICHAN_NEWS_WEBSERVICE])
    {
        return [ZichanNewsWebService singleton];
    }
    else if ([sender isEqualToString:XINXI_NEWS_WEBSERVICE])
    {
        return [XinxiNewsWebService singleton];
    }
    else if ([sender isEqualToString:BAOWEI_NEWS_WEBSERVICE])
    {
        return [BaoweiNewsWebService singleton];
    }
    else if ([sender isEqualToString:NEWS_SHOW_NEWS_WEBSERVICE])
    {
        return [NewsShowWebService singleton];
    }
    else if ([sender isEqualToString:LECTURE_WEBSERVICE])
    {
        return [LectureWebService singleton];
    }
    else if ([sender isEqualToString:MEET_WEBSERVICE]) {
        return [MeetWebService singleton];
    }
    else if ([sender isEqualToString:MEET_SHOW_WEBSERVICE])
    {
        return [MeetShowWebService singleton];
    }
    
    else if([sender isEqualToString:NOTIFICATION_WEBSERVICE])
    {
        return [[NotificationWebService alloc] init];
    }
    else if ([sender isEqualToString:EMPLOYMENT_WEBSERVICE])
    {
        return [[EmploymentWebservice alloc] init];
    }
    else if ([sender isEqualToString:VERFICATION_WEBSERVICE])
    {
        return [VerificationWebService singleton];
    }
    else if ([sender isEqualToString:MODIFY_PASSWORD_WEBSERVICE])
    {
        return [ModifyPasswordWebService singleton];
    }
    else if ([sender isEqualToString:CONTACTS_WEBSERVICE])
    {
        return [ContactsWebService singleton];
    }
    return nil;
}
@end
