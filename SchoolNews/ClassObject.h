//
//  ClassObject.h
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import <Foundation/Foundation.h>

@interface ClassObject : NSObject<NSCopying,NSCoding>
@property (nonatomic,retain) NSString* classID;                 //课程代码
@property (nonatomic,retain) NSString* name;                    //名称
@property (nonatomic,retain) NSString* classRoomID;             //教室代码
@property (nonatomic,retain) NSString* weekDay;                 //星期几
@property (nonatomic,retain) NSString* week;                    //周次
@property (nonatomic,retain) NSString* startClassIndex;         //第几节
@property (nonatomic,retain) NSString* startWeek;               //起始周
@property (nonatomic,retain) NSString* endWeek;                 //结束周
@property (nonatomic,assign) int classLong;                     //课时
@property (nonatomic,retain) NSString* classroomName;            //教室名称
@property (nonatomic,retain) NSString* classAndGrade;           //行政班
@property (nonatomic,retain) NSString* teacherNumber;           //教师工号
@property (nonatomic,retain) NSString* teacher;                 //老师
@property (nonatomic,retain) NSString* academicyear;            //学年
@property (nonatomic,assign) int semeter;                       //学期
@property (nonatomic,retain) NSString* singleDoubleWeek;        //单双周
- (NSComparisonResult)compare:(ClassObject* )sender;
- (UILocalNotification* )transformToLocalNotification;

@end
