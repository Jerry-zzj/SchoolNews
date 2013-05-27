//
//  UserSettingViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import "UserSettingViewController.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "UsersInformation.h"
#import "UsersInformationViewController.h"
#import "SubtitleSettingViewController.h"
#import "PullView.h"
@interface UserSettingViewController ()

- (void)loadTheSettingTableView;
- (void)loadNavigationBar;
- (void)dismissThisSettingView;
- (void)clearTheBuffer;
@end

@implementation UserSettingViewController
UserSettingViewController* g_UserSettingViewController;
+ (UserSettingViewController* )singleton
{
    if (g_UserSettingViewController == nil) {
        g_UserSettingViewController = [[UserSettingViewController alloc] init];
    }
    return g_UserSettingViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        /*[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissThisSettingView)
                                                     name:@"FinishedHandleTheNotification"
                                                   object:nil];*/
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavigationBar];
    [self loadTheSettingTableView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark userSettingTableView Delegate
- (void)selectTheIdentifier:(NSString *)sender
{
    if ([sender isEqualToString:@"用户名"]) {
        if ([UsersInformation singleton].accountName == nil) {
            [LoginViewController singleton].delegate = self;
            [self presentViewController:[LoginViewController singleton] animated:YES completion:nil];
            [LoginViewController singleton].pressent = YES;
        }
        else
        {
            [self presentViewController:[UsersInformationViewController singleton]
                               animated:YES
                             completion:nil];
        }
    }
    else if ([sender isEqualToString:@"清理缓存"])
    {
        [self clearTheBuffer];
    }
    else if ([sender isEqualToString:@"新闻栏目"])
    {
        [self presentViewController:[SubtitleSettingViewController singleton] animated:YES completion:nil];
    }
    else if ([sender isEqualToString:@"版本"])
    {
        
    }
    else if ([sender isEqualToString:@"意见反馈"])
    {
        
    }
    else if ([sender isEqualToString:@"消息中心"])
    {
        
    }
}

#pragma mark login delegate
- (void)userLoginSuccess
{
    [[LoginViewController singleton] dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark private
- (void)loadNavigationBar
{
    UINavigationBar* navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [self.view addSubview:navigationBar];
    
    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:@"设置"];
    UIBarButtonItem* rightBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(dismissThisSettingView)];
    item.rightBarButtonItem = rightBarbutton;
    [navigationBar pushNavigationItem:item animated:NO];
}

- (void)loadTheSettingTableView
{
    userSettingTableViewController_ = [UserSettingTableViewController singleton];
    userSettingTableViewController_.delegate = self;
    [self addChildViewController:userSettingTableViewController_];
    [userSettingTableViewController_.tableView setFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height - 44)];
    [self.view addSubview:userSettingTableViewController_.tableView];
}

- (void)dismissThisSettingView
{
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([[PullView singleton] moreFunctionShow]) {
        [[PullView singleton] pullViewToShow:NO];
    }
    else
    {
        [[PullView singleton] pullViewToHidden:NO];
    }
}

- (void)clearTheBuffer
{
    NSArray* paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [paths objectAtIndex:0];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* subPath = [fileManager subpathsOfDirectoryAtPath:documentPath error:nil];
    BOOL deleteSuccess = YES;
    for (NSString* fileName in subPath) {
        NSLog(@"%@",fileName);
        NSString* filePath = [documentPath stringByAppendingPathComponent:fileName];
        //NSLog(@"%@",filePath);
        if(![fileManager removeItemAtPath:filePath error:NULL])
        {
            deleteSuccess = NO;
        }
    }
    if (deleteSuccess) {
        [SVProgressHUD showSuccessWithStatus:@"清理完成"];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"清理失败"];
    }
}
@end
