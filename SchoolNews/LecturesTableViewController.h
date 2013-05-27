//
//  LecturesTableViewController.h
//  SchoolNews
//
//  Created by Jerry on 12月30星期日.
//
//

#import "RefreshEnableTableViewController.h"
@protocol LecturesTableViewControllerDelegate

- (void)selectLecture:(id)sender;

@end
@interface LecturesTableViewController : RefreshEnableTableViewController
@property (nonatomic,assign)id<LecturesTableViewControllerDelegate> delegate;
@end
