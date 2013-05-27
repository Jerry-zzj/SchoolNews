//
//  MeetObject.h
//  SchoolNews
//
//  Created by Jerry on 12月26星期三.
//
//

#import <Foundation/Foundation.h>

@interface MeetObject : NSObject<NSCoding,NSCopying>
@property (nonatomic,retain)NSString* ID;
@property (nonatomic,assign)int week;
@property (nonatomic,retain)NSDate* date;
@property (nonatomic,retain)NSString* weekDay;
@property (nonatomic,retain)NSString* place;
@property (nonatomic,retain)NSString* content;
@property (nonatomic,retain)NSString* host;
@property (nonatomic,retain)NSString* executiveDepartments;
@property (nonatomic,retain)NSString* participants;
@end
