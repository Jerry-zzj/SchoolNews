//
//  RefreshUnableTouchEnableViewController.h
//  SchoolNews
//
//  Created by shuangchi on 12月3星期一.
//
//

#import "RefreshUnableTableViewController.h"
#import "TouchEventTableView.h"
@protocol RefreshUnableTouchEnableViewControllerDelegate<NSObject>

- (void)moveToLeft;
- (void)moveToRight;

@end

@interface RefreshUnableTouchEnableViewController : RefreshUnableTableViewController<TouchEventTableViewMoveDelegate>
@property (nonatomic,assign)id<RefreshUnableTouchEnableViewControllerDelegate> touchMoveDelegate;
- (id)initWithStyle:(UITableViewStyle)style Frame:(CGRect )frame;
@end
