//
//  MeetsViewController.m
//  SchoolNews
//
//  Created by Jerry on 3月26星期二.
//
//

#import "MeetsViewController.h"
#import "PublicDefines.h"
#import "MeetCollectionViewController.h"
#import "MeetCollectionViewCell.h"
#import "MeetLayout.h"
#import "UIImage+Scale.h"
#import "LoginViewController.h"
#import "UsersInformation.h"
#import "AboutTime.h"
#import "WeekIndexWebService.h"
#import "MeetShowViewController.h"
#import "MeetsData.h"
#import "MeetCollectionViewCell.h"
#import "RemotePushNotificationObject.h"
#import "MeetXMLAnalyze.h"
#define WEEKDAY_SEGMENTEDCONTROLLER_HEIGHT                  30

@interface MeetsViewController ()

//- (void)weekdayChangeBySegmented:(UISegmentedControl *)sender;
- (void)loadTheNavigationBarTitleView;
- (void)loadTheReturnTodayBarButton;
- (void)returnToToday;
- (void)loadTheHaveNoRightImageView;
//- (void)loadWeekdayLabel;
- (void)loadMeetCollectionView;
- (void)getWeekIndexFromServer:(NSNotification* )sender;
- (int )itemIndexForWeek:(int )week AndWeekday:(int )weekday;
@end

@implementation MeetsViewController
MeetsViewController* g_MeetsViewController;
+ (MeetsViewController* )singleton
{
    if (g_MeetsViewController == nil) {
        g_MeetsViewController = [[MeetsViewController alloc] init];
    }
    return g_MeetsViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* tempImage = [UIImage imageNamed:@"一周会议.png"];
        self.iconImage = tempImage;
        //UIImage* tabBarImage = [tempImage scaleToSize:CGSizeMake(32, 32)];
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"一周会议"
                                                                 image:tempImage
                                                                   tag:0];
        self.tabBarItem = tabBarItem;
        [self addObserver:self
               forKeyPath:@"week_"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
        [self addObserver:self
               forKeyPath:@"weekday_"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getWeekIndexFromServer:)
                                                     name:GET_WEEK_INDEX_FROM_SERVER
                                                   object:nil];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.autoresizesSubviews = NO;

}

- (void)viewDidLoad
{
    mode_ = Normal;
    [super viewDidLoad];
    [self loadTheNavigationBarTitleView];
    //[self loadMeetCollectionView];
    [self loadTheReturnTodayBarButton];
    //[self loadWeekdayLabel];
	// Do any additional setup after loading the view.
}

//初始化有子功能菜单的界面
- (void)initialSubFunctions
{
    
}

//初始化正常模式的界面
- (void)loadNormalMode
{
    if (collectionViewController_ == nil) {
        [self loadMeetCollectionView];
    }
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
        //判断是否有权限
        if ([[UsersInformation singleton].userRightFunctionSet containsObject:self.title]) {
            if ([self.view.subviews containsObject:haveNoRightImageView_]) {
                [haveNoRightImageView_ removeFromSuperview];
                haveNoRightImageView_ = nil;
            }
            if (weekday_ == nil || week_ == nil) {
                //向服务器获取所在周次
                [self getWeekIndexFromServerWithWebservice];
            }
            [self.navigationController setNavigationBarHidden:NO];
            if (collectionViewController_ == nil) {
                [self loadMeetCollectionView];
            }
            collectionViewController_.view.frame = CGRectMake(0, -12, 320, SCREEN_HEIGHT);
        }
        else
        {
            [self loadTheHaveNoRightImageView];
            [self.navigationController setNavigationBarHidden:YES];
            [self.view addSubview:haveNoRightImageView_];
        }
        //NSLog(@"%@",NSStringFromCGRect(collectionViewController_.collectionView.frame));
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self handleThePushNotification];
}

