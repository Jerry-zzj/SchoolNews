//
//  ClassWebService.m
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import "ClassWebService.h"
#import "GDataDefines.h"
#import "GDataXMLNode.h"
#import "ClassObject.h"
@implementation ClassWebService
@synthesize delegate;
- (id)doHandleTheData:(NSString *)data
{
    //NSString* xml = [data stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    //NSLog(@"%@",data);
    GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:data
                                                                     options:0
                                                                       error:nil];
    GDataXMLElement* rootElement = [document rootElement];
    GDataXMLElement* temp = [[rootElement elementsForName:@"ns:return"]
                             objectAtIndex:0];
    NSArray* classElementes = [temp elementsForName:@"Class"];
    NSMutableArray* classes = [NSMutableArray array];
    for (GDataXMLElement* element in classElementes) {
        ClassObject* class = [[ClassObject alloc] init];
        
        //课程代码
        GDataXMLElement* classIDElement = [[element elementsForName:@"ClassID"] objectAtIndex:0];
        NSString* classID = [classIDElement stringValue];
        class.classID = classID;
        
        //课程名称
        GDataXMLElement* classNameElement = [[element elementsForName:@"ClassName"] objectAtIndex:0];
        NSString* className = [classNameElement stringValue];
        class.name = className;
        
        //学年
        GDataXMLElement* schoolYearElement = [[element elementsForName:@"SchoolYear"] objectAtIndex:0];
        NSString* schoolYear = [schoolYearElement stringValue];
        class.academicyear = schoolYear;
        
        //学期
        GDataXMLElement* semesterElement = [[element elementsForName:@"Semester"] objectAtIndex:0];
        NSString* semester = [semesterElement stringValue];
        class.semeter = [semester intValue];
        
        //教室代码
        GDataXMLElement* classroomIDElement = [[element elementsForName:@"ClassRoomID"] objectAtIndex:0];
        NSString* classroomID = [classroomIDElement stringValue];
        class.classRoomID = classroomID;
        
        //星期几
        GDataXMLElement* weekdayElement = [[element elementsForName:@"WeekDay"] objectAtIndex:0];
        NSString* weekday = [weekdayElement stringValue];
        class.weekDay = weekday;
        
        //周次
        GDataXMLElement* weekElement = [[element elementsForName:@"QuaryWeek"] objectAtIndex:0];
        NSString* week = [weekElement stringValue];
        class.week = week;
        
        //第几节
        GDataXMLElement* startClassIndexElement = [[element elementsForName:@"StartClassIndex"] objectAtIndex:0];
        NSString* startClassIndex = [startClassIndexElement stringValue];
        class.startClassIndex = startClassIndex;
        
        //起始周
        GDataXMLElement* startWeekElement = [[element elementsForName:@"StartWeek"] objectAtIndex:0];
        NSString* startWeek = [startWeekElement stringValue];
        class.startWeek = startWeek;
        
        //结束周
        GDataXMLElement* endWeekElement = [[element elementsForName:@"EndWeek"] objectAtIndex:0];
        NSString* endWeek = [endWeekElement stringValue];
        class.endWeek = endWeek;
        
        //课时
        GDataXMLElement* classLongElement = [[element elementsForName:@"ClassLong"] objectAtIndex:0];
        NSString* classLong = [classLongElement stringValue];
        class.classLong = [classLong intValue];
        
        //教室名称
        GDataXMLElement* classroomNameElement = [[element elementsForName:@"ClassRoomName"] objectAtIndex:0];
        NSString* classroomName = [classroomNameElement stringValue];
        class.classroomName = classroomName;
        
        //行政班
        GDataXMLElement* classGradeElement = [[element elementsForName:@"ClassAndGrade"] objectAtIndex:0];
        NSString* classAndGrade = [classGradeElement stringValue];
        class.classAndGrade = classAndGrade;
        
        //教师工号
        GDataXMLElement* teacherNumberElement = [[element elementsForName:@"TeacherWorkNumber"] objectAtIndex:0];
        NSString* teacherNumber = [teacherNumberElement stringValue];
        class.teacherNumber = teacherNumber;
        
        //教师姓名
        GDataXMLElement* teacherNameElement = [[element elementsForName:@"TeacherName"] objectAtIndex:0];
        NSString* teacherName = [teacherNameElement stringValue];
        class.teacher = teacherName;
        
        [classes addObject:class];
    }
    return classes;
}

//模板方法
//当接受完数据以后
- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    /*[[NSNotificationCenter defaultCenter] postNotificationName:MEET_END_UPDATE_WITH_WEBSERVICE
     object:object];*/
    [self.delegate finishGetClassData:object];
}
@end
