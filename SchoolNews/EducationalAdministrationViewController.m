//
//  EducationalAdministrationViewController.m
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import "EducationalAdministrationViewController.h"
//#import "LoginViewController.h"
#import "UsersInformation.h"
#import "SchoolTimeTableViewController.h"
#import "PublicDefines.h"
#import "AboutTime.h"

@interface EducationalAdministrationViewController ()


@end

@implementation EducationalAdministrationViewController
{
}
EducationalAdministrationViewController* g_EducationalAdministrationViewController;
+ (id)singleton
{
    if (g_EducationalAdministrationViewController == nil) {
        g_EducationalAdministrationViewController = [[EducationalAdministrationViewController alloc] init];
    }
    return g_EducationalAdministrationViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* tempImage = [UIImage imageNamed:@"教务服务.png"];
        self.iconImage = tempImage;
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"教务服务"
                                                                 image:tempImage
                                                                   tag:0];
        self.tabBarItem = tabBarItem;

    }
    return self;
}

- (void)viewDidLoad
{
    mode_ = SubFunction;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([UsersInformation singleton].alreadyLogin) {
        [self hideTabBar];
    }
    else
    {
        [self showTabBar];
    }
    NSArray* subviews = [self.view subviews];
    if (![UsersInformation singleton].alreadyLogin ) {
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
        [self.navigationController setNavigationBarHidden:NO];
        [super viewWillAppear:animated];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化有子功能菜单的界面
- (void)initialSubFunctions
{
    SchoolTimeTableViewController* studentSchoolTimeTableViewController = [[SchoolTimeTableViewController alloc] init];
    [studentSchoolTimeTableViewController.view setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    [self addChildViewController:studentSchoolTimeTableViewController];
    [self.subFunction addObject:studentSchoolTimeTableViewController];
    [self.view insertSubview:studentSchoolTimeTableViewController.view atIndex:0];
}

//初始化正常模式的界面
- (void)loadNormalMode
{
    
}

#pragma mark loginViewController delegate
- (void)userLoginSuccess
{
    [[LoginViewController singleton].view removeFromSuperview];
    [UsersInformation singleton].alreadyLogin = YES;
    [self.navigationController setNavigationBarHidden:NO];
    [self hideTabBar];
    if (self.subFunction == nil && mode_ == SubFunction) {
        [self initialSubFunctions];
        [super updateTheSubFunctionViewController];
    }
}

#pragma mark SubfunctionView DataSource
- (int )subFunctionViewController:(SubFunctionViewController* )subFunctionViewController
    BadgeNumberAtSubFunctionTitle:(NSString* )title
{
    if ([title isEqualToString:@"浙传资讯"] ||
        [title isEqualToString:@"首页"]) {
        return 0;
    }
    NSDictionary* allNotificationDictionary = [[RemoteNotificationCenter singleton] getAllUnHandleRemoteNotifcation];
    NSDictionary* subFunctionsDictionary = [allNotificationDictionary objectForKey:self.functionCode];
    if ([title isEqualToString:@"学生课表"]) {
        NSArray* notifications = [subFunctionsDictionary objectForKey:@"01"];
        return [notifications count];
    }
    return 0;
}

- (float )minimumLineSpacingOfSubFunctionViewController:(SubFunctionViewController* )subFunctionViewController
{
    return 0;
}

- (UIImage* )subFunctionViewController:(SubFunctionViewController* )subFunctionViewController
                 SelectedImageForTitle:(NSString* )title
{
    NSString* imageName;
    if ([title isEqualToString:@"浙传资讯"]) {
        imageName = @"浙传资讯.png";
    }
    else if ([title isEqualToString:@"首页"])
    {
        imageName = @"Home.png";
    }
    else if ([title isEqualToString:@"学生课表"])
    {
        imageName = @"学生课表.png";
    }
    return [UIImage imageNamed:imageName];
}

- (UIImage* )subFunctionViewController:(SubFunctionViewController *)subFunctionViewController
               UnselectedImageForTitle:(NSString *)title
{
    NSString* imageName;
    if ([title isEqualToString:@"浙传资讯"]) {
        imageName = @"浙传资讯(灰色).png";
    }
    else if ([title isEqualToString:@"首页"])
    {
        imageName = @"Home(灰色).png";
    }
    else if ([title isEqualToString:@"学生课表"])
    {
        imageName = @"学生课表(灰色).png";
    }
    return [UIImage imageNamed:imageName];
}

- (NSArray* )titlesForSubFunctionViewController:(SubFunctionViewController* )subFunctionViewController
{
    return [NSArray arrayWithObjects:@"浙传资讯",@"首页",@"学生课表",@"首页",@"浙传资讯", nil];
}

#pragma mark subfunctionView delegate
- (void)selectTheSubFunction:(NSString* )title
{
    if ([title isEqualToString:@"首页"]) {
        [self.tabBarController setSelectedIndex:0];
    }
}

#pragma mark Template Method

#
@end
