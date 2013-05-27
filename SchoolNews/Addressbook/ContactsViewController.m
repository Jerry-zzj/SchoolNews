//
//  ContactsViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import "ContactsViewController.h"

#import "ContactInformationViewController.h"
#import "DataBaseOperating.h"
#import "UIImage+Scale.h"
#import "LoginViewController.h"
#import "UsersInformation.h"
#import "SVProgressHUD.h"
#import "PublicDefines.h"
#import "UIImage+Scale.h"
@interface ContactsViewController ()

- (void)loadContactsTableViewController;
- (void)loadGroupViewController;
- (void)loadTheRightBarbutton;
- (void)updateTheContacts;
- (void)addAllContactsToLocal;
- (void)finishAddOneContact:(NSNotification* )sender;
- (void)finishAddOneDepartment:(NSNotification* )sender;
- (void)showProgressHud:(NSDictionary* )sender;
- (void)addAllContactsInSubThread;
- (void)hideTheGroupView;
//- (void)dismissTheHudWithNotification:(NSNotification* )sender;

- (void)loadTheHaveNoRightImageView;
@end

@implementation ContactsViewController
{
    float finishedAddContacts_;
    float allToAddContacts_;
    UIImageView* haveNoRightImageView_;
}
ContactsViewController* g_ContactsViewController;
+ (ContactsViewController* )singleton
{
    if (g_ContactsViewController == nil) {
        g_ContactsViewController = [[ContactsViewController alloc] init];
    }
    return g_ContactsViewController;
}

- (id)init
{
    self = [super init];
    if (self) {
        UIImage* tempImage = [UIImage imageNamed:@"通讯录.png"];
        self.iconImage = tempImage;
        //UIImage* tabBarImage = [tempImage scaleToSize:CGSizeMake(20, 20)];
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"通讯录"
                                                                 image:tempImage
                                                                   tag:0];
        self.tabBarItem = tabBarItem;
        
        loadAllContactsToLocalIng_ = NO;
        
        /*[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissTheHudWithNotification:)
                                                     name:@"finishAddAllContactsIntoLocal"
                                                   object:nil];*/
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(finishAddOneContact:)
                                                     name:@"FinishOneContactAdded"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(finishAddOneDepartment:)
                                                     name:@"FinishAddOneDepartment"
                                                   object:nil];
        
    }
return self;
}

- (void)viewDidLoad
{
    mode_ = Normal;
    [super viewDidLoad];
    [self loadContactsTableViewController];
    [self loadGroupViewController];
    [self loadTheRightBarbutton];
    groupViewShow_ = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//初始化有子功能菜单的界面
- (void)initialSubFunctions
{
    
}

//初始化正常模式的界面
- (void)loadNormalMode
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self showTabBar];
    NSArray* subviews = [self.view subviews];
    if (![UsersInformation singleton].alreadyLogin) {
        [self.navigationController setNavigationBarHidden:YES];
        if (![subviews containsObject:[LoginViewController singleton].view]) {
            [LoginViewController singleton].delegate = self;
            [[LoginViewController singleton].view setFrame:self.view.frame];
            [self.view addSubview:[LoginViewController singleton].view];
            [LoginViewController singleton].pressent = NO;
        }
    }
    else
    {
        //判断用户是否有权限
        if ([[UsersInformation singleton].userRightFunctionSet containsObject:self.title]) {
            if ([self.view.subviews containsObject:haveNoRightImageView_]) {
                [haveNoRightImageView_ removeFromSuperview];
                haveNoRightImageView_ = nil;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactsLogin"
                                                                object:nil];
            [self.navigationController setNavigationBarHidden:NO];
        }
        else
        {
            [self loadTheHaveNoRightImageView];
            [self.navigationController setNavigationBarHidden:YES];
            [self.view addSubview:haveNoRightImageView_];
        }
            
        /*[[NSNotificationCenter defaultCenter] postNotificationName:@"ContactsLogin"
                                                            object:nil];
        [self.navigationController setNavigationBarHidden:NO];*/
    }
    if (loadAllContactsToLocalIng_) {
        [SVProgressHUD showWithStatus:@"下载中..."];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (loadAllContactsToLocalIng_) {
        [SVProgressHUD dismiss];
    }
}

#pragma mark Login delegate
- (void)userLoginSuccess
{
    [UsersInformation singleton].alreadyLogin = YES;
    [[LoginViewController singleton].view removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO];
    if ([[UsersInformation singleton].userRightFunctionSet containsObject:self.title]) {
        if ([self.view.subviews containsObject:haveNoRightImageView_]) {
            [haveNoRightImageView_ removeFromSuperview];
            haveNoRightImageView_ = nil;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactsLogin"
                                                            object:nil];
        [self.navigationController setNavigationBarHidden:NO];
    }
    else
    {
        [self loadTheHaveNoRightImageView];
        [self.navigationController setNavigationBarHidden:YES];
        [self.view addSubview:haveNoRightImageView_];
    }

    /*[UsersInformation singleton].alreadyLogin = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactsLogin"
                                                        object:nil];
    [[LoginViewController singleton].view removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO];*/
}

