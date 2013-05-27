//
//  EmploymentListTableViewController.h
//  SchoolNews
//
//  Created by Jerry on 4月10星期三.
//
//

#import "RefreshEnableTableViewController.h"
#import "EmploymentWebservice.h"
#import "SubFunctionProtocol.h"
@protocol EmploymentListTableViewControllerDelegate

- (void)selectTheEmployment:(id)sender;

@end
@interface EmploymentListTableViewController : RefreshEnableTableViewController<EmploymentWebserviceDelegate,SubFunctionProtocol>
{
    NSString* type_;
    UIImageView* coverImageView_;
}
@property (nonatomic,assign)id<EmploymentListTableViewControllerDelegate> delegate;
- (void)setEmploymentTableType:(NSString* )sender;
- (NSString* )getType;
@end