- (void)handleThePushNotification
{
    //NSArray* array = [[[RemoteNotificationCenter singleton] getAllUnHandleRemoteNotifcation] objectForKey:self.functionCode];
    if (self.badgeNumber == 0) {
        return;
    }
    else if (self.badgeNumber == 1) {
        //显示新闻
        NSArray* notifications = [[RemoteNotificationCenter singleton] getRemoteNotificationForFunctionCode:self.functionCode];
        RemotePushNotificationObject* remoteNotification = [notifications objectAtIndex:0];
        NSString* contentID = remoteNotification.contentID;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString* urlString = GET_MEET_TOTALINFORMATION(contentID);
            NSError* error;
            NSString* meetXML = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
            if (error) {
                NSLog(@"获取会议远程消息失败");
            }
            NSArray* meets = [MeetXMLAnalyze analyzeXML:meetXML];
            if ([meets count] > 0) {
                MeetObject* meet = [meets objectAtIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    int item = [self itemIndexForWeek:meet.week AndWeekday:[meet.weekDay intValue]];
                    [collectionViewController_.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]
                                                                     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                                             animated:NO];
                    [self selectTheMeet:meet];
                });
            }
        });
    }
    else if(self.badgeNumber == 2)
    {
        //刷新新闻列表
        
    }
    //清空所属的远程消息
    [[RemoteNotificationCenter singleton] clearTheRemotePushNotificationsForFunctionCode:self.functionCode];
}


#pragma mark login delegate
- (void)userLoginSuccess
{
    [[LoginViewController singleton].view removeFromSuperview];
    [UsersInformation singleton].alreadyLogin = YES;
    if ([[UsersInformation singleton].userRightFunctionSet containsObject:self.title]) {
        if ([self.view.subviews containsObject:haveNoRightImageView_]) {
            [haveNoRightImageView_ removeFromSuperview];
            haveNoRightImageView_ = nil;
        }
        if (weekday_ == nil || week_ == nil) {
            //向服务器获取所在周次
            [self getWeekIndexFromServerWithWebservice];
        }
        [self.navigationController setNavigationBarHidden:NO];
        if (collectionViewController_ == nil) {
            [self loadMeetCollectionView];
        }
        collectionViewController_.view.frame = CGRectMake(0, -12, 320, SCREEN_HEIGHT);
    }
    else
    {
        [self loadTheHaveNoRightImageView];
        [self.navigationController setNavigationBarHidden:YES];
        [self.view addSubview:haveNoRightImageView_];
    }
}

#pragma mark meetListTableView Select Delegate
- (void)selectTheMeet:(MeetObject *)sender
{
    MeetShowViewController* meetShowViewController = [[MeetShowViewController alloc] initWithShowMeet:sender];
    [self.navigationController pushViewController:meetShowViewController animated:YES];
}

#pragma mark meetCollectionViewController
- (void)showTheWeek:(int )week
{
    NSString* weekString = [NSString stringWithFormat:@"第%i周",week];
    week_ = [NSNumber numberWithInt:week];
    [weekLabel_ setText:weekString];
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"week_"]) {
        NSString* title = [NSString stringWithFormat:@"第%i周",[week_ intValue]];
        [weekLabel_ setText:title];
        int itemIndex = [self itemIndexForWeek:[week_ intValue]
                                    AndWeekday:[weekday_ intValue]];
        [collectionViewController_ scrollToSpecialItem:itemIndex];
    }
    else if ([keyPath isEqualToString:@"weekday_"])
    {
        int itemIndex = [self itemIndexForWeek:[week_ intValue]
                                    AndWeekday:[weekday_ intValue]];
        [collectionViewController_ scrollToSpecialItem:itemIndex];
    }
}

#pragma mark Template Method

#pragma mark privateAPI

- (void)weekdayChangeBySegmented:(UISegmentedControl *)sender
{
    int nowWeekday = [sender selectedSegmentIndex] + 1;
    NSNumber* weekday = [NSNumber numberWithInt:nowWeekday];
    [self setValue:weekday forKeyPath:@"weekday_"];
}

