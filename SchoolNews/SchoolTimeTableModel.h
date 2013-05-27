//
//  SchoolTimeTableModel.h
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import <Foundation/Foundation.h>
#import "ClassWebService.h"
#import "WeekIndexWebService.h"
@protocol SchoolTimeTableModelDelegate<NSObject>
@optional

- (void)getTheWeekIndexByWebService:(int )index;                //获得当前周次
- (void)getTheClasses:(NSDictionary* )dictionary AtWeek:(int )week Weekday:(int )weekday;   //获得所在时间的课程

@end

@interface SchoolTimeTableModel : NSObject<ClassWebServiceDelegate,WeekIndexWebServiceDelegate>

@property (nonatomic,assign)id<SchoolTimeTableModelDelegate> delegate;
+ (id )singleton;

- (NSDictionary* )getClassesInWeek:(int )week WeekDay:(int )weekDay;
- (int )getTheWeekIndex;
@end
