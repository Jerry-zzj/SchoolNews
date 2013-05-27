//
//  MeetsViewController.h
//  SchoolNews
//
//  Created by Jerry on 3月26星期二.
//
//

#import "FunctionViewController.h"
#import "LoginViewController.h"
#import "MeetListTableViewController.h"
#import "MeetCollectionViewController.h"
@class MeetCollectionViewController;
@interface MeetsViewController : FunctionViewController<LoginViewControllerDelegate,MeetListTableViewControllerDelegate,MeetCollectionViewControllerDelegate>
{
    UISegmentedControl* weekdaySegmentedControl_;
    UILabel* weekLabel_;
    //UILabel* weekDayLabel_;
    MeetCollectionViewController* collectionViewController_;
    
    NSNumber* week_;
    NSNumber* weekday_;
    
    UIImageView* haveNoRightImageView_;
}
+ (MeetsViewController* )singleton;
@end
