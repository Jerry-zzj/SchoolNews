//
//  UsersInformationViewController.m
//  SchoolNews
//
//  Created by Jerry on 1月6星期日.
//
//

#import "UsersInformationViewController.h"
#import "UsersInformation.h"
#import "ModifyPasswordViewController.h"
#import "MyMD5.h"
#import "PublicDefines.h"

@interface UsersInformationViewController ()

- (void)loadBasicInformation;
- (void)initNavigationBar;
- (void)initTheUI;
- (void)returnToSettingView;
- (void)presentInputAlertViewWithTitle:(NSString* )sender;

@end

@implementation UsersInformationViewController
{
    NSMutableString* password_;
}
UsersInformationViewController* g_UsersInformationViewController;
+ (UsersInformationViewController* )singleton
{
    if (g_UsersInformationViewController == nil) {
        g_UsersInformationViewController = [[UsersInformationViewController alloc] init];
    }
    return g_UsersInformationViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UsersInformation singleton] addObserver:self
                                       forKeyPath:@"accountName"
                                          options:0
                                          context:nil];
        password_ = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    [self initTheUI];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginout:(id)sender
{
    [UsersInformation singleton].accountName = nil;
    [UsersInformation singleton].accountNumber = nil;
    [UsersInformation singleton].password = nil;
    [UsersInformation singleton].alreadyLogin = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_OUT
                                                        object:nil];
}

- (IBAction)modifyPassWord:(id)sender
{
    [self presentInputAlertViewWithTitle:@"密码修改"];
}

- (void)viewWillAppear:(BOOL)animated
{
    nameLabel_.text = [UsersInformation singleton].accountName;
    accountLabel_.text = [UsersInformation singleton].accountNumber;
}
#pragma mark textField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [password_ replaceCharactersInRange:range withString:string];
    NSMutableString* text = [NSMutableString string];
    [text appendString:textField.text];
    NSString* textString = string;
    if ([string length] > 0) {
        textString = @"*";
    }
    [text replaceCharactersInRange:range withString:textString];
    textField.text = text;
    return NO;
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"%@",password_);
        NSLog(@"%@",[UsersInformation singleton].password);
        NSString* encodedPassword = [MyMD5 md5:password_ ];
        if ([encodedPassword isEqualToString:[UsersInformation singleton].password]) {
            ModifyPasswordViewController* modifyPasswordViewController = [ModifyPasswordViewController singleton];
            [self presentViewController:modifyPasswordViewController animated:YES completion:nil];
            password_ = [NSMutableString stringWithString:@""];
        }
        else
        {
            [self presentInputAlertViewWithTitle:@"密码错误!"];
            password_ = [NSMutableString stringWithString:@""];
        }
    }
}


#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"accountName"]) {
        [self loadBasicInformation];
    }
}

#pragma mark private
- (void)loadBasicInformation
{
    nameLabel_.text = [UsersInformation singleton].accountName;
}

- (void)initNavigationBar
{
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"用户信息"];
    UIBarButtonItem* returnBarButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(returnToSettingView)];
    navigationItem.leftBarButtonItem = returnBarButton;
    [navigationBar_ pushNavigationItem:navigationItem animated:YES];
}

- (void)initTheUI
{
    UIImageView* background = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    [background setImage:[UIImage imageNamed:@"用户信息背景.png"]];
    [self.view insertSubview:background atIndex:0];
}

- (void)returnToSettingView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentInputAlertViewWithTitle:(NSString* )sender
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:sender
                                                       message:@"输入原密码\n\n"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"修改", nil];
    NSLog(@"%@",NSStringFromCGRect(alertView.frame));
    UITextField* passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(27, 65, 230, 25)];
    [passwordTextField setBackgroundColor:[UIColor whiteColor]];
    [passwordTextField setPlaceholder:@"密码"];
    [passwordTextField setDelegate:self];
    [alertView addSubview:passwordTextField];
    
    [alertView setTransform:CGAffineTransformMakeTranslation(0.0, -100.0)];
    NSLog(@"%@",NSStringFromCGRect(alertView.frame));
    
    [alertView show];

}

@end
