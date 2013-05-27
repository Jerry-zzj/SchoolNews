//
//  EmployMentServiceViewController.h
//  SchoolNews
//
//  Created by Jerry on 4月1星期一.
//
//

#import "FunctionViewController.h"
#import "EmploymentListTableViewController.h"
#import "LoginViewController.h"
#import "EmploymentCollectionViewController.h"
#import "SubtitleViewController.h"
@interface EmployMentServiceViewController : FunctionViewController<EmploymentListTableViewControllerDelegate,LoginViewControllerDelegate,SubtitleViewControllerDelegate,EmploymentCollectionViewControllerDelegate>
{
    EmploymentCollectionViewController* employmentCollectionViewController_;
    SubtitleViewController* subtitleViewController_;
    //SubFunctionViewController* subFunctionViewController_;

}
+ (EmployMentServiceViewController* )singleton;
- (void)setSubFunctionMode:(BOOL )sender;
@end