- (void)loadTheNavigationBarTitleView
{
    UIView* titleViewInNavigatonItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, NAVIGATIONBAR_HEIGHT)];
    UIButton* laterWeekButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [laterWeekButton setFrame:CGRectMake(150, 0, 50, 40)];
    UIImage* goImage = [UIImage imageNamed:@"前进.png"];
    [laterWeekButton setImage:goImage
                     forState:UIControlStateNormal];
    [laterWeekButton addTarget:self
                        action:@selector(gotoLaterWeek)
              forControlEvents:UIControlEventTouchUpInside];
    UIButton* lastWeekButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastWeekButton setFrame:CGRectMake(0, 0, 50, 40)];
    UIImage* backImage = [UIImage imageNamed:@"后退.png"];
    [lastWeekButton setImage:backImage
                    forState:UIControlStateNormal];
    [lastWeekButton addTarget:self
                       action:@selector(gotoLastWeek)
             forControlEvents:UIControlEventTouchUpInside];
    weekLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, NAVIGATIONBAR_HEIGHT)];
    [weekLabel_ setBackgroundColor:[UIColor clearColor]];
    [weekLabel_ setTextAlignment:NSTextAlignmentCenter];
    [weekLabel_ setTextColor:[UIColor whiteColor]];
    [weekLabel_ setText:@""];
    [weekLabel_ setFont:[UIFont systemFontOfSize:20]];
    [titleViewInNavigatonItem addSubview:weekLabel_];
    [titleViewInNavigatonItem addSubview:lastWeekButton];
    [titleViewInNavigatonItem addSubview:laterWeekButton];
    
    self.navigationItem.titleView = titleViewInNavigatonItem;
}

- (void)loadTheReturnTodayBarButton
{
    UIBarButtonItem* todayBarButton = [[UIBarButtonItem alloc] initWithTitle:@"今天"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(returnToToday)];
    self.navigationItem.rightBarButtonItem = todayBarButton;
}

- (void)returnToToday
{
    int todayWeek = [[MeetsData singleton] getTodayWeek];
    int todayWeekDay = [[MeetsData singleton] getTodayWeekDay];
    int item = [self itemIndexForWeek:todayWeek AndWeekday:todayWeekDay];
    NSIndexPath* indexpath = [NSIndexPath indexPathForItem:item inSection:0];
    [collectionViewController_.collectionView scrollToItemAtIndexPath:indexpath
                                                     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                             animated:YES];
}

- (void)loadTheHaveNoRightImageView
{
    if (haveNoRightImageView_ == nil) {
        haveNoRightImageView_ = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [haveNoRightImageView_ setImage:[UIImage imageNamed:@"没有访问权限.png"]];
    }
}

- (void)gotoLastWeek
{
    int oldWeek = [week_ intValue];
    if (oldWeek > 1) {
        oldWeek --;
    }
    [self setValue:[NSNumber numberWithInt:oldWeek] forKeyPath:@"week_"];
    
}

- (void)gotoLaterWeek
{
    int oldWeek = [week_ intValue];
    if (oldWeek < 20) {
        oldWeek ++;
    }
    [self setValue:[NSNumber numberWithInt:oldWeek] forKeyPath:@"week_"];
}

- (void)loadMeetCollectionView
{
    MeetLayout* layout = [[MeetLayout alloc] init];
    collectionViewController_ = [[MeetCollectionViewController alloc]initWithCollectionViewLayout:layout];
    collectionViewController_.delegate = self;
    [self addChildViewController:collectionViewController_];
    [self.view addSubview:collectionViewController_.collectionView];
    //collectionViewController_.collectionView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

/*- (void)loadWeekdayLabel
{
    weekDayLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [weekDayLabel_ setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:weekDayLabel_];
}*/

- (void)getWeekIndexFromServerWithWebservice
{
    WeekIndexWebService* webservice = [WeekIndexWebService singleton];
    
    NSString* today = [[[NSDate date] description] substringToIndex:10];
    NSString* urlString = GET_WEEK_INDEX_URL(today);
    [webservice setURLWithString:urlString];
    [webservice getWebServiceData];
}

- (void)getWeekIndexFromServer:(NSNotification* )sender
{
    AboutTime* timeFunction = [AboutTime singleton];
    int weekDay = [timeFunction getWeekDayReturnInt:[NSDate date]];
    weekday_ = [NSNumber numberWithInt:weekDay];
    NSString* weekString = [sender object];
    int week = [weekString intValue];
    [[MeetsData singleton] setInitialWeek:week initialWeekday:weekDay date:[NSDate date]];
    [self setValue:[NSNumber numberWithInt:week] forKeyPath:@"week_"];
    
}

- (int )itemIndexForWeek:(int )week AndWeekday:(int )weekday
{
    int itemIndex = (week - 1) * 7 + weekday - 1;
    return itemIndex;
}
@end
