//
//  GroupViewController.h
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import <UIKit/UIKit.h>
@protocol GroupViewControllerDelegate

- (void)selectTheGroup:(NSString* )group;

@end
@interface GroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    float bottom_;
    //UIScrollView* backgroundScrollView_;
    UITableView* tableView_;
    UIView* backgroundView_;
}
@property (nonatomic, assign)id<GroupViewControllerDelegate> delegate;
+ (GroupViewController* )singleton;
@end