#pragma mark contacts tableview
//show the group
- (void)moveToLeft
{
    /*float groupViewWidth = groupViewController_.view.frame.size.width;
    float groupViewHeight = groupViewController_.view.frame.size.height;
    float tableViewWidth = self.tableView.frame.size.width;
    [UIView beginAnimations:@"ShowGroupView" context:nil];
    [UIView setAnimationDuration:0.5];
    [groupViewController_.view setFrame:CGRectMake(tableViewWidth - groupViewWidth, 0, groupViewWidth, groupViewHeight)];
    [self.tableView setFrame:CGRectMake(0, 0, tableViewWidth, self.tableView.frame.size.height)];
    [UIView commitAnimations];
    groupViewShow_ = YES;*/
    if (!groupViewShow_) {
        [groupViewController_.view setHidden:NO];
        float groupViewWidth = groupViewController_.view.frame.size.width;
        float groupViewHeight = groupViewController_.view.frame.size.height;
        float tableViewWidth = contactsTableViewController_.tableView.frame.size.width;
        [UIView beginAnimations:@"ShowGroupView" context:nil];
        [UIView setAnimationDuration:0.5];
        [groupViewController_.view setFrame:CGRectMake(tableViewWidth - groupViewWidth, 0, groupViewWidth, groupViewHeight)];
        [contactsTableViewController_.tableView setFrame:CGRectMake(0, 0, tableViewWidth - groupViewWidth, contactsTableViewController_.tableView.frame.size.height)];
        [contactsTableViewController_.contactSearchBar setShowsCancelButton:NO];
        [UIView commitAnimations];
        groupViewShow_ = YES;
    }
}

//hidden the group
- (void)moveToRight
{
    if (groupViewShow_) {
        float groupViewWidth = groupViewController_.view.frame.size.width;
        float groupViewHeight = groupViewController_.view.frame.size.height;
        [UIView beginAnimations:@"hideGroupView" context:nil];
        [UIView setAnimationDuration:0.5];
        [groupViewController_.view setFrame:CGRectMake(self.view.bounds.size.width, 0, groupViewWidth, groupViewHeight)];
        [contactsTableViewController_.tableView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, contactsTableViewController_.tableView.frame.size.height)];
        [contactsTableViewController_.contactSearchBar setShowsCancelButton:YES];
        [UIView commitAnimations];
        groupViewShow_ = NO;
    }
    [self performSelector:@selector(hideTheGroupView) withObject:nil afterDelay:0.5];
    //[groupViewController_.view setHidden:YES];
}

- (void)selectThePerson:(NSDictionary *)person
{
    ContactInformationViewController* informationViewController = [[ContactInformationViewController alloc] initWithContact:person];
    [self.navigationController pushViewController:informationViewController animated:YES];
}

#pragma mark group delegate
- (void)selectTheGroup:(NSString *)group
{
    if ([group isEqualToString:@"所有人"]) {
        NSDictionary* contacts = contactsTableViewController_.allContacts;
        contactsTableViewController_.showDataDictionary = contacts;
    }
    else
    {
        NSDictionary* contacts = contactsTableViewController_.allContacts;
        NSArray* toShowContacts = [contacts objectForKey:group];
        NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:toShowContacts,group, nil];
        contactsTableViewController_.showDataDictionary = dictionary;
    }
    
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [NSThread detachNewThreadSelector:@selector(addAllContactsInSubThread) toTarget:self withObject:nil];
        loadAllContactsToLocalIng_ = YES;
    }
}

#pragma mark Template Method

