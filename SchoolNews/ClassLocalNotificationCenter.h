//
//  ClassLocalNotificationCenter.h
//  SchoolNews
//
//  Created by Jerry on 5月24星期五.
//
//

#import <Foundation/Foundation.h>

@interface ClassLocalNotificationCenter : NSObject
+ (id)singleton;
- (void)setClasses:(NSArray* )array;
@end
