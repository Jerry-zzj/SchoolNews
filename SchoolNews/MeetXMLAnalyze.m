//
//  MeetXMLAnalyze.m
//  SchoolNews
//
//  Created by Jerry on 5月22星期三.
//
//

#import "MeetXMLAnalyze.h"
#import "GDataDefines.h"
#import "GDataXMLNode.h"
#import "AboutTime.h"
#import "MeetObject.h"

@implementation MeetXMLAnalyze
+ (id)analyzeXML:(NSString *)xmlSender
{
    NSString* data = [super analyzeXML:xmlSender];
    GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:data
                                                                     options:0
                                                                       error:nil];
    GDataXMLElement* rootElement = [document rootElement];
    GDataXMLElement* temp = [[rootElement elementsForName:@"ns:return"]
                             objectAtIndex:0];
    NSArray* meets = [temp elementsForName:@"Meet"];
    NSMutableArray* tempInformation = [NSMutableArray array];
    for (GDataXMLElement* element in meets) {
        MeetObject* meet = [[MeetObject alloc] init];
        //ID
        GDataXMLElement* idElement = [[element elementsForName:@"ID"] objectAtIndex:0];
        NSString* idString = [idElement stringValue];
        meet.ID = idString;
        
        //第几周
        GDataXMLElement* weekElement = [[element elementsForName:@"Week"]
                                        objectAtIndex:0];
        NSString* weekString = [weekElement stringValue];
        meet.week = [weekString intValue];
        
        //日期
        GDataXMLElement* dateElement = [[element elementsForName:@"Date"]
                                        objectAtIndex:0];
        NSString* dateString = [dateElement stringValue];
        NSDate* date = [[AboutTime singleton] getDateFromString:dateString];
        meet.date = date;
        
        //周几
        GDataXMLElement* weekdayElement = [[element elementsForName:@"Weekday"]
                                           objectAtIndex:0];
        NSString* weekday = [weekdayElement stringValue];
        meet.weekDay = weekday;
        
        //地点
        GDataXMLElement* placeElement = [[element elementsForName:@"Place"]
                                         objectAtIndex:0];
        NSString* place = [placeElement stringValue];
        meet.place = place;
        
        //内容
        GDataXMLElement* contentElement = [[element elementsForName:@"Content"]
                                           objectAtIndex:0];
        NSString* content = [contentElement stringValue];
        meet.content = content;
        
        //主持人
        GDataXMLElement* hostElement = [[element elementsForName:@"Host"]
                                        objectAtIndex:0];
        NSString* host = [hostElement stringValue];
        meet.host = host;
        
        //执行部门
        GDataXMLElement* executiveDepartmentsElement = [[element elementsForName:@"ExecutiveDepartments"] objectAtIndex:0];
        NSString* executiveDepartments = [executiveDepartmentsElement stringValue];
        meet.executiveDepartments = executiveDepartments;
        
        //参加者
        GDataXMLElement* participantsElement = [[element elementsForName:@"Participants"]
                                                objectAtIndex:0];
        NSString* participants = [participantsElement stringValue];
        meet.participants = participants;
        
        //将会议加到会议数组中
        [tempInformation addObject:meet];
    }
    return tempInformation;
}
@end
