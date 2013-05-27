//
//  CampusHotlineViewController.h
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import "CampusHotlineTableViewController.h"
#import <UIKit/UIKit.h>
@interface CampusHotlineViewController : UIViewController<CampusHotlineTableViewControllerDelegate,UIActionSheetDelegate,RefreshUnableTouchEnableViewControllerDelegate>
{
    CampusHotlineTableViewController* campusHotlineTableViewController_;
}
@property (nonatomic,strong)NSDictionary* selectedHotline;
+ (CampusHotlineViewController* )singleton;
@end
