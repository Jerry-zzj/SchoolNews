//
//  LectureObject.m
//  SchoolNews
//
//  Created by Jerry on 12月26星期三.
//
//

#import "LectureObject.h"
#define ID_KEY                                          @"ID"
#define TITLE_KEY                                       @"Title"
#define DATE_KEY                                        @"Date"
#define UNDERTAKER_KEY                                  @"Undertaker"
#define PLACE_KEY                                       @"Place"
#define LECTURER_KEY                                    @"Lecturer"
#define LECTURER_INTRODUCTION_KEY                       @"LecturerIntroduction"
#define LECTURE_INTRODUCTION_KEY                        @"LectureIntroduction"


@implementation LectureObject
@synthesize ID;
@synthesize title;
@synthesize date;
@synthesize underTaker;
@synthesize place;
@synthesize lecturer;
@synthesize lecturerIntroduction;
@synthesize lecturesIntroduction;
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:ID forKey:ID_KEY];
    [aCoder encodeObject:title forKey:TITLE_KEY];
    [aCoder encodeObject:underTaker forKey:UNDERTAKER_KEY];
    [aCoder encodeObject:place forKey:PLACE_KEY];
    [aCoder encodeObject:lecturer forKey:LECTURER_KEY];
    [aCoder encodeObject:lecturerIntroduction forKey:LECTURER_INTRODUCTION_KEY];
    [aCoder encodeObject:lecturesIntroduction forKey:LECTURE_INTRODUCTION_KEY];
    [aCoder encodeObject:date forKey:DATE_KEY];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.ID = [aDecoder decodeObjectForKey:ID_KEY];
        self.title = [aDecoder decodeObjectForKey:TITLE_KEY];
        self.underTaker = [aDecoder decodeObjectForKey:UNDERTAKER_KEY];
        self.place = [aDecoder decodeObjectForKey:PLACE_KEY];
        self.lecturer = [aDecoder decodeObjectForKey:LECTURER_KEY];
        self.lecturerIntroduction = [aDecoder decodeObjectForKey:LECTURER_INTRODUCTION_KEY];
        self.lecturesIntroduction = [aDecoder decodeObjectForKey:LECTURE_INTRODUCTION_KEY];
        self.date = [aDecoder decodeObjectForKey:DATE_KEY];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    LectureObject* lecture = [[LectureObject allocWithZone:zone] init];
    lecture.ID = [self.ID copyWithZone:zone];
    lecture.title = [self.title copyWithZone:zone];
    lecture.underTaker = [self.underTaker copyWithZone:zone];
    lecture.place = [self.place copy];
    lecture.lecturer = [self.lecturer copyWithZone:zone];
    lecture.lecturerIntroduction = [self.lecturerIntroduction copyWithZone:zone];
    lecture.lecturesIntroduction = [self.lecturesIntroduction copy];
    lecture.date = [self.date copyWithZone:zone];
    return lecture;
}

@end
