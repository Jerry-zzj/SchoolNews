//
//  LoginViewController.h
//  SchoolNews
//
//  Created by shuangchi on 12月1星期六.
//
//

#import <UIKit/UIKit.h>
@protocol LoginViewControllerDelegate<NSObject>

- (void)userLoginSuccess;

@optional
- (void)userLoginFaild;

@end
@interface LoginViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    UITextField *accountNameTextField_;
    UITextField *passwordTextField_;
    
    UITableView* tableView_;
    
    BOOL dismissLoginView_;
    
    NSString* accountNumber_;
    //NSMutableString* passWord_;
    UIImageView* backgroundImageView_;
}
@property (nonatomic,assign)BOOL pressent;
@property (nonatomic,assign)id<LoginViewControllerDelegate> delegate;
+ (LoginViewController* )singleton;

- (IBAction)login:(id)sender;
- (IBAction)cancelLogin:(id)sender;
- (IBAction)touchDownInView:(id)sender;
@end
