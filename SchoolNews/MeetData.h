//
//  MeetData.h
//  SchoolNews
//
//  Created by Jerry on 1月10星期四.
//
//

#import <Foundation/Foundation.h>
#import "MeetObject.h"
typedef enum{
    Person,
    All
}DataStyle;

@interface MeetData : NSObject
{
    DataStyle style_;
}
@property (nonatomic,retain) NSMutableDictionary* meetDictionary;
@property (nonatomic,assign) DataStyle style;
//@property (nonatomic,assign) id<MeetDataDelegate> delegate;
+ (MeetData* )singleton;
- (NSArray* )getMeetForWeek:(int )week Weekday:(int )weekday;
- (void )addMeets:(NSArray* )meets ForWeek:(int )week Weekday:(int )weekday;
- (MeetObject* )getMeetForID:(NSString* )IDSender AndWeek:(int )weekSender AndWeekday:(int )weekday;
@end
