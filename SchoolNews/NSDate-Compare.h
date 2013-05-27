//
//  NSDate-Compare.h
//  SchoolNews
//
//  Created by Jerry on 12月30星期日.
//
//

#import <Foundation/Foundation.h>
@interface NSDate(Compare)
- (NSComparisonResult)compare:(NSDate *)other;
- (NSComparisonResult)otherCompare:(NSDate* )other;
@end
