//
//  CampusHotlineTableViewController.h
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import "RefreshUnableTouchEnableViewController.h"
@protocol CampusHotlineTableViewControllerDelegate<NSObject>

- (void)selectTheHotline:(NSDictionary* )hotline;

@end
@interface CampusHotlineTableViewController : RefreshUnableTouchEnableViewController

@property (nonatomic,assign)id<CampusHotlineTableViewControllerDelegate>selectHotlineDelegate;
+ (CampusHotlineTableViewController* )singleton;
@end
