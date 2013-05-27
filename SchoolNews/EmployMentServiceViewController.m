//
//  EmployMentServiceViewController.m
//  SchoolNews
//
//  Created by Jerry on 4月1星期一.
//
//

#import "EmployMentServiceViewController.h"
#import "UIImage+Scale.h"
#import "LoginViewController.h"
#import "UsersInformation.h"
#import "JobObject.h"
#import "NotificationLayout.h"
#import "EmploymentShowViewController.h"

#import "ContentObject.h"
#import "ContentShowWebViewController.h"
#import "JobListTableViewController.h"
#import "PracticeListTableViewController.h"
#import "ReproducedEmploymentListTableViewController.h"
#import "PublicDefines.h"

#import "SubFunctionViewController.h"
#import "RemotePushNotificationObject.h"
#import "EmploymentXMLAnalyze.h"
@interface EmployMentServiceViewController ()

- (void)loadSubtitleView;
- (void)loadEmploymentCollectionViewController;
- (void)loadTheHomeButton;
- (void)gotoTheHomeView;
//- (void)loadSubFunctionView;

- (void)showTheViewForSubtitle:(NSString* )subtitle;

@end

@implementation EmployMentServiceViewController
{
    NSArray* subtitles;
}
EmployMentServiceViewController* g_EmployMentServiceViewController;
+ (EmployMentServiceViewController* )singleton
{
    if (g_EmployMentServiceViewController == nil) {
        g_EmployMentServiceViewController = [[EmployMentServiceViewController alloc] init];
    }
    return g_EmployMentServiceViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* tempImage = [UIImage imageNamed:@"就业服务.png"];
        self.iconImage = tempImage;
        //UIImage* tabBarImage = [tempImage scaleToSize:CGSizeMake(20, 20)];
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"就业服务"
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
    //[self loadTheHomeButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    //self.view.autoresizesSubviews = NO;
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

- (void)setSubFunctionMode:(BOOL )sender
{
    
}

- (void)initialSubFunctions
{
    JobListTableViewController* jobListTableViewController = [[JobListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [jobListTableViewController.tableView setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    jobListTableViewController.delegate = self;
    [self addChildViewController:jobListTableViewController];
    
    PracticeListTableViewController* practiceListTableViewController = [[PracticeListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [practiceListTableViewController.tableView setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT)];
    practiceListTableViewController.delegate = self;
    [self addChildViewController:practiceListTableViewController];
    
    ReproducedEmploymentListTableViewController* reproducedEmploymentListTableViewController = [[ReproducedEmploymentListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [reproducedEmploymentListTableViewController.tableView setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    reproducedEmploymentListTableViewController.delegate = self;
    [self addChildViewController:reproducedEmploymentListTableViewController];
    
    if (self.subFunction == nil) {
        self.subFunction = [NSMutableArray array];
    }
    [self.subFunction removeAllObjects];
    [self.subFunction addObject:reproducedEmploymentListTableViewController];
    [self.subFunction addObject:practiceListTableViewController];
    [self.subFunction addObject:jobListTableViewController];
    [self.view addSubview:reproducedEmploymentListTableViewController.view];
    [self.view insertSubview:reproducedEmploymentListTableViewController.view atIndex:0];
    [self.view insertSubview:practiceListTableViewController.view atIndex:1];
    [self.view insertSubview:jobListTableViewController.view atIndex:2];
    //NSString* titleString = @"就业服务-招聘信息";
    //[self setTitle:titleString];
}

- (void)loadNormalMode
{
    [self loadNormalMode];
    [self loadEmploymentCollectionViewController];
}

#pragma marrk login delegate
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

#pragma mark subtitle select delegate
- (void)selectTheSubtitle:(UIButton *)sender
{
    NSString* selectedSubtitle = [sender currentTitle];
    int index = [subtitles indexOfObject:selectedSubtitle];
    [employmentCollectionViewController_ scrollToSpecialItem:index];
}

#pragma mark NotificationCollectionViewController Delegate
- (void)notificationCollectionViewScrollToItem:(int)item
{
    NSString* selectedSubtitle = [subtitles objectAtIndex:item];
    [subtitleViewController_ moveSelectedSubtitleToTitle:selectedSubtitle];
}


#pragma mark table selectedDelegate
- (void)selectTheEmployment:(id)sender
{
    JobObject* job = (JobObject* )sender;
    if ([job.type isEqualToString:@"信息转载"]) {
        ContentObject* contentObject = [[ContentObject alloc] initWithJob:job];
        ContentShowWebViewController* contentShowViewController = [[ContentShowWebViewController alloc] initWithContentObject:contentObject];
        [self.navigationController pushViewController:contentShowViewController animated:YES];
    }
    else
    {
        EmploymentShowViewController* employmentShowViewController = [[EmploymentShowViewController alloc] initWithEmployment:job];
        [self.navigationController pushViewController:employmentShowViewController animated:YES];

    }
}

#pragma mark SubFunctionViewController Delegate
- (void)subFunctionShow
{
    
}

- (void)selectTheSubFunction:(NSString* )subTitle
{
    if ([subTitle isEqualToString:@"首页"]) {
        [self gotoTheHomeView];
    }
    else if ([subTitle isEqualToString:@"浙传资讯"])
    {
        return;
    }
    else
    {
        [self showTheViewForSubtitle:subTitle];
        EmploymentListTableViewController* employmentListTableViewController;
        for (EmploymentListTableViewController* object in self.subFunction) {
            NSString* viewControllerTitle = [object getType];
            if ([viewControllerTitle isEqualToString:subTitle]) {
                employmentListTableViewController = object;
                break;
            }
        }
        NSString* subFunctionCode = [employmentListTableViewController getSubFunctionCode];
        NSDictionary* subFunctionNotifications = [[[RemoteNotificationCenter singleton] getAllUnHandleRemoteNotifcation] objectForKey:self.functionCode];
        if (subFunctionNotifications != nil) {
            NSArray* array = [subFunctionNotifications objectForKey:subFunctionCode];
            if ([array count] != 0) {
                //下拉刷新
                [employmentListTableViewController goToDragDownState];
            }
            if ([array count] == 1) {
                //直接进入内容
                RemotePushNotificationObject* remoteNotification = [array objectAtIndex:0];
                NSString* contentID = remoteNotification.contentID;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSString* urlString;
                    JobObject* job;
                    if ([subFunctionCode isEqualToString:@"01"]) {
                        urlString = GET_JOB_TOTALINFORMATION(contentID);
                    }
                    else if ([subFunctionCode isEqualToString:@"02"])
                    {
                        urlString = GET_PRACTICE_TOTALINFORMATION(contentID);
                    }
                    else if ([subFunctionCode isEqualToString:@"03"])
                    {
                        urlString = GET_REPRODUCED_TOTALINFORMATION_WITHOUT_CONTENT(contentID);
                    }
                    NSError* error;
                    NSLog(@"就业服务：%@",urlString);
                    NSString* xml = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]
                                                             encoding:NSUTF8StringEncoding
                                                                error:&error];
                    if (error != nil) {
                        NSLog(@"获得信息转载信息失败");
                    }
                    NSArray* reproduceds = [EmploymentXMLAnalyze analyzeXML:xml];
                    if ([reproduceds count] > 0) {
                        job = [reproduceds objectAtIndex:0];
                        if ([subFunctionCode isEqualToString:@"01"]) {
                            job.type = @"招聘信息";
                        }
                        else if ([subFunctionCode isEqualToString:@"02"])
                        {
                            job.type = @"实习信息";
                        }
                        else if ([subFunctionCode isEqualToString:@"03"])
                        {
                            job.type = @"信息转载";
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self selectTheEmployment:job];
                        });
                    }
                });
            }
            //清空所属功能的通知
            NSString* functionCode = [NSString stringWithFormat:@"%@%@",self.functionCode,subFunctionCode];
            [[RemoteNotificationCenter singleton] clearTheRemotePushNotificationsForFunctionCode:functionCode];
        }
        NSString* titleString = [NSString stringWithFormat:@"就业服务-%@",subTitle];
        [self setTitle:titleString];
    }
}

#pragma mark Template Method


#pragma mark SubFunctionViewController DataSource
- (int )subFunctionViewController:(SubFunctionViewController* )subFunctionViewController
    BadgeNumberAtSubFunctionTitle:(NSString* )title
{
    if ([title isEqualToString:@"浙传资讯"] ||
        [title isEqualToString:@"首页"]) {
        return 0;
    }
    NSDictionary* allNotificationDictionary = [[RemoteNotificationCenter singleton] getAllUnHandleRemoteNotifcation];
    NSDictionary* subFunctionsDictionary = [allNotificationDictionary objectForKey:self.functionCode];
    if ([title isEqualToString:@"招聘信息"]) {
        NSArray* notifications = [subFunctionsDictionary objectForKey:@"01"];
        return [notifications count];
    }
    else if ([title isEqualToString:@"实习信息"])
    {
        NSArray* notifications = [subFunctionsDictionary objectForKey:@"02"];
        return [notifications count];
    }
    else if ([title isEqualToString:@"信息转载"])
    {
        NSArray* notifications = [subFunctionsDictionary objectForKey:@"03"];
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
    else if ([title isEqualToString:@"招聘信息"])
    {
        imageName = @"招聘信息.png";
    }
    else if ([title isEqualToString:@"实习信息"])
    {
        imageName = @"实习信息.png";
    }
    else if ([title isEqualToString:@"信息转载"])
    {
        imageName = @"信息转载.png";
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
    else if ([title isEqualToString:@"招聘信息"])
    {
        imageName = @"招聘信息(灰色).png";
    }
    else if ([title isEqualToString:@"实习信息"])
    {
        imageName = @"实习信息(灰色).png";
    }
    else if ([title isEqualToString:@"信息转载"])
    {
        imageName = @"信息转载(灰色).png";
    }
    return [UIImage imageNamed:imageName];
}

- (NSArray* )titlesForSubFunctionViewController:(SubFunctionViewController* )subFunctionViewController
{
    NSArray* array = [NSArray arrayWithObjects:@"浙传资讯",@"首页",@"招聘信息",@"实习信息",@"信息转载",@"首页",@"浙传资讯", nil];
    return array;
}

#pragma mark private
- (void)loadSubtitleView
{
    subtitleViewController_ = [[SubtitleViewController alloc] init];
    [self addChildViewController:subtitleViewController_];
    NSString* subtitleFile = [[NSBundle mainBundle] pathForResource:@"EmploymentSubtitle" ofType:@"plist"];
    subtitles = [[NSArray alloc] initWithContentsOfFile:subtitleFile];
    subtitleViewController_.subtitlesArray = subtitles;
    
    subtitleViewController_.delegate = self;
    [self.view addSubview:subtitleViewController_.view];
    
}

- (void)loadEmploymentCollectionViewController
{
    NotificationLayout* layout = [[NotificationLayout alloc] init];
    employmentCollectionViewController_ = [[EmploymentCollectionViewController alloc] initWithCollectionViewLayout:layout];
    employmentCollectionViewController_.delegate = self;
    //[self addChildViewController:employmentCollectionViewController_];
    [self.view addSubview:employmentCollectionViewController_.collectionView];
    
}

- (void)showTheViewForSubtitle:(NSString* )subtitle
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
    
	//[UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
	//	[UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:parentView cache:YES];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	//	[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:parentView cache:YES];
    //NSInteger maroon = [[parentView subviews] indexOfObject:[parentView viewWithTag:1001]];
    int toShowIndex = 0;
    //NSArray* array = self.subFunction;
    for (EmploymentListTableViewController* object in self.subFunction) {
        NSString* viewControllerTitle = [object getType];
        if ([viewControllerTitle isEqualToString:subtitle]) {
            toShowIndex = [self.subFunction indexOfObject:object];
            break;
        }
    }
    [self.view exchangeSubviewAtIndex:2 withSubviewAtIndex:toShowIndex];
    [UIView commitAnimations];
    [self.subFunction exchangeObjectAtIndex:toShowIndex withObjectAtIndex:2];
}

#pragma mark template method
- (void)doTransformFromNormalToSubFunction
{
    if(subtitleViewController_ != nil) {
        [subtitleViewController_.view removeFromSuperview];
        subtitleViewController_ = nil;
    }
    if(employmentCollectionViewController_ != nil){
        [employmentCollectionViewController_.view removeFromSuperview];
        employmentCollectionViewController_ = nil;
    }
}

- (void)doTransformFromSubFunctionToNormal
{
    
    if(subtitleViewController_ == nil)
    {
        [self loadSubtitleView];
    }
    if(employmentCollectionViewController_ == nil)
    {
        [self loadEmploymentCollectionViewController];
    }
}

- (void)loadTheHomeButton
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 25, 25)];
    [button setImage:[UIImage imageNamed:@"Home.png"] forState:UIControlStateNormal];
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(gotoTheHomeView)
     forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)gotoTheHomeView
{
    //NSArray* viewControllers = self.tabBarController.viewControllers;
    [self.tabBarController setSelectedIndex:0];
}

/*- (void)loadSubFunctionView
{
    if (subfunctionViewController_ == nil) {
        subfunctionViewController_ = [[SubFunctionViewController alloc] init];
    }
    subfunctionViewController_.delegate = self;
    if (![self.view.subviews containsObject:subfunctionViewController_.collectionView]) {
        [subfunctionViewController_ setMainFunctions:self];
        [self.view addSubview:subfunctionViewController_.collectionView];
    }
}*/

#pragma mark template method
- (void)doSomeWhenSubFunctionViewShow
{
     /*[UIView beginAnimations:@"ShowSubFunction" context:nil];
    [UIView setAnimationDuration:0.5];
    
    for (UIViewController* object in self.subFunction) {
        [object.view setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT - 50)];
    }
    
    [UIView commitAnimations];*/
}

- (void)doSomeWhenSubFunctionViewHide
{
    /*[UIView beginAnimations:@"HideSubFunction" context:nil];
    [UIView setAnimationDuration:0.5];
    
    for (UIViewController* object in self.subFunction) {
        [object.view setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT)];
    }
    
    [UIView commitAnimations];*/
}
@end
