//
//  UserSettingViewController.h
//  SchoolNews
//
//  Created by shuangchi on 12月1星期六.
//
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
@protocol UserSettingTableViewControllerDelegate

- (void)selectTheIdentifier:(NSString* )sender;

@end
@interface UserSettingTableViewController : UITableViewController
{
    NSDictionary* settingDictionary_;
    NSArray* allKeys_;
    NSString* fontSizeText_;
}
@property (nonatomic,assign)id<UserSettingTableViewControllerDelegate> delegate;
+ (UserSettingTableViewController* )singleton;
@end
