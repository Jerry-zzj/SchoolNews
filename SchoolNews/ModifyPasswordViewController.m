//
//  ModifyPasswordViewController.m
//  SchoolNews
//
//  Created by Jerry on 2月17星期日.
//
//

#import "ModifyPasswordViewController.h"
#import "SVProgressHUD.h"
#import "WebService.h"
#import "WebServiceFactory.h"
#import "MyMD5.h"
#import "PublicDefines.h"
#import "UsersInformation.h"

@interface ModifyPasswordViewController ()

- (void)initNavigationBar;
- (void)initTheUI;
- (void)returnToUserInformationView;
- (void)finishModifyPassword:(NSNotification* )sender;

@end

@implementation ModifyPasswordViewController
{
    NSMutableString* firstPassword_;
    NSMutableString* secondPassword_;
}
ModifyPasswordViewController* g_ModifyPasswordViewController;
+ (ModifyPasswordViewController* )singleton
{
    if (g_ModifyPasswordViewController == nil) {
        g_ModifyPasswordViewController = [[ModifyPasswordViewController alloc] init];
    }
    return g_ModifyPasswordViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        firstPassword_ = [[NSMutableString alloc] init];
        secondPassword_ = [[NSMutableString alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(finishModifyPassword:)
                                                     name:@"finishdModifyPassword"
                                                   object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    [self initTheUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)modifyThePassword:(id)sender
{
    if (![firstPassword_ isEqualToString:secondPassword_]) {
        //两次输入法人密码不同，跳出提示框
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"警告"
                                                            message:@"两次输入的密码不相同"
                                                           delegate:self
                                                  cancelButtonTitle:@"重新输入"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        //两次输入的密码相同，开始修改密码
        [SVProgressHUD showWithStatus:@"处理中" maskType:SVProgressHUDMaskTypeGradient];
        WebService* verficationWebService = [[WebServiceFactory singleton] produceTheWebService:MODIFY_PASSWORD_WEBSERVICE];
        NSString* account = [UsersInformation singleton].accountNumber;
        NSString* oldPasswordMD5 = [UsersInformation singleton].password;
        NSString* newPassWordMD5 = [MyMD5 md5:secondPassword_];
        NSString* urlString = [NSString stringWithFormat:@"%@/axis2/services/VerificationService/modifyAccountPassword?account=%@&oldPassword=%@&newPassword=%@",WEBSERVICE_DOMAIN,account,oldPasswordMD5,newPassWordMD5];
        [verficationWebService setURLWithString:urlString];
        [verficationWebService getWebServiceData];
    }
}

- (IBAction)endEdit:(id)sender
{
    [firstInputTextField_ resignFirstResponder];
    [secondInputTextField_ resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [firstInputTextField_ setText:nil];
    [secondInputTextField_ setText:nil];
    firstPassword_ = [NSMutableString stringWithString:@""];
    secondPassword_ = [NSMutableString stringWithString:@""];
}

#pragma mark TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:firstInputTextField_]) {
        [firstPassword_ replaceCharactersInRange:range withString:string];
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
    else if ([textField isEqual:secondInputTextField_])
    {
        [secondPassword_ replaceCharactersInRange:range withString:string];
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
    return YES;
}

#pragma mark AlertView Delegate
- (void)alertViewCancel:(UIAlertView *)alertView
{
    secondInputTextField_.text = nil;
}

#pragma mark private method
- (void)initNavigationBar
{
    UINavigationItem* navigationItem = [[UINavigationItem alloc]initWithTitle:@"修改密码"];
    UIBarButtonItem* retunBarButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(returnToUserInformationView)];
    navigationItem.leftBarButtonItem = retunBarButton;
    [navigationBar_ pushNavigationItem:navigationItem animated:YES];
}

- (void)initTheUI
{
    UIImageView* background = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    [background setImage:[UIImage imageNamed:@"用户信息背景.png"]];
    [self.view insertSubview:background atIndex:0];
}

- (void)returnToUserInformationView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishModifyPassword:(NSNotification* )sender
{
    NSString* state = [sender object];
    if ([state isEqualToString:@"SUCCESS"]) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [UsersInformation singleton].password = [MyMD5 md5:secondPassword_];
        secondPassword_ = [NSMutableString stringWithString:@""];
        firstPassword_ = [NSMutableString stringWithString:@""];
        
    }
    else if ([state isEqualToString:@"FAILURE"])
    {
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
