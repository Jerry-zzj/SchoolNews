//
//  NewsViewController.m
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewControllerFactory.h"
#import "DataBaseOperating.h"
#import "NewsShowViewController.h"
#import "UserSettingViewController.h"
#import "UIImage+Scale.h"
#import "ShowNewsQueue.h"
#import "PublicDefines.h"
#import "WeatherView.h"
#import "RemoteNotificationCenter.h"
#import "RemotePushNotificationObject.h"
#import "NewsXMLAnalyze.h"
#import "SchoolNewsTabBarController.h"
#define SUBTITLE_VIEW_HEIGHT                30
#define NEWSTABLEVIEW_HEIGHT                SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT - SUBTITLE_VIEW_HEIGHT
@interface NewsViewController (Private)

- (void)loadSubtitleView;//加载栏目视图
- (void)loadSubtitleTableViews;//加载新闻列表
- (void)loadWeatherView;//加载天气视图
//- (void)loadTheSettingBarbutton;//加载设置按钮
- (void)loadTheShowMoreFunctionButton;//加载更新按钮
- (void)showTheMoreFunctionView;
- (void)updateTheNews;
- (void)showTheSubviewForSubtitle:(NSString* )subtitle;//展现针对栏目：|subtitle|的新闻
- (void)updateTheNewsBackgroundScrollView;//更新新闻背景ScrollView
- (void)gotoSettingView;//进入设置视图

@end

@implementation NewsViewController
#pragma mark public API
NewsViewController* g_NewsViewController;
+ (FunctionViewController* )singleton
{
    if (g_NewsViewController == nil) {
        g_NewsViewController = [[NewsViewController alloc] init];
    }
    return g_NewsViewController;
}

- (void)handleThePushNotification
{
    //NSArray* array = [[[RemoteNotificationCenter singleton] getAllUnHandleRemoteNotifcation] objectForKey:self.functionCode];
    if (self.badgeNumber == 0) {
        return;
    }
    else if (self.badgeNumber == 1) {
        //显示新闻
        NewsTableViewController* newsTableViewController = [allsubtitleTableViewArray_ objectAtIndex:0];
        [newsTableViewController goToDragDownState];
        NSArray* array = [[[RemoteNotificationCenter singleton] getAllUnHandleRemoteNotifcation] objectForKey:self.functionCode];
        RemotePushNotificationObject* remoteNotification = [array objectAtIndex:0];
        NSString* contentID = remoteNotification.contentID;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError* error;
            //NSLog(@"%@",NEWS_TOTAL_INFORMATION_WITHOUT_CONTENT(contentID));
            NSURL* url = [NSURL URLWithString:NEWS_TOTAL_INFORMATION_WITHOUT_CONTENT(contentID)];
            NSString* string = [NSString stringWithContentsOfURL:url
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];
            //NSLog(@"news get : %@",string);
            if (!error) {
                NSLog(@"获得推送消息具体信息失败");
            }
            NSArray* newses = [NewsXMLAnalyze analyzeXML:string];
            if ([newses count] > 0) {
                NewsObject* news = [newses objectAtIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self selectTheNews:news];
                });
            }
        });
    }
    else if(self.badgeNumber == 2)
    {
        //刷新新闻列表
        NewsTableViewController* newsTableViewController = [allsubtitleTableViewArray_ objectAtIndex:0];
        [newsTableViewController goToDragDownState];
    }
    //清空所属的远程消息
    [[RemoteNotificationCenter singleton] clearTheRemotePushNotificationsForFunctionCode:self.functionCode];
}

- (void)selectTheNews:(NewsObject* )sender
{
    NewsShowViewController* newsShowViewController = [[NewsShowViewController alloc] initWithNews:sender];
    [self.navigationController pushViewController:newsShowViewController animated:YES];
}

#pragma mark life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [ShowNewsQueue singleton];
        showSubtitleTableViewDictionary_ = [NSMutableDictionary dictionary];
        [[SubtitleViewController singleton] addObserver:self
                                             forKeyPath:@"subtitlesArray"
                                                options:0
                                                context:nil];
        // Custom initialization
        UIImage* tempImage = [UIImage imageNamed:@"浙传新闻.png"];
        self.iconImage = tempImage;
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"浙传新闻"
                                                                 image:tempImage
                                                                   tag:0];
        self.tabBarItem = tabBarItem;
    }
    return self;
}



