//
//  LoginViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月1星期六.
//
//

#import "LoginViewController.h"
#import "UsersInformation.h"
#import "VerificationWebService.h"
#import "WebServiceFactory.h"
#import "SVProgressHUD.h"
#import "MyMD5.h"
#import "PublicDefines.h"
#import "LoginCell.h"
#define TABLE_FRAME                                 CGRectMake(36, 243, 246, 182)
#define TEXTFIELD_FRAME                             CGRectMake(40, 0, 200, 44)

@interface LoginViewController ()

//- (void)loadTheNavigationBarButton;
- (void)loadBackgroundImageView;
- (void)loadTableView;
- (void)loadTextField;
- (void)loginWithWebservice:(NSNotification* )notification;
- (void)cancelLogin;

@end

@implementation LoginViewController
{
    BOOL viewUp_;
}
@synthesize delegate;
LoginViewController* g_LoginViewController;
+ (LoginViewController* )singleton
{
    if (g_LoginViewController == nil) {
        g_LoginViewController = [[LoginViewController alloc] init];
    }
    return g_LoginViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dismissLoginView_ = NO;
        //passWord_ = [NSMutableString string];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginWithWebservice:)
                                                     name:LOGIN_FINISHED
                                                   object:nil];
        [self addObserver:self
               forKeyPath:@"dismissLoginView_"
                  options:0
                  context:nil];
        viewUp_ = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadBackgroundImageView];
    [self loadTextField];
    [self loadTableView];
    //[self loadTheNavigationBarButton];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    //navigationBar_ = nil;
    accountNameTextField_ = nil;
    passwordTextField_ = nil;
    [super viewDidUnload];
}


- (IBAction)login:(id)sender {
    [self touchDownInView:self.view];
    NSString* accountNumber = accountNameTextField_.text;
    NSString* passwordNumber = passwordTextField_.text;
    if (accountNumber == nil) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                        message:@"账户名不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([passwordNumber length] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                        message:@"密码不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        accountNumber_ = [accountNumber copy];
        [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeGradient];
        WebService* verficationWebService = [[WebServiceFactory singleton] produceTheWebService:VERFICATION_WEBSERVICE];
        //设置登录验证URL
        NSString* passWordMD5 = [MyMD5 md5:passwordNumber];
        NSString* urlString = [NSString stringWithFormat:@"%@/axis2/services/VerificationService/verifyAccountNameInVersion11?accountName=%@&password=%@&deviceToken=%@&deviceType=%@",WEBSERVICE_DOMAIN,accountNumber_,passWordMD5,@"fasdfad",@"IOS"];
        [verficationWebService setURLWithString:urlString];
        [verficationWebService getWebServiceData];
    }
}

- (void)setPressent:(BOOL)pressentSender
{
    _pressent = pressentSender;
    if (_pressent) {
        //cancelButton_.hidden = NO;
    }
    else
    {
        //cancelButton_.hidden = YES;
    }
}

- (IBAction)cancelLogin:(id)sender
{
    if (self.pressent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)touchDownInView:(id)sender
{
    viewUp_ = NO;
    [accountNameTextField_ resignFirstResponder];
    [passwordTextField_ resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [tableView_ reloadData];
}

#pragma mark UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    viewUp_ = YES;
    float toMoveDistance = SCREEN_HEIGHT == 548 ? 200 : 160;
    CGRect tableFrame = tableView_.frame;
    
    if (CGRectEqualToRect(tableFrame, TABLE_FRAME) > 0) {
        
        [UIView beginAnimations:@"move Login TextFiled" context:nil];
        [UIView setAnimationDuration:0.2];
        CGRect rect = TABLE_FRAME;
        rect.origin.y -= toMoveDistance;
        CGRect backgroundImageRect = backgroundImageView_.frame;
        backgroundImageRect.origin.y -= toMoveDistance;
        [tableView_ setFrame:rect];
        [backgroundImageView_ setFrame:backgroundImageRect];
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect tableFrame = tableView_.frame;
    if (CGRectEqualToRect(tableFrame, TABLE_FRAME) == 0 && !viewUp_) {
        [UIView beginAnimations:@"move Login TextFiled" context:nil];
        [UIView setAnimationDuration:0.2];
        [tableView_ setFrame:TABLE_FRAME];
        [backgroundImageView_ setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
        [UIView commitAnimations];
    }
}

/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:passwordTextField_]) {
        [passWord_ replaceCharactersInRange:range withString:string];
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
}*/

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"dismissLoginView_"]) {
        if (dismissLoginView_) {
            [self performSelectorOnMainThread:@selector(dismissSelf) withObject:nil waitUntilDone:NO];
        }
    }
}

