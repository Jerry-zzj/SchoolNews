//
//  WeekIndexWebService.h
//  SchoolNews
//
//  Created by Jerry on 3月11星期一.
//
//

#import "WebService.h"

#define GET_WEEK_INDEX_FROM_SERVER                      @"finishGetWeekIndexFromServer"
@protocol WeekIndexWebServiceDelegate<NSObject>

- (void)getTheWeekIndex:(int )weekIndex;

@end
@interface WeekIndexWebService : WebService
@property (nonatomic,assign) id<WeekIndexWebServiceDelegate> delegate;
@end
