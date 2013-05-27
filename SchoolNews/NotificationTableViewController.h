//
//  NotificationTableViewController.h
//  SchoolNews
//
//  Created by Jerry on 12月29星期六.
//
//

#import "RefreshEnableTableViewController.h"
#import "NotificationWebService.h"
@protocol NotificationTableViewControllerDelegate

- (void)selectTheNotification:(id)sender;

@end
@interface NotificationTableViewController : RefreshEnableTableViewController<NotificationWebServiceDelegate>
@property (nonatomic,assign)id<NotificationTableViewControllerDelegate> delegate;
- (void)setNotificationTableTitle:(NSString* )sender;
@end
