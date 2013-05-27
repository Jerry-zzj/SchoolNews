//
//  WebContentXMLAnalyze.m
//  SchoolNews
//
//  Created by Jerry on 5月20星期一.
//
//

#import "WebContentXMLAnalyze.h"

@implementation WebContentXMLAnalyze
+ (id)analyzeXML:(NSString *)xmlSender
{
    NSString* correctXML = [super analyzeXML:xmlSender];
    NSMutableString* mutableString = [[NSMutableString alloc] initWithString:correctXML];
    [mutableString replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0 range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"<ns:getNewsContentResponse xmlns:ns=\"http://webservice.shuangchi.com\"><ns:return>" withString:@"" options:0 range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"</ns:return></ns:getNewsContentResponse>" withString:@"" options:0 range:NSMakeRange(0, [mutableString length])];
    //NSLog(@"%@",mutableString);
    //&lt; = <  和  &gt; = > 和 &quot; = " 和 &#xd; = \n 和 &amp; = & 和  &#160 = “ ” 和
    //NSArray* array = [NSArray arrayWithObjects:@"&lt;",@"&gt;",@"&quot;",@"&#xd;", nil];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"<",@"&lt;",@">",@"&gt;",@"\"",@"&quot;",@"\n",@"&#xd;",@"&",@"&amp;",@" ",@"&#160",nil];
    for (NSString* key in [dictionary allKeys]) {
        NSString* withString = [dictionary objectForKey:key];
        [mutableString replaceOccurrencesOfString:key
                                       withString:withString
                                          options:0
                                            range:NSMakeRange(0, [mutableString length])];
    }
    return mutableString;
}
@end
