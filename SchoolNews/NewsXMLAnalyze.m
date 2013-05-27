//
//  NewsXMLAnalyze.m
//  SchoolNews
//
//  Created by Jerry on 5月20星期一.
//
//

#import "NewsXMLAnalyze.h"
#import "NewsObject.h"
#import "AboutTime.h"

@implementation NewsXMLAnalyze
+ (id )analyzeXML:(NSString* )xmlSender
{
    NSString* correctXML = [super analyzeXML:xmlSender];
    
    GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:correctXML
                                                                     options:0
                                                                       error:nil];
    GDataXMLElement* rootElement = [document rootElement];
    GDataXMLElement* temp = [[rootElement elementsForName:@"ns:return"]
                             objectAtIndex:0];
    NSArray* elementNewses = [temp elementsForName:@"News"];
    NSMutableArray* newses = [NSMutableArray array];
    for (GDataXMLElement* news in elementNewses) {
        NewsObject* newsInformation = [[NewsObject alloc] init];
        
        //ID
        GDataXMLElement* idElement = [[news elementsForName:@"ID"] objectAtIndex:0];
        NSString* newsID = [idElement stringValue];
        newsInformation.ID = newsID;
        
        //标题
        GDataXMLElement* titleelement = [[news elementsForName:@"Title"]
                                         objectAtIndex:0];
        NSString* title = [titleelement stringValue];
        newsInformation.title = title;
        
        //简介
        GDataXMLElement* synopsisElement = [[news elementsForName:@"Synopsis"]
                                            objectAtIndex:0];
        NSString* synopsis = [synopsisElement stringValue];
        newsInformation.synopsis = synopsis;
        
        //简介图片
        GDataXMLElement* synopsisImageElement = [[news elementsForName:@"SynopsisImagePath"]
                                                 objectAtIndex:0];
        NSString* synopsisImage = [synopsisImageElement stringValue];
        newsInformation.synopsisImagePath = synopsisImage;
        //内容
        //[self dohandleContent:news ToNews:newsInformation];
        
        //发布部门
        GDataXMLElement* departmentElement = [[news elementsForName:@"Department"] objectAtIndex:0];
        NSString* department = [departmentElement stringValue];
        newsInformation.department = department;
        
        //新闻来源
        GDataXMLElement* newsFromElement = [[news elementsForName:@"NewsFrom"] objectAtIndex:0];
        NSString* newsfrom = [newsFromElement stringValue];
        newsInformation.newsFrom = newsfrom;
        
        //SubtitleID
        GDataXMLElement* subtitleElement = [[news elementsForName:@"SubtitleID"] objectAtIndex:0];
        NSString* subtitleIDString = [subtitleElement stringValue];
        newsInformation.subtitle = subtitleIDString;
        
        //是否置顶
        GDataXMLElement* topElement = [[news elementsForName:@"Top"] objectAtIndex:0];
        NSString* topString = [topElement stringValue];
        int top;
        if ([topString isEqualToString:@"false"]) {
            top = 0;
        }
        else
        {
            top = 1;
        }
        newsInformation.top = top;
        
        //发布日期
        GDataXMLElement* dateElement = [[news elementsForName:@"DateTime"] objectAtIndex:0];
        NSString* dateString = [dateElement stringValue];
        NSDate* date = [[AboutTime singleton] getDateFromString:dateString];
        newsInformation.date = date;
        
        [newses addObject:newsInformation];
    }
    return newses;
}

@end
