//
//  WebServiceFactory.h
//  SchoolNews
//
//  Created by Jerry on 12月26星期三.
//
//

#import <Foundation/Foundation.h>
#import "WebService.h"
//News
#define YAOWEN_NEWS_WEBSERVICE                      @"YaoWenNewsWebservice"
#define ZONGHE_NEWS_WEBSERVICE                      @"ZongHeNewsWebservice"
#define JIAOXUE_NEWS_WEBSERVICE                     @"JiaoxueWebService"
#define XUEGONG_NEWS_WEBSERVICE                     @"XueGongWebService"
#define CAIWU_NEWS_WEBSERVICE                       @"CaiwuWebService"
#define TUSHUGuAN_NEWS_WEBSERVICE                   @"TushuguanWebService"
#define HOUQIN_NEWS_WEBSERVICE                      @"HouqinWebService"
#define ZHAOSHENG_NEWS_WEBSERVICE                   @"ZhaoshengWebService"
#define JIUYE_NEWS_WEBSERVICE                       @"JiuyeWebService"
#define BENKESHENG_NEWS_WEBSERVICE                  @"BenkeshengWebService"
#define YANJIUSHENG_NEWS_WEBSERVICE                 @"YanjiushengWebService"
#define LIUXUESHENG_NEWS_WEBSERVICE                 @"LiuxueshengWebService"
#define SHEHUISHIJIAN_NEWS_WEBSERVICE               @"ShehuishijianWebService"
#define XIAOYOU_NEWS_WEBSERVICE                     @"XiaoyouWebService"
#define RENSHI_NEWS_WEBSERVICE                      @"RenshiWebService"
#define ZICHAN_NEWS_WEBSERVICE                      @"ZichanWebService"
#define XINXI_NEWS_WEBSERVICE                       @"XinxiWebService"
#define BAOWEI_NEWS_WEBSERVICE                      @"BaoweiWebService"
#define NEWS_SHOW_NEWS_WEBSERVICE                   @"NewsShowWebService"

#define MEET_WEBSERVICE                             @"MeetWebService"
#define MEET_SHOW_WEBSERVICE                        @"MeetShowWebService"
#define LECTURE_WEBSERVICE                          @"LectureWebService"
#define NOTIFICATION_WEBSERVICE                     @"NotificationWebService"
#define EMPLOYMENT_WEBSERVICE                       @"EmploymentWebservice"
#define VERFICATION_WEBSERVICE                      @"VerficationWebService"
#define MODIFY_PASSWORD_WEBSERVICE                  @"ModifyPasswordWebService"
#define CONTACTS_WEBSERVICE                         @"ContactWebService"
#define ZIXUN_WEBSERVICE                            @"ZixunWebService"

@class WebService;
@interface WebServiceFactory : NSObject
+ (WebServiceFactory* )singleton;

- (WebService* )produceTheWebService:(NSString* )sender;
@end
