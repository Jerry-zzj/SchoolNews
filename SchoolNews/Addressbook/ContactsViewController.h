//
//  ContactsViewController.h
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import "FunctionViewController.h"
#import "ContactsTableViewController.h"
#import "GroupViewController.h"
#import "LoginViewController.h"
@protocol ContactsViewControllerDelegate<NSObject>

- (void)groupShow;
- (void)groupHidden;

@end

@class ContactsTableViewController;
@class GroupViewController;
@interface ContactsViewController : FunctionViewController<ContactsTableViewControllerDelegate,RefreshUnableTouchEnableViewControllerDelegate,GroupViewControllerDelegate,LoginViewControllerDelegate,UIAlertViewDelegate>
{
    ContactsTableViewController* contactsTableViewController_;
    GroupViewController* groupViewController_;
    BOOL groupViewShow_;
    BOOL loadAllContactsToLocalIng_;
}
@property (nonatomic,assign)id<ContactsViewControllerDelegate> delegate;
+ (ContactsViewController* )singleton;
@end
