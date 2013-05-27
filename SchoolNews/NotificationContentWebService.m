//
//  NotificationContentWebService.m
//  SchoolNews
//
//  Created by Jerry on 3月28星期四.
//
//

#import "NotificationContentWebService.h"
@interface NotificationContentWebService(privateAPI)

- (NSString* )handleTheNewsFromOtherWebsite:(NSString* )sender;

@end
@implementation NotificationContentWebService
@synthesize delegate;
NotificationContentWebService* g_NotificationContentWebService;
+ (id)singleton
{
    if (g_NotificationContentWebService == nil) {
        g_NotificationContentWebService = [[NotificationContentWebService alloc] init];
    }
    return g_NotificationContentWebService;
}

//模版方法
- (id)doHandleTheData:(NSString* )data
{
    NSMutableString* mutableString = [[NSMutableString alloc] initWithString:data];
    [mutableString replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0 range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"<ns:getNotificationContentWithIDResponse xmlns:ns=\"http://webservice.shuangchi.com\"><ns:return>" withString:@"" options:0 range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"</ns:return></ns:getNotificationContentWithIDResponse>" withString:@"" options:0 range:NSMakeRange(0, [mutableString length])];
    //NSLog(@"%@",mutableString);
    NSString* contentText = [self handleTheNewsFromOtherWebsite:mutableString];
    return contentText;
}

//模板方法
//当接受完数据以后
- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    [self.delegate getNotificationContent:object];
}

#pragma mark private
//对于文本中出现的一些类似与&lt;的字符进行替换
- (NSString* )handleTheNewsFromOtherWebsite:(NSString* )sender
{
    //&lt; = <  和  &gt; = > 和 &quot; = " 和 &#xd; = \n 和 &amp; = & 和  &#160 = “ ” 和
    //NSArray* array = [NSArray arrayWithObjects:@"&lt;",@"&gt;",@"&quot;",@"&#xd;", nil];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"<",@"&lt;",@">",@"&gt;",@"\"",@"&quot;",@"<br>",@"&#xd;",@"&",@"&amp;",@" ",@"&#160",nil];
    NSMutableString* result = [NSMutableString stringWithString:sender];
    for (NSString* key in [dictionary allKeys]) {
        NSString* withString = [dictionary objectForKey:key];
        [result replaceOccurrencesOfString:key
                                withString:withString
                                   options:0
                                     range:NSMakeRange(0, [result length])];
    }
    return result;
}

@end
