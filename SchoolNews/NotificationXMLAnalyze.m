//
//  NotificationXMLAnalyze.m
//  SchoolNews
//
//  Created by Jerry on 5月21星期二.
//
//

#import "NotificationXMLAnalyze.h"
#import "GDataDefines.h"
#import "GDataXMLNode.h"
#import "NotificationObject.h"
#import "AboutTime.h"
@implementation NotificationXMLAnalyze
+ (id)analyzeXML:(NSString *)xmlSender
{
    NSString* data = [super analyzeXML:xmlSender];
    GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:data
                                                                     options:0
                                                                       error:nil];
    GDataXMLElement* rootElement = [document rootElement];
    GDataXMLElement* temp = [[rootElement elementsForName:@"ns:return"]
                             objectAtIndex:0];
    NSArray* lectures = [temp elementsForName:@"Notification"];
    NSMutableArray* tempInformation = [NSMutableArray array];
    for (GDataXMLElement* element in lectures) {
        NotificationObject* notification = [[NotificationObject alloc] init];
        
        //ID
        GDataXMLElement* idElement = [[element elementsForName:@"ID"] objectAtIndex:0];
        NSString* ID = [idElement stringValue];
        notification.ID = ID;
        
        //标题
        GDataXMLElement* titleElement = [[element elementsForName:@"Title"]
                                         objectAtIndex:0];
        NSString* title = [titleElement stringValue];
        notification.title = title;
        
        //日期
        GDataXMLElement* dateElement = [[element elementsForName:@"Date"]
                                        objectAtIndex:0];
        NSString* dateString = [dateElement stringValue];
        NSDate* date = [[AboutTime singleton] getDateFromString:dateString];
        notification.date = date;
        
        //类型
        GDataXMLElement* typeElement = [[element elementsForName:@"Type"]
                                        objectAtIndex:0];
        NSString* typeString = [typeElement stringValue];
        notification.type = typeString;
        
        //内容
        GDataXMLElement* contentElement = [[element elementsForName:@"Content"]
                                           objectAtIndex:0];
        NSString* content = [contentElement stringValue];
        notification.content = content;
        
        //发布部门
        GDataXMLElement* departmentElement = [[element elementsForName:@"Department"]
                                              objectAtIndex:0];
        NSString* department = [departmentElement stringValue];
        notification.department = department;
        //将通知加到通知数组中
        [tempInformation addObject:notification];
    }
    return tempInformation;
}
@end
