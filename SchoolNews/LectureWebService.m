//
//  LectureWebService.m
//  SchoolNews
//
//  Created by Jerry on 12月28星期五.
//
//

#import "LectureWebService.h"
#import "GDataXMLNode.h"
#import "LectureObject.h"
#import "AboutTime.h"

@implementation LectureWebService
LectureWebService* g_LectureWebService;
+ (LectureWebService* )singleton
{
    if (g_LectureWebService == nil) {
        g_LectureWebService = [[LectureWebService alloc] init];
    }
    return g_LectureWebService;
}
//模板方法
//处理webservice收到的数据
- (id)doHandleTheData:(NSString *)data
{
    //NSString* xml = [data stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    //NSLog(@"%@",xml);
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

//模板方法
//当接受完数据以后
- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LectureEndUpdate" object:object];
}

- (void)savetTheDataToBuffer:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveInLectureBuffer"
                                                        object:sender];
    
}
@end
