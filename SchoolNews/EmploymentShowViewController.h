//
//  EmploymentShowViewController.h
//  SchoolNews
//
//  Created by Jerry on 4月11星期四.
//
//

#import <UIKit/UIKit.h>
#import "JobObject.h"
#import "EmploymentWebservice.h"
#import "TouchEventTableView.h"
#import "EmploymentCompanyHeaderView.h"
@interface EmploymentShowViewController : UITableViewController<EmploymentWebserviceDelegate,TouchEventTableViewMoveDelegate,EmploymentCompanyHeaderViewDelegate>
- (id)initWithEmployment:(JobObject* )sender;

@end