- (void)viewDidLoad
{
    mode_ = Normal;
    //[self.navigationController setNavigationBarHidden:YES];
    [super viewDidLoad];
    //[self loadTheSettingBarbutton];
    [self loadWeatherView];
    [self loadTheShowMoreFunctionButton];
    [self loadSubtitleView];
    [self loadSubtitleTableViews];
    
    //--------------------------------------------------------------------------
    
    // Do any additional setup after loading the view from its nib.
}

//初始化有子功能菜单的界面
- (void)initialSubFunctions
{
    
}

//初始化正常模式的界面
- (void)loadNormalMode
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"subtitlesArray"]) {
        [self updateTheNewsBackgroundScrollView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self showTabBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self handleThePushNotification];
}

- (void)dealloc
{
    [[SubtitleViewController singleton] removeObserver:self
                                            forKeyPath:@"subtitlesArray"];
}

#pragma mark subtitle delegate
- (void)selectTheSubtitle:(UIButton* )sender
{
    NSString* selectedTitle = [sender currentTitle];
    [self showTheSubviewForSubtitle:selectedTitle];
    //judge the |selectedTitle| to something you wen to do
}

#pragma mark newsTableViewController delegate
- (void)tableViewController:(NewsTableViewController *)tableViewController selectedTheIndexPath:(NSIndexPath *)indexpath News:(NewsObject *)news
{
    //NSLog(@"selected");
    NewsShowViewController* newsShowViewController = [[NewsShowViewController alloc] initWithNews:news];
    [self.navigationController pushViewController:newsShowViewController animated:YES];
}

#pragma mark scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint contentOffSet = scrollView.contentOffset;
    float x = contentOffSet.x;
    float contentSizeWidth = scrollView.contentSize.width;
    int numberOfSubtitle = [subtitleViewController_.subtitlesArray count];
    int indexOfShouldShowSubtitle = x / contentSizeWidth * numberOfSubtitle;
    NSString* shouldShowSubtitle = [subtitleViewController_.subtitlesArray objectAtIndex:indexOfShouldShowSubtitle];
    [subtitleViewController_ moveSelectedSubtitleToTitle:shouldShowSubtitle];
}


#pragma mark private method
- (void)loadSubtitleView
{
    subtitleViewController_ = [[SubtitleViewController alloc] init];
    [self addChildViewController:subtitleViewController_];
    NSString* subtitleFile = [[NSBundle mainBundle] pathForResource:@"NewsSubtitle" ofType:@"plist"];
    NSArray* subtitles = [[NSArray alloc] initWithContentsOfFile:subtitleFile];
    subtitleViewController_.subtitlesArray = subtitles;

    subtitleViewController_.delegate = self;
    [self.view addSubview:subtitleViewController_.view];
}

- (void)loadSubtitleTableViews
{
    //NSArray* subtitle = [[DataBaseOperating singleton] getSubtitleForFunction:self.title];
    NSArray* subtitle = subtitleViewController_.subtitlesArray;
    int numberOfSubtitle = [subtitle count];
    
    //load background scrollview
    newsBackgoundScrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, 320, NEWSTABLEVIEW_HEIGHT)];
    [newsBackgoundScrollView_ setContentSize:CGSizeMake(320 * numberOfSubtitle, NEWSTABLEVIEW_HEIGHT)];
    newsBackgoundScrollView_.pagingEnabled = YES;
    newsBackgoundScrollView_.delegate = self;
    [newsBackgoundScrollView_ setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:newsBackgoundScrollView_];
    //
    
    NSMutableArray* tempAllSubTitleTableViewController = [[NSMutableArray alloc] initWithCapacity:[subtitle count]];
    for (int index = 0; index < numberOfSubtitle; index ++) {
        CGRect frame = CGRectMake(index * 320, 0, 320, NEWSTABLEVIEW_HEIGHT);
        //先加背景图片
        UIImage* image = [[UIImage imageNamed:@"标志.png"] scaleToSize:CGSizeMake(320, 337)];
        UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:image];
        [backgroundImageView setFrame:frame];
        [newsBackgoundScrollView_ insertSubview:backgroundImageView atIndex:0];
        //
        NSString* subtitleName = [subtitle objectAtIndex:index];
        NewsTableViewController* tableViewController = [[NewsTableViewControllerFactory singleton]produceTheNewsTableViewWithIdentifier:subtitleName];
        tableViewController.delegate = self;
        [tableViewController.tableView setFrame:frame];
        [self addChildViewController:tableViewController];
        [showSubtitleTableViewDictionary_ setObject:tableViewController forKey:subtitleName];
        [tempAllSubTitleTableViewController addObject:tableViewController];
        [newsBackgoundScrollView_ addSubview:tableViewController.tableView];
    }
    allsubtitleTableViewArray_ = [NSArray arrayWithArray:tempAllSubTitleTableViewController];
}

