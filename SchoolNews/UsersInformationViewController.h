//
//  UsersInformationViewController.h
//  SchoolNews
//
//  Created by Jerry on 1月6星期日.
//
//

#import <UIKit/UIKit.h>

@interface UsersInformationViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
{
    IBOutlet UILabel* nameLabel_;
    IBOutlet UILabel* accountLabel_;
    IBOutlet UINavigationBar* navigationBar_;
}
+ (UsersInformationViewController* )singleton;
- (IBAction)loginout:(id)sender;
- (IBAction)modifyPassWord:(id)sender;
@end
