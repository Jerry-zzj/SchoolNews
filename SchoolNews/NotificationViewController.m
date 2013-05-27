//
//  NotificationViewController.m
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import "NotificationViewController.h"
#import "DataBaseOperating.h"
#import "UIImage+Scale.h"
#import "NotificationObject.h"
#import "PublicDefines.h"
#import "UsersInformation.h"
#import "LoginViewController.h"
#import "NotificationLayout.h"
#import "ContentObject.h"
#import "ContentShowWebViewController.h"
#import "NotificationCollectionCell.h"
#import "RemotePushNotificationObject.h"
#import "NotificationXMLAnalyze.h"
//#import "NotificationWebShowViewController.h"
@interface NotificationViewController ()

- (void)loadSubtitleView;
- (void)loadNotificationCollectionViewController;

@end

@implementation NotificationViewController
{
    NSArray* subtitles;
}
NotificationViewController* g_NotificationViewController;
+ (NotificationViewController* )singleton
{
    if (g_NotificationViewController == nil) {
        g_NotificationViewController = [[NotificationViewController alloc] init];
    }
    return g_NotificationViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* tempImage = [UIImage imageNamed:@"通知公告.png"];
        self.iconImage = tempImage;
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"日常通知"
                                                                 image:tempImage
                                                                   tag:0];
        self.tabBarItem = tabBarItem;
    }
    return self;
}

- (void)selectTheNOtificationToGoToShowView:(NotificationObject* )sender
{
    ContentObject* contentObject = [[ContentObject alloc] initWithNotification:sender];
    
    ContentShowWebViewController* showWebViewController = [[ContentShowWebViewController alloc] initWithContentObject:contentObject];
    
    [self.navigationController pushViewController:showWebViewController animated:YES];
    /*NotificationWebShowViewController* notificationShowViewController = [[NotificationWebShowViewController alloc] initWithShowNotification:sender];
    [self.navigationController pushViewController:notificationShowViewController animated:YES];*/
}

- (void)viewDidLoad
{
    mode_ = Normal;
    [super viewDidLoad];
    [self loadSubtitleView];
    [self loadNotificationCollectionViewController];
	// Do any additional setup after loading the view.
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        [self.navigationController setNavigationBarHidden:NO];
        //NSLog(@"collectionView%@",NSStringFromCGRect(notificationCollectionViewController_.view.frame));
        //NSLog(@"self.View:%@",NSStringFromCGRect(self.view.frame));
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
        [notificationCollectionViewController_.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                                                     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                                             animated:NO];
        NotificationCollectionCell* cell = (NotificationCollectionCell* )[notificationCollectionViewController_.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [cell refreshTheTableView];
        NSArray* array = [[[RemoteNotificationCenter singleton] getAllUnHandleRemoteNotifcation] objectForKey:self.functionCode];
        RemotePushNotificationObject* remoteNotification = [array objectAtIndex:0];
        NSString* contentID = remoteNotification.contentID;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError* error;
            NSURL* url = [NSURL URLWithString:GET_NOTIFICATION_INFORMATION(contentID)];
            NSString* string = [NSString stringWithContentsOfURL:url
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];
            //NSLog(@"%@",NEWS_TOTAL_INFORMATION_WITHOUT_CONTENT(contentID));
            if (!error) {
                NSLog(@"获得推送消息具体信息失败");
            }
            NSArray* notifications = [NotificationXMLAnalyze analyzeXML:string];
            if ([notifications count] > 0) {
                NotificationObject* notification = [notifications objectAtIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self selectTheNOtificationToGoToShowView:notification];
                });
            }
        });
    }
    else if(self.badgeNumber == 2)
    {
        //刷新新闻列表
        [notificationCollectionViewController_.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                                                     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                                             animated:NO];
        NotificationCollectionCell* cell = (NotificationCollectionCell* )[notificationCollectionViewController_.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [cell refreshTheTableView];
    }
    //清空所属的远程消息
    [[RemoteNotificationCenter singleton] clearTheRemotePushNotificationsForFunctionCode:self.functionCode];
}

#pragma marrk login delegate
- (void)userLoginSuccess
{
    [[LoginViewController singleton].view removeFromSuperview];
    [UsersInformation singleton].alreadyLogin = YES;
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark subtitle select delegate
- (void)selectTheSubtitle:(UIButton *)sender
{
    NSString* selectedSubtitle = [sender currentTitle];
    int index = [subtitles indexOfObject:selectedSubtitle];
    [notificationCollectionViewController_ scrollToSpecialItem:index];
}

#pragma mark NotificationCollectionViewController Delegate
- (void)notificationCollectionViewScrollToItem:(int)item
{
    NSString* selectedSubtitle = [subtitles objectAtIndex:item];
    [subtitleViewController_ moveSelectedSubtitleToTitle:selectedSubtitle];
}

#pragma mark table selectedDelegate
- (void)selectTheNotification:(id)sender
{
    
    ContentObject* contentObject = [[ContentObject alloc] initWithNotification:sender];
    
    ContentShowWebViewController* showWebViewController = [[ContentShowWebViewController alloc] initWithContentObject:contentObject];
    //[showWebViewController setZoomEnable:YES];
    
    [self.navigationController pushViewController:showWebViewController animated:YES];
    /*NotificationObject* notification = (NotificationObject* )sender;
    
    NotificationWebShowViewController* notificationShowViewController = [[NotificationWebShowViewController alloc] initWithShowNotification:notification];
    [self.navigationController pushViewController:notificationShowViewController animated:YES];*/
}
#pragma mark Template Method

#pragma mark private
- (void)loadSubtitleView
{
    subtitleViewController_ = [[SubtitleViewController alloc] init];
    [self addChildViewController:subtitleViewController_];
    NSString* subtitleFile = [[NSBundle mainBundle] pathForResource:@"NotificationSubtitle" ofType:@"plist"];
    subtitles = [[NSArray alloc] initWithContentsOfFile:subtitleFile];
    subtitleViewController_.subtitlesArray = subtitles;
    
    subtitleViewController_.delegate = self;
    [self.view addSubview:subtitleViewController_.view];
    
}

- (void)loadNotificationCollectionViewController
{
    NotificationLayout* layout = [[NotificationLayout alloc] init];
    notificationCollectionViewController_ = [[NotificationCollectionViewController alloc] initWithCollectionViewLayout:layout];
    notificationCollectionViewController_.delegate = self;
    [self addChildViewController:notificationCollectionViewController_];
    [self.view addSubview:notificationCollectionViewController_.view];
    
}
@end
