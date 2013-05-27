//
//  NSDate-Compare.m
//  SchoolNews
//
//  Created by Jerry on 12月30星期日.
//
//

#import "NSDate-Compare.h"

@implementation NSDate (Compare)
//时间越晚越前面
- (NSComparisonResult)compare:(NSDate *)other
{
    if ([self earlierDate:other] == self) {
        return NSOrderedDescending;
    }
    else if ([self laterDate:other] == self)
    {
        return NSOrderedAscending;
    }
    else
    {
        return NSOrderedSame;
    }
}

- (NSComparisonResult)otherCompare:(NSDate* )other
{
    if ([self earlierDate:other] == self) {
        return NSOrderedAscending;
    }
    else if ([self laterDate:other] == self)
    {
        return NSOrderedDescending;
    }
    else
    {
        return NSOrderedSame;
    }
}
@end