#pragma mark private
- (void)loadContactsTableViewController
{
    contactsTableViewController_ = [ContactsTableViewController singleton];
    [self addChildViewController:contactsTableViewController_];
    contactsTableViewController_.touchMoveDelegate = self;
    contactsTableViewController_.seletPersonDelegate = self;
    //float width = contactsTableViewController_.tableView.frame.size.width;
    //float height = contactsTableViewController_.tableView.frame.size.height;
    [contactsTableViewController_.tableView setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
    [contactsTableViewController_.tableView setBackgroundView:nil];
    [contactsTableViewController_.tableView setBackgroundColor:[UIColor colorWithRed:230.0 / 255.0
                                                                               green:244.0 / 255.0
                                                                                blue:253 / 255.0
                                                                               alpha:1]];
    [self.view addSubview:contactsTableViewController_.tableView];
   //NSLog(@"%g",contactsTableViewController_.tableView.frame.origin.y);
}

- (void)loadGroupViewController
{
    groupViewController_ = [GroupViewController singleton];
    [self addChildViewController:groupViewController_];
    groupViewController_.delegate = self;
    float x = contactsTableViewController_.view.frame.size.width;
    float y = 0;
    float width = groupViewController_.view.frame.size.width;
    float height = groupViewController_.view.frame.size.height;
    [groupViewController_.view setFrame:CGRectMake(x, y, width, height)];
    [self.view addSubview:groupViewController_.view];
    [self hideTheGroupView];
}

- (void)loadTheRightBarbutton
{
    UIButton* updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* updateImage = [UIImage imageNamed:@"刷新.png"];
    [updateButton setImage:updateImage forState:UIControlStateNormal];
    [updateButton addTarget:self
                     action:@selector(updateTheContacts)
           forControlEvents:UIControlEventTouchUpInside];
    [updateButton setFrame:CGRectMake(0, 2, 40, 40)];
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:updateButton];
    self.navigationItem.rightBarButtonItem = leftBarButton;
    
    /*UIButton* addAllContactsToLocal = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* addAllContactImage = [UIImage imageNamed:@"下载.png"];
    [addAllContactsToLocal setImage:addAllContactImage forState:UIControlStateNormal];
    [addAllContactsToLocal addTarget:self
                              action:@selector(addAllContactsToLocal)
                    forControlEvents:UIControlEventTouchUpInside];
    [addAllContactsToLocal setFrame:CGRectMake(0, 2, 40, 40)];
    UIBarButtonItem* rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:addAllContactsToLocal];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;*/
}

- (void)updateTheContacts
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTheContacts"
                                                        object:nil];
}

- (void)addAllContactsToLocal
{
    //当用户选择的是所有人的时候不予以用户下载的权力,仅当用户下载的为组别的时候才可以下载
    if ([contactsTableViewController_ numberOfSectionsInTableView:contactsTableViewController_.tableView] > 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                        message:@"您当前下载的联系人为所有，请选择你需要的相关组别进行下载！"
                                                       delegate:nil
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    //加个警告，提醒用户是否真的下载
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                    message:@"您确定要将联系人加载到本地吗"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
    //
    //[SVProgressHUD showWithStatus:@"下载中..." maskType:SVProgressHUDMaskTypeGradient];
    /*[NSThread detachNewThreadSelector:@selector(addAllContactsInSubThread) toTarget:self withObject:nil];
    loadAllContactsToLocalIng_ = YES;*/
}

- (void)finishAddOneContact:(NSNotification* )sender
{
    NSDictionary* information = [sender object];
    [self performSelectorOnMainThread:@selector(showProgressHud:) withObject:information waitUntilDone:NO];
}

- (void)finishAddOneDepartment:(NSNotification* )sender
{
    
    loadAllContactsToLocalIng_ = NO;
    allToAddContacts_ = 0;
    finishedAddContacts_ = 0;
    NSNumber* temp = [sender object];
    BOOL success = [temp boolValue];
    //[SVProgressHUD dismiss];
    if (success) {
        [SVProgressHUD showSuccessWithStatus:@"下载成功"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"下载失败"];
    }
    [SVProgressHUD dismiss];
}

- (void)showProgressHud:(NSDictionary* )sender
{
    NSNumber* allContact = [sender objectForKey:@"ToAddContacts"];
    NSString* department = [sender objectForKey:@"Department"];
    allToAddContacts_ = [allContact floatValue];
    finishedAddContacts_ ++;
    if (finishedAddContacts_ > allToAddContacts_) {
        finishedAddContacts_ = allToAddContacts_;
    }
    CGFloat progress = finishedAddContacts_ / allToAddContacts_;
    //[SVProgressHUD showWithStatus:@"下载中..." maskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showProgress:progress
                         status:department
                       maskType:SVProgressHUDMaskTypeGradient];
}

- (void)addAllContactsInSubThread
{
    [contactsTableViewController_ addContactsToLocalAddressBook];
}

- (void)hideTheGroupView
{
    [groupViewController_.view setHidden:YES];
}

/*- (void)dismissTheHudWithNotification:(NSNotification* )sender
{
    loadAllContactsToLocalIng_ = NO;
    allToAddContacts_ = 0;
    finishedAddContacts_ = 0;
    NSNumber* temp = [sender object];
    BOOL success = [temp boolValue];
    [SVProgressHUD dismiss];
    if (success) {
        [SVProgressHUD showSuccessWithStatus:@"下载成功"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"下载失败"];
    }
    [SVProgressHUD dismiss];
}*/

- (void)loadTheHaveNoRightImageView
{
    if (haveNoRightImageView_ == nil) {
        haveNoRightImageView_ = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [haveNoRightImageView_ setImage:[UIImage imageNamed:@"没有访问权限.png"]];
    }
}
@end