- (void)loadWeatherView
{
    WeatherView* weatherView = [WeatherView singleton];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:weatherView];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

//加载更新按钮
- (void)loadTheShowMoreFunctionButton
{
    UIButton* updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateButton setImage:[UIImage imageNamed:@"内容展开图标.png"] forState:UIControlStateNormal];
    [updateButton setFrame:CGRectMake(10, 10, 24, 24)];
    [updateButton addTarget:self
                     action:@selector(showTheMoreFunctionView)
           forControlEvents:UIControlEventTouchUpInside];
    [updateButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:updateButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)showTheMoreFunctionView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMoreFunction" object:nil];
}

//更新新闻,后面不用了，但是功能还是保留在这里
- (void)updateTheNews
{
    NSString* subtitleString = subtitleViewController_.selectedSubtitle;
    NSString* notification;
    if ([subtitleString isEqualToString:@"传媒要闻"]) {
        notification = @"YaowenUpdate";
    }
    else if ([subtitleString isEqualToString:@"综合新闻"])
    {
        notification = @"ZongheUpdate";
    }
    else if ([subtitleString isEqualToString:@"学工"])
    {
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notification
                                                        object:nil];
}

- (void)showTheSubviewForSubtitle:(NSString* )subtitle
{
    int indexOfSubtitle = [subtitleViewController_.subtitlesArray indexOfObject:subtitle];
    [newsBackgoundScrollView_ setContentOffset:CGPointMake(320 * indexOfSubtitle, 0) animated:YES];
}

- (void)updateTheNewsBackgroundScrollView
{
    for (id view in [newsBackgoundScrollView_ subviews]) {
        if ([view isKindOfClass:[UITableView class]]) {
            [view removeFromSuperview];
        }
    }
    [newsBackgoundScrollView_ setContentSize:CGSizeMake(320, NEWSTABLEVIEW_HEIGHT)];
    NSArray* showSubtitle = subtitleViewController_.subtitlesArray;
    for (NSString* subtitleName in showSubtitle) {
        if (![[showSubtitleTableViewDictionary_ allKeys] containsObject:subtitleName]) {
            UITableViewController* tableViewController = [[NewsTableViewControllerFactory singleton] produceTheNewsTableViewWithIdentifier:subtitleName];
            if (![self.childViewControllers containsObject:tableViewController]) {
                [self addChildViewController:tableViewController];
            }
            [showSubtitleTableViewDictionary_ setObject:tableViewController forKey:subtitleName];
        }
    }
    for (NSString* subtitleName in [showSubtitleTableViewDictionary_ allKeys]) {
        if (![showSubtitle containsObject:subtitleName]) {
            [showSubtitleTableViewDictionary_ removeObjectForKey:subtitleName];
        }
    }
    
    for (int index = 0; index < [showSubtitle count]; index ++) {
        NSString* subtitleName = [showSubtitle objectAtIndex:index];
        UITableViewController* tableViewController = [showSubtitleTableViewDictionary_ objectForKey:subtitleName];
        CGRect frame = CGRectMake(index * 320, 0, 320, NEWSTABLEVIEW_HEIGHT);
        //[self addChildViewController:tableViewController];
        [tableViewController.tableView setFrame:frame];
        [newsBackgoundScrollView_ addSubview:tableViewController.tableView];
        [newsBackgoundScrollView_ setContentSize:CGSizeMake(320 * (index + 1), NEWSTABLEVIEW_HEIGHT)];
    }
    [newsBackgoundScrollView_ setContentOffset:CGPointMake(0, 0)];
    [subtitleViewController_ moveSelectedSubtitleToTitle:[showSubtitle objectAtIndex:0]];
    
}

- (void)gotoSettingView
{
    UserSettingViewController* settingViewController = [UserSettingViewController singleton];
    //[self presentModalViewController:settingViewController animated:YES];
    [self presentViewController:settingViewController animated:YES completion:nil];
}
@end
