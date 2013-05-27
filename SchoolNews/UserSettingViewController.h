//
//  UserSettingViewController.h
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import <UIKit/UIKit.h>
#import "UserSettingTableViewController.h"
@class UserSettingTableViewController;
@interface UserSettingViewController : UIViewController<UserSettingTableViewControllerDelegate,LoginViewControllerDelegate>
{
    UserSettingTableViewController* userSettingTableViewController_;
}
+ (UserSettingViewController* )singleton;
@end