#pragma mark tableView DataSource
- (int )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (float )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"LoginCellIdentifier";
    LoginCell* cell = (LoginCell* )[tableView_ dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    int row = [indexPath row];
    if (row == 0) {
        cell.textLabel.text = @"账号";
        cell.textField = accountNameTextField_;
    }
    else if (row == 1)
    {
        cell.textLabel.text = @"密码";
        cell.textField = passwordTextField_;
    }
    return cell;
}

- (UIView* )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.pressent) {
        UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setImage:[UIImage imageNamed:@"取消按钮蓝.png"]
                      forState:UIControlStateNormal];
        [cancelButton setFrame:CGRectMake(0, 0, 100, 44)];
        [cancelButton addTarget:self
                         action:@selector(cancelLogin:)
               forControlEvents:UIControlEventTouchUpInside];
        UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setImage:[UIImage imageNamed:@"登录按钮蓝.png"]
                     forState:UIControlStateNormal];
        [loginButton setFrame:CGRectMake(145, 0, 100, 44)];
        [loginButton addTarget:self
                        action:@selector(login:)
              forControlEvents:UIControlEventTouchUpInside];
        
        UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 264, 44)];
        [footView addSubview:cancelButton];
        [footView addSubview:loginButton];
        return footView;
    }
    else
    {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 264, 44)];
        UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setImage:[UIImage imageNamed:@"登录按钮蓝.png"]
                     forState:UIControlStateNormal];
        [loginButton setFrame:CGRectMake(70, 0, 104, 44)];
        [loginButton addTarget:self
                        action:@selector(login:)
              forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:loginButton];
        return view;
    }
}

#pragma mark private
/*- (void)loadTheNavigationBarButton
{
    UINavigationItem* items = [[UINavigationItem alloc] initWithTitle:@"用户登录"];
    UIBarButtonItem* rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                       style:UIBarButtonSystemItemCancel
                                                                      target:self
                                                                      action:@selector(cancelLogin)];
    items.rightBarButtonItem = rightBarButton;
    items.leftBarButtonItem = nil;
    [navigationBar_ setItems:[NSArray arrayWithObject:items]];
}*/

- (void)loadBackgroundImageView
{
    backgroundImageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    if (SCREEN_HEIGHT == 548) {
        [backgroundImageView_ setImage:[UIImage imageNamed:@"登录界面蓝2.png"]];
    }
    [backgroundImageView_ setImage:[UIImage imageNamed:@"登录界面蓝.png"]];
    backgroundImageView_.userInteractionEnabled = NO;
    [self.view addSubview:backgroundImageView_];
}

- (void)loadTableView
{
    tableView_ = [[UITableView alloc] initWithFrame:TABLE_FRAME
                                              style:UITableViewStyleGrouped];
    //[tableView_ setBackgroundColor:[UIColor clearColor]];
    [tableView_ setBackgroundView:nil];
    tableView_.dataSource = self;
    tableView_.delegate = self;
    [self.view addSubview:tableView_];
}

- (void)loadTextField
{
    accountNameTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(65, 11, 170, 22)];
    [accountNameTextField_ setBorderStyle:UITextBorderStyleNone];
    accountNameTextField_.placeholder = @"点击输入账号";
    accountNameTextField_.delegate = self;
    //accountNameTextField_.textAlignment = NSTextAlignmentCenter;
    accountNameTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    passwordTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(65, 11, 170, 22)];
    [passwordTextField_ setBorderStyle:UITextBorderStyleNone];
    passwordTextField_.delegate = self;
    [passwordTextField_ setPlaceholder:@"点击输入密码"];
    passwordTextField_.secureTextEntry = YES;
    //passwordTextField_.textAlignment = NSTextAlignmentCenter;
    passwordTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)cancelLogin
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCancelLogin" object:nil];
}

- (void)loginWithWebservice:(NSNotification* )notification
{
    NSDictionary* result = [notification object];
    if ([result count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"密码或者账号错误"];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        //[self.delegate userLoginSuccess];
        [UsersInformation singleton].accountNumber = accountNumber_;
        NSString* password = passwordTextField_.text;
        NSString* md5Password = [MyMD5 md5:password];
        [UsersInformation singleton].password = md5Password;
        
        //姓名
        NSString* name = [result objectForKey:@"姓名"];
        [UsersInformation singleton].accountName = name;
        
        //用户类型
        NSNumber* userType = [result objectForKey:@"用户类型"];
        [UsersInformation singleton].userType = [userType intValue];
        
        //注册情况
        NSNumber* registerState = [result objectForKey:@"秘钥注册情况"];
        [UsersInformation singleton].keyRegistered = [registerState boolValue];
        
        [self.delegate userLoginSuccess];
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_IN
                                                            object:nil];
        //向远程服务器注册DeviceToken
        //[[RemoteNotificationHandleCenter singleton] handInTheDeviceTokenToTheServerWithAccount];
    }
}
@end
