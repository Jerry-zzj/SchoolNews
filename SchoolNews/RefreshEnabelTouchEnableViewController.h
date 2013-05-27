//
//  RefreshEnabelTouchEnableViewController.h
//  SchoolNews
//
//  Created by Jerry on 1月9星期三.
//
//

#import "RefreshEnableTableViewController.h"
#import "TouchEventTableView.h"
@protocol RefreshEnabelTouchEnableViewControllerDelegate<NSObject>

- (void)moveToLeft;
- (void)moveToRight;

@end
@interface RefreshEnabelTouchEnableViewController : RefreshEnableTableViewController<TouchEventTableViewMoveDelegate>

@property (nonatomic,assign)id<RefreshEnabelTouchEnableViewControllerDelegate> touchMoveDelegate;

//- (id)initWithStyle:(UITableViewStyle)style Frame:(CGRect )frame;

@end
