//
//  LectureObject.h
//  SchoolNews
//
//  Created by Jerry on 12月26星期三.
//
//

#import <Foundation/Foundation.h>

@interface LectureObject : NSObject<NSCoding,NSCopying>
@property (nonatomic,retain)NSString* ID;
@property (nonatomic,retain)NSString* title;
@property (nonatomic,retain)NSDate* date;
@property (nonatomic,retain)NSString* underTaker;
@property (nonatomic,retain)NSString* place;
@property (nonatomic,retain)NSString* lecturer;
@property (nonatomic,retain)NSString* lecturerIntroduction;
@property (nonatomic,retain)NSString* lecturesIntroduction;
@end
