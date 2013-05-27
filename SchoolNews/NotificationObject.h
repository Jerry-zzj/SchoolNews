//
//  NotificationObject.h
//  SchoolNews
//
//  Created by Jerry on 12月26星期三.
//
//

#import <Foundation/Foundation.h>

@interface NotificationObject : NSObject<NSCopying,NSCoding>

@property (nonatomic,retain)NSString* ID;
@property (nonatomic,retain)NSString* title;
@property (nonatomic,retain)NSString* content;
@property (nonatomic,retain)NSString* department;
@property (nonatomic,retain)NSDate* date;
@property (nonatomic,retain)NSString* type;
@end
