//
//  MoreFunctionPullViewController.h
//  SchoolNews
//
//  Created by Jerry on 3月18星期一.
//
//

#import <UIKit/UIKit.h>
#import "PullHeaderViewController.h"
#import "TouchEventTableView.h"
@class PullView;
@interface MoreFunctionPullViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TouchEventTableViewMoveDelegate,PullHeaderViewControllerDelegate>
{
    TouchEventTableView* tableView_;
    PullHeaderViewController* pullHeaderViewController_;
    PullView* pullView_;
}
+ (MoreFunctionPullViewController* )singleton;
@end
