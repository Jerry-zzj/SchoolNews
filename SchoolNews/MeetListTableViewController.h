//
//  AllMeetListTableViewController.h
//  SchoolNews
//
//  Created by Jerry on 1月9星期三.
//
//

#import "RefreshUnableTouchEnableViewController.h"
@class MeetObject;
@protocol MeetListTableViewControllerDelegate<NSObject>

- (void)selectTheMeet:(MeetObject* )sender;

@end
@interface MeetListTableViewController : RefreshUnableTouchEnableViewController
{
    int week_;
    int weekday_;
    BOOL loading_;
}
@property (nonatomic,assign)id<MeetListTableViewControllerDelegate> delegate;
@property (nonatomic)int week;
@property (nonatomic,assign)int weekday;
- (void)updateTheDataWithWeek:(int )week Weekday:(NSString* )weekday;
- (int )getWeek;
- (int )getWeekday;
@end
