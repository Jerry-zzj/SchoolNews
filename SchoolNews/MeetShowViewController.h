//
//  MeetShowViewController.h
//  SchoolNews
//
//  Created by Jerry on 1月10星期四.
//
//

#import <UIKit/UIKit.h>
#import "MeetObject.h"
#import "FixedSequenceTableViewController.h"
#import "MeetShowWebService.h"
@interface MeetShowViewController : UIViewController<RefreshUnableTouchEnableViewControllerDelegate,MeetShowWebServiceDelegate>
{
    FixedSequenceTableViewController* showTableView_;
    MeetObject* meet_;
}
@property(nonatomic,retain)MeetObject* showMeet;
- (id)initWithShowMeet:(MeetObject* )meet;
@end
