//
//  ClassObject.m
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import "ClassObject.h"

#define CLASS_ID_KEY                            @"ClassID"
#define NAME_KEY                                @"Name"
#define CLASSROOM_ID_KEY                        @"ClassroomID"
#define WEEKDAY_KEY                             @"Weekday"
#define WEEK_KEY                                @"Week"
#define START_CLASS_INDEX_KEY                   @"StartClassIndex"
#define START_WEEK_KEY                          @"StartWeek"
#define END_WEEK_KEY                            @"EndWeek"
#define CLASS_LONG_KEY                          @"ClassLong"
#define CLASSROOM_NAME_KEY                      @"ClassroomName"
#define CLASS_GRADE_KEY                         @"ClassAndGrade"
#define TEACHER_NUMBER_KEY                      @"TeacherNumber"
#define TEACKER_KEY                             @"Teacher"
#define ACADEMIC_YEAR_KEY                       @"AcademicYear"
#define SEMETER_KEY                             @"Semeter"
#define SINGLE_DOUBLE_WEEK_KEY                  @"SingleDoubleWeek"
@implementation ClassObject

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.classID = [aDecoder decodeObjectForKey:CLASS_ID_KEY];
        self.name = [aDecoder decodeObjectForKey:NAME_KEY];
        self.classRoomID = [aDecoder decodeObjectForKey:CLASSROOM_ID_KEY];
        self.weekDay = [aDecoder decodeObjectForKey:WEEKDAY_KEY];
        self.week = [aDecoder decodeObjectForKey:WEEK_KEY];
        self.startClassIndex = [aDecoder decodeObjectForKey:START_CLASS_INDEX_KEY];
        self.startWeek = [aDecoder decodeObjectForKey:START_WEEK_KEY];
        self.endWeek = [aDecoder decodeObjectForKey:END_WEEK_KEY];
        self.classLong = [aDecoder decodeIntForKey:CLASS_LONG_KEY];
        self.classroomName = [aDecoder decodeObjectForKey:CLASSROOM_NAME_KEY];
        self.classAndGrade = [aDecoder decodeObjectForKey:CLASS_GRADE_KEY];
        self.teacherNumber = [aDecoder decodeObjectForKey:TEACHER_NUMBER_KEY];
        self.teacher = [aDecoder decodeObjectForKey:TEACKER_KEY];
        self.academicyear = [aDecoder decodeObjectForKey:ACADEMIC_YEAR_KEY];
        self.semeter = [aDecoder decodeIntForKey:SEMETER_KEY];
        self.singleDoubleWeek = [aDecoder decodeObjectForKey:SINGLE_DOUBLE_WEEK_KEY];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.classID forKey:CLASS_ID_KEY];
    [aCoder encodeObject:self.classRoomID forKey:CLASSROOM_ID_KEY];
    [aCoder encodeObject:self.name forKey:NAME_KEY];
    [aCoder encodeObject:self.weekDay forKey:WEEKDAY_KEY];
    [aCoder encodeObject:self.week forKey:WEEK_KEY];
    [aCoder encodeObject:self.startClassIndex forKey:START_CLASS_INDEX_KEY];
    [aCoder encodeObject:self.startWeek forKey:START_WEEK_KEY];
    [aCoder encodeObject:self.endWeek forKey:END_WEEK_KEY];
    [aCoder encodeInt:self.classLong forKey:CLASS_LONG_KEY];
    [aCoder encodeObject:self.classroomName forKey:CLASSROOM_NAME_KEY];
    [aCoder encodeObject:self.classAndGrade forKey:CLASS_GRADE_KEY];
    [aCoder encodeObject:self.teacherNumber forKey:TEACHER_NUMBER_KEY];
    [aCoder encodeObject:self.teacher forKey:TEACKER_KEY];
    [aCoder encodeObject:self.academicyear forKey:ACADEMIC_YEAR_KEY];
    [aCoder encodeInt:self.semeter forKey:SEMETER_KEY];
    [aCoder encodeObject:self.singleDoubleWeek forKey:SINGLE_DOUBLE_WEEK_KEY];
}
    
- (id)copyWithZone:(NSZone *)zone
{
    ClassObject* class = [[ClassObject alloc] init];
    class.classID = [self.classID copyWithZone:zone];
    class.classRoomID = [self.classRoomID copyWithZone:zone];
    class.name = [self.name copyWithZone:zone];
    class.weekDay = [self.weekDay copyWithZone:zone];
    class.week = [self.week copyWithZone:zone];
    class.startClassIndex = [self.startClassIndex copyWithZone:zone];
    class.startWeek = [self.startWeek copyWithZone:zone];
    class.endWeek = [self.endWeek copyWithZone:zone];
    class.classLong = self.classLong;
    class.classroomName = [self.classroomName copyWithZone:zone];
    class.classAndGrade = [self.classAndGrade copyWithZone:zone];
    class.teacherNumber = [self.teacherNumber copyWithZone:zone];
    class.teacher = [self.teacher copyWithZone:zone];
    class.academicyear = [self.academicyear copyWithZone:zone];
    class.semeter = self.semeter;
    class.singleDoubleWeek = [self.singleDoubleWeek copyWithZone:zone];
    return class;
}

- (NSComparisonResult)compare:(ClassObject* )sender
{
    int selfStartIndex = [self.startClassIndex intValue];
    int senderStartIndex = [sender.startClassIndex intValue];
    if (selfStartIndex > senderStartIndex) {
        return NSOrderedDescending;
    }
    if (selfStartIndex < senderStartIndex){
        return NSOrderedAscending;
    }
    else
    {
        return NSOrderedSame;
    }
}

- (UILocalNotification* )transformToLocalNotification
{
    //UILocalNotification* notification = [];
}
@end
