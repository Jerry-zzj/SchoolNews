//
//  NewsShowWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "NewsShowWebService.h"
#import "GDataXMLNode.h"
@interface NewsShowWebService(private)

- (NSString* )handleTheNewsFromOtherWebsite:(NSString* )sender;

@end


@implementation NewsShowWebService
NewsShowWebService* g_NewsShowWebService;
@synthesize delegate;
+ (id)singleton
{
    if (g_NewsShowWebService == nil) {
        g_NewsShowWebService = [[NewsShowWebService alloc] init];
    }
    return g_NewsShowWebService;
}

//模版方法
- (id)doHandleTheData:(NSString* )data
{
    NSMutableString* mutableString = [[NSMutableString alloc] initWithString:data];
    [mutableString replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0 range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"<ns:getNewsContentResponse xmlns:ns=\"http://webservice.shuangchi.com\"><ns:return>" withString:@"" options:0 range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"</ns:return></ns:getNewsContentResponse>" withString:@"" options:0 range:NSMakeRange(0, [mutableString length])];
    //NSLog(@"%@",mutableString);
    NSString* contentText = [self handleTheNewsFromOtherWebsite:mutableString];
    return contentText;
}


//模板方法
//当接受完数据以后
- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    [self.delegate loadTheNews:object];
}

#pragma mark private
//对于文本中出现的一些类似与&lt;的字符进行替换
- (NSString* )handleTheNewsFromOtherWebsite:(NSString* )sender
{
    //&lt; = <  和  &gt; = > 和 &quot; = " 和 &#xd; = \n 和 &amp; = & 和  &#160 = “ ” 和 
    //NSArray* array = [NSArray arrayWithObjects:@"&lt;",@"&gt;",@"&quot;",@"&#xd;", nil];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"<",@"&lt;",@">",@"&gt;",@"\"",@"&quot;",@"\n",@"&#xd;",@"&",@"&amp;",@" ",@"&#160",nil];
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
