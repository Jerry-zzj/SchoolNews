//
//  NotificationWebService.m
//  SchoolNews
//
//  Created by Jerry on 12月29星期六.
//
//

#import "NotificationWebService.h"
#import "GDataXMLNode.h"
#import "AboutTime.h"
#import "NotificationObject.h"
@implementation NotificationWebService
@synthesize delegate;
//模板方法
//处理webservice收到的数据
- (id)doHandleTheData:(NSString *)data
{
    NSLog(@"%@",data);
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

//模板方法
//当接受完数据以后
- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_END_UPDATE_WITH_WEBSERVICE
                                                        object:object];
    [self.delegate getNotifications:object];

}

- (void)savetTheDataToBuffer:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveInNotificationBuffer"
                                                        object:sender];

}
@end
