//
//  PublicDefines.h
//  SchoolNews
//
//  Created by Jerry on 1月29星期二.
//
//

#define WEBSERVICE_DOMAIN                               @"http://cmccapp.zjicm.edu.cn"
#define SCREEN_HEIGHT                                   [[UIScreen mainScreen] bounds].size.height - 20
#define TABBAR_HEIGHT                                   49
#define NAVIGATIONBAR_HEIGHT                            44

//URL
//******************************************************************************
//获取置顶新闻
#define TOP_NEWS_WEBSERVICE_URL(title)                  [NSString stringWithFormat:@"%@/axis2/services/NewsService/getTopNewsForSubtitle?subtitle=%@",WEBSERVICE_DOMAIN,title]
#define NEWS_TOTAL_INFORMATION_WITHOUT_CONTENT(id)      [NSString stringWithFormat:@"%@/axis2/services/NewsService/getNewsTotalInformationWithoutContent?ID=%@",WEBSERVICE_DOMAIN,id]
//获取所有未处理远程消息
#define GET_ALL_UNHANDLE_REMOTE_NOTIFICATION_URL(account) [NSString stringWithFormat:@"%@/axis2/services/PushNotificationService/getAllUnhandlePushNotificationWithAccount?accountNumber=%@",WEBSERVICE_DOMAIN,account]
//清空已处理远程消息
#define CLEAR_UNHANDLE_REMOTE_NOTIFICATION_URL(ids,accountNumber) [NSString stringWithFormat:@"%@/axis2/services/PushNotificationService/handleNotifications?ids=%@&accountNumber=%@",WEBSERVICE_DOMAIN,ids,accountNumber]
//注册DEVICETOKEN，与账号绑定
#define REGISTER_DEVICETOKEN_WITH_ACCOUNT_URL(accountNumber,userType,deviceToken) [NSString stringWithFormat:@"%@/axis2/services/VerificationService/registerAccountToken12?accountNumber=%@&&userType=%i&&deviceToken=%@&&deviceType=IOS",WEBSERVICE_DOMAIN,accountNumber,userType,deviceToken]
//获得周次的URL
#define GET_WEEK_INDEX_URL(date)  [NSString stringWithFormat:@"%@/axis2/services/MeetService/getWeekIndex?date=%@",WEBSERVICE_DOMAIN,date];
//获得学生某日课表的URL
#define GET_STUDENT_CLASSES(studentNumber,week,weekday,schoolYear,semester)             [NSString stringWithFormat:@"%@/axis2/services/EducationalAdministrationService/getClasses?studentNumber=%@&week=%i&weekday=%i&schoolYear=%@&semester=%@",WEBSERVICE_DOMAIN,studentNumber,week,weekday,schoolYear,semester]
//获得学生学期课表的URL
#define GET_STUDENT_SEMESTER_CLASSES(studentNumber,schoolYear,semester)                  [NSString stringWithFormat:@"http://cmccapp.zjicm.edu.cn/axis2/services/EducationalAdministrationService/getSchoolYearClasses?studentNumber=%@&schoolYear=%@&semester=%@",studentNumber,schoolYear,semester];

//获得更新的通知的URL
#define GET_NEWER_NOTIFICATION(date,type)                                [NSString stringWithFormat:@"%@/axis2/services/NotificationService/getNewerNotificationWithoutContent?date=%@&type=%i",WEBSERVICE_DOMAIN,date,type]
//获得更早的通知的URL
#define GET_EARILER_NOTIFIcATION(date,type)                  [NSString stringWithFormat:@"%@/axis2/services/NotificationService/getEarlierNotificationWithoutContent?date=%@&type=%i",WEBSERVICE_DOMAIN,date,type]
//获得通知的信息，不包括内容
#define GET_NOTIFICATION_INFORMATION(ID)                     [NSString stringWithFormat:@"%@/axis2/services/NotificationService/getNotificationWithID?ID=%@",WEBSERVICE_DOMAIN,ID]

//获得指定日期之后的招聘信息
#define GET_JOB_NEWER_DATE(date)                     [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getJobsListNewerDate?date=",date]
//获得指定日期之前的招聘信息
#define GET_JOB_EARILER_DATE(date)                   [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getJobsListEarlierDate?date=",date]
//获得指定日期之后的实习信息
#define GET_PRACTICE_NEWER_DATE(date)               [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getPracticeListNewerDate?date=",date]
//获得指定日期之前的实习信息
#define GET_PRACTICE_EARILER_DATE(date)             [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getPracticeListEarlierDate?date=",date]
//获得指定日期之后的信息转载
#define GET_REPRODUCED_NEWER_DATE(date)             [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getReproducedListNewerDate?date=",date]
//获得置顶日期之前的信息转载
#define GET_REPRODUCED_EARILER_DATE(date)           [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getReproducedListEarlierDate?date=",date]
//获得信息转载的信息（不包括内容）
#define GET_REPRODUCED_TOTALINFORMATION_WITHOUT_CONTENT(ID) [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getReproducedTotalInformationWithoutContentForID?ID=",ID]
//获得招聘信息的具体信息
#define GET_JOB_TOTALINFORMATION(ID)                    [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getJobsTotalInformationForID?ID=",ID]
//获得实习信息的具体信息
#define GET_PRACTICE_TOTALINFORMATION(ID)               [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getPracticeTotalInformationForID?ID=",ID]

//获得会议信息
#define GET_MEET_TOTALINFORMATION(ID)                   [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/MeetService/getMeetWithID?ID=",ID]

//获得讲座信息
#define GET_LECTURE_TOTALINFORMATION(ID)                [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/LectureService/getLectureWithID?ID=",ID]
//******************************************************************************

//远程消息推送通知
//#define NEWS_REMOTE_NOTIFICATION_FINISH                 @"NewsRemoteNotificationFinish"
//#define MEET_REMOTE_NOTIFICATION_FINISH                 @"MeetRemoteNotificationFinish"
//#define NOTIFICATION_REMOTE_NOTIFICATION_FINSIH         @"NotificationRemoteNotificationFinish"
//#define LECTURE_REMOTE_NOTIFICATION_FINISH              @"LectureRemoteNotificationFinish"
#define GET_REMOTE_PUSH_NOTIFICATION                        @"getNewRemotePushNotification"

//用户登录，登出通知
#define USER_LOGIN_OUT                                      @"userLoginOut"
#define USER_LOGIN_IN                                       @"userLoginIn"
//******************************************************************************

//右划更多功能，响应的宽度
#define PULL_VIEW_RESPONSE_WIDTH                        8

//Web页面
#define WEB_TITLE_FONT_SIZE                             55
#define WEB_RELEASE_SIZE                                45
#define WEB_CONTENT_SIZE                                50
//