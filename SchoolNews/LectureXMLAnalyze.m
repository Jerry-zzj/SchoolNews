//
//  LectureXMLAnalyze.m
//  SchoolNews
//
//  Created by Jerry on 5月22星期三.
//
//

#import "LectureXMLAnalyze.h"
#import "GDataDefines.h"
#import "GDataXMLNode.h"
#import "AboutTime.h"
#import "LectureObject.h"
@implementation LectureXMLAnalyze
+ (id)analyzeXML:(NSString *)xmlSender
{
    NSString* data = [super analyzeXML:xmlSender];
    GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:data
                                                                     options:0
                                                                       error:nil];
    GDataXMLElement* rootElement = [document rootElement];
    GDataXMLElement* temp = [[rootElement elementsForName:@"ns:return"]
                             objectAtIndex:0];
    NSArray* lectures = [temp elementsForName:@"Lecture"];
    NSMutableArray* tempInformation = [NSMutableArray array];
    for (GDataXMLElement* element in lectures) {
        LectureObject* lecture = [[LectureObject alloc] init];
        
        //ID
        GDataXMLElement* idElement = [[element elementsForName:@"ID"] objectAtIndex:0];
        NSString* ID = [idElement stringValue];
        lecture.ID = ID;
        
        //标题
        GDataXMLElement* titleElement = [[element elementsForName:@"Title"]
                                         objectAtIndex:0];
        NSString* title = [titleElement stringValue];
        lecture.title = title;
        
        //日期
        GDataXMLElement* dateElement = [[element elementsForName:@"Date"]
                                        objectAtIndex:0];
        NSString* dateString = [dateElement stringValue];
        NSDate* date = [[AboutTime singleton] getDateFromString:dateString];
        lecture.date = date;
        
        //承办者
        GDataXMLElement* undertakerElement = [[element elementsForName:@"Undertaker"]
                                              objectAtIndex:0];
        NSString* undertaker = [undertakerElement stringValue];
        lecture.underTaker = undertaker;
        
        //地点
        GDataXMLElement* placeElement = [[element elementsForName:@"Place"]
                                         objectAtIndex:0];
        NSString* place = [placeElement stringValue];
        lecture.place = place;
        
        //演讲者
        GDataXMLElement* lecturerElement = [[element elementsForName:@"Lecturer"]
                                            objectAtIndex:0];
        NSString* lecturer = [lecturerElement stringValue];
        lecture.lecturer = lecturer;
        
        //演讲人介绍
        GDataXMLElement* lecturerIntroductionElement = [[element elementsForName:@"LecturerIntroduction"]
                                                        objectAtIndex:0];
        NSString* lecturerIntroduction = [lecturerIntroductionElement stringValue];
        lecture.lecturerIntroduction = lecturerIntroduction;
        
        //讲座介绍
        GDataXMLElement* lectureIntroductionIntroductionElement = [[element elementsForName:@"LecturesIntroduction"] objectAtIndex:0];
        NSString* lectureIntroductionIntroduction = [lectureIntroductionIntroductionElement stringValue];
        lecture.lecturesIntroduction = lectureIntroductionIntroduction;
        
        //将会议加到会议数组中
        [tempInformation addObject:lecture];
    }
    return tempInformation;
}
@end
