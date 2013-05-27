//
//  ModifyPasswordViewController.h
//  SchoolNews
//
//  Created by Jerry on 2月17星期日.
//
//

#import <UIKit/UIKit.h>

@interface ModifyPasswordViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UINavigationBar* navigationBar_;
    IBOutlet UITextField* firstInputTextField_;
    IBOutlet UITextField* secondInputTextField_;
}
+ (ModifyPasswordViewController* )singleton;
- (IBAction)modifyThePassword:(id)sender;
- (IBAction)endEdit:(id)sender;
@end
