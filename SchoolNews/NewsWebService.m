//
//  NewsWebService.m
//  SchoolNews
//
//  Created by shuangchi on 12月14星期五.
//
//

#import "NewsWebService.h"
#import "GDataXMLNode.h"
#import "NewsObject.h"
#import "AboutTime.h"
#import "DataBaseOperating.h"
@interface NewsWebService(private)

- (void)dohandleContent:(GDataXMLElement* )newsElement ToNews:(NewsObject* )news;

@end

@implementation NewsWebService
NewsWebService* g_NewsWebService;
+ (id)singleton
{
    if (g_NewsWebService == nil) {
        g_NewsWebService = [[NewsWebService alloc] init];
    }
    return g_NewsWebService;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"NewsSubtitle" ofType:@"plist"];
        NSArray* subtitles = [NSArray arrayWithContentsOfFile:filePath];
        subtitleArray_ = [[NSArray alloc] initWithArray:subtitles];
    }
    return self;
}

//模版方法
- (id)doHandleTheData:(NSString* )data
{
    //NSString* xml = [data stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    //NSLog(@"%@",xml);
    GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:data
                                                                     options:0
                                                                       error:nil];
    GDataXMLElement* rootElement = [document rootElement];
    GDataXMLElement* temp = [[rootElement elementsForName:@"ns:return"]
                             objectAtIndex:0];
    NSArray* newses = [temp elementsForName:@"News"];
    NSMutableArray* notTopNewses = [NSMutableArray array];//不置顶的新闻
    NSMutableArray* topNewses = [NSMutableArray array];//置顶新闻
    for (GDataXMLElement* news in newses) {
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
        [self dohandleContent:news ToNews:newsInformation];
        
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
        NSString* subtitle = [subtitleArray_ objectAtIndex:[subtitleIDString intValue]];
        newsInformation.subtitle = subtitle;
        
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
        
        if (top) {
            [topNewses addObject:newsInformation];
        }
        else
        {
            [notTopNewses addObject:newsInformation];
        }
    }
    NSDictionary* allNewsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:topNewses,@"置顶",notTopNewses,@"不置顶", nil];
    return allNewsDictionary;
}

//模板方法
//当接受完数据以后
- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    
}

//模板方法
//获取新闻内容
- (void)dohandleContent:(GDataXMLElement *)newsElement ToNews:(NewsObject *)news
{
    
}
@end
