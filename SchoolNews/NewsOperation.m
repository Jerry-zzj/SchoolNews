//
//  NewsOperation.m
//  SchoolNews
//
//  Created by shuangchi on 12月17星期一.
//
//

#import "NewsOperation.h"
#import "GDataXMLNode.h"

@interface NewsOperation(private)

- (void)finishGetTheWebServiceData;
- (void)handleTheData:(NSData* )data;

@end

@implementation NewsOperation
- (id)initWithURL:(NSString* )urlString AndFinishedNotification:(NSString* )notificationName
{
    self = [super init];
    if (self) {
        urlString_ = [NSString stringWithString:urlString];
        finishedNotificationName_ = [NSString stringWithString:notificationName];
    }
    return self;
}

- (void) main
{
    NSURL* url = [NSURL URLWithString:urlString_];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    NSURLConnection* urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    if (urlConnection == nil) {
        NSLog(@"connection faild");
    }
}

//通过response的响应，判断是否连接存在
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@",response);
}

//返回的错误信息
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

//通过data获得请求后，返回的数据，数据类型NSData
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self handleTheData:data];
    [self finishGetTheWebServiceData];
    [NSThread exit];
}

- (void)handleTheData:(NSData *)data
{
    NSString* xmlTemp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",xmlTemp);
    NSString* xml = [xmlTemp stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    NSLog(@"%@",xml);
    //GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xml
                                                                     options:0
                                                                       error:nil];
    GDataXMLElement* rootElement = [document rootElement];
    GDataXMLElement* temp = [[rootElement elementsForName:@"ns:return"] objectAtIndex:0];
    NSArray* newses = [temp elementsForName:@"News"];
    NSMutableArray* tempInformation = [NSMutableArray array];
    for (GDataXMLElement* news in newses) {
        NSMutableDictionary* newsInformation = [NSMutableDictionary dictionary];
        
        GDataXMLElement* titleelement = [[news elementsForName:@"Title"] objectAtIndex:0];
        NSString* title = [titleelement stringValue];
        [newsInformation setValue:title forKey:@"Title"];
        
        GDataXMLElement* contentElement = [[news elementsForName:@"Content"] objectAtIndex:0];
        NSString* content = [contentElement stringValue];
        [newsInformation setValue:content forKey:@"Content"];
        
        GDataXMLElement* imageElement = [[news elementsForName:@"ImageURL"] objectAtIndex:0];
        NSString* imageUrl = [imageElement stringValue];
        [newsInformation setValue:imageUrl forKey:@"ImageURL"];
        
        GDataXMLElement* functionElement = [[news elementsForName:@"FunctionID"] objectAtIndex:0];
        NSString* functionID = [functionElement stringValue];
        [newsInformation setValue:functionID forKey:@"FunctionID"];
        
        GDataXMLElement* subtitleElement = [[news elementsForName:@"SubtitleID"] objectAtIndex:0];
        NSString* subtitleID = [subtitleElement stringValue];
        [newsInformation setValue:subtitleID forKey:@"SubtitleID"];
        
        GDataXMLElement* topElement = [[news elementsForName:@"Top"] objectAtIndex:0];
        NSString* top = [topElement stringValue];
        [newsInformation setValue:top forKey:@"Top"];
        
        GDataXMLElement* dateElement = [[news elementsForName:@"DateTime"] objectAtIndex:0];
        NSString* date = [dateElement stringValue];
        [newsInformation setValue:date forKey:@"DateTime"];
        [tempInformation addObject:newsInformation];
    }
    receiveNewses_ = [tempInformation copy];
}

- (void)finishGetTheWebServiceData
{
    NSDictionary* userInformation = [NSDictionary dictionaryWithObjectsAndKeys:receiveNewses_,@"Information", nil];
    NSNotification* notification = [NSNotification
                                    notificationWithName:finishedNotificationName_
                                    object:nil
                                    userInfo:userInformation];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
