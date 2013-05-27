//
//  AppDelegate.m
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SchoolNewsTabBarController.h"
#import "UsersInformation.h"
#import "RemotePushNotificationWebService.h"
#import "PublicDefines.h"
#import "RemotePushNotificationObject.h"
#import "MoreFunctionPullViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "RemoteNotificationCenter.h"
#import "APService.h"
//#import "MyMD5.h"
@interface AppDelegate(PrivateAPI)

- (void)getAllUnhandleRemoteNotification;
- (void)setBadgeNumberByUnhandleNotification;
- (void)setUsersFirstLanuchSetting;
- (void)jpushInitialWithOpyions:(NSDictionary* )sender;

@end

//#import "AboutTime.h"
@implementation AppDelegate
{
    Reachability* reachability_;
    NetworkStatus* remoteHostState_;
}
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //NSLog(@"%@",[MyMD5 md5:@"20111069"]);
    //判断用户是不是第一次登录
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //TabBarController
    SchoolNewsTabBarController* tabBarController = [SchoolNewsTabBarController singleton];
    [tabBarController.view setFrame:CGRectMake(0, 20, 320, SCREEN_HEIGHT)];
    [self.window addSubview:tabBarController.view];
    //更多内容
    MoreFunctionPullViewController* moreFunctionViewController = [MoreFunctionPullViewController singleton];
    [moreFunctionViewController.view setFrame:CGRectMake(PULL_VIEW_RESPONSE_WIDTH - 320, 20, 320, SCREEN_HEIGHT)];
    [self.window addSubview:moreFunctionViewController.view];
    
    //[UsersInformation singleton];
   
    //注册推送消息
    [self jpushInitialWithOpyions:launchOptions];
    /*UIRemoteNotificationType types = (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    if ([launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]) {
        //程序因为点击远程消息启动
        [self getAllUnhandleRemoteNotification];
        NSDictionary* userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        [application setApplicationIconBadgeNumber:0];
    }
    else
    {
        //程序点击图标启动
        [application setApplicationIconBadgeNumber:0];
    }*/
    
    //判断用户是不是第一次登录
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [self setUsersFirstLanuchSetting];
    }
    
     [UsersInformation singleton];
    //
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //保存用户信息
    [[UsersInformation singleton] saveTheUserInformation];
    //根据没有处理的远程消息设置badgeNumber
    [self setBadgeNumberByUnhandleNotification];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[[RemoteNotificationHandleCenter singleton]loadAllUnhandlePushNotification];
    [application setApplicationIconBadgeNumber:0];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//想苹果服务器注册远程通知服务获得Device Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* tempDeviceTokenString = [NSString stringWithFormat:@"%@",deviceToken];
    NSString* withspaceDeviceToken = [tempDeviceTokenString substringWithRange:NSMakeRange(1, [tempDeviceTokenString length] - 2)];
    NSString* trueDeviceToken = [withspaceDeviceToken stringByReplacingOccurrencesOfString:@" "
                                                                         withString:@""];
    [[RemoteNotificationCenter singleton] handInTheDeviceTokenToTheServerWithAccount:trueDeviceToken];
    NSLog(@"Device Token:%@",trueDeviceToken);
    //jpush
    [APService registerDeviceToken:deviceToken];
}

//注册推送消息失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册推送消息失败：%@",[error domain]);
}

//处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //jpush
    [APService handleRemoteNotification:userInfo];
    //
    NSLog(@"收到的内容：%@",userInfo);
    if (application.applicationState == UIApplicationStateActive) {
        RemotePushNotificationObject* remoteNotification = [[RemotePushNotificationObject alloc] initWithDictionary:userInfo];
        [[RemoteNotificationCenter singleton] receiveNewRemotePushNotification:remoteNotification];
    }
    else
    {
        //[[RemoteNotificationHandleCenter singleton] handleTheNotificationDictionary:userInfo];
        [application setApplicationIconBadgeNumber:0];
    }
    [application setApplicationIconBadgeNumber:0];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"kNetworkReachabilityChangedNotification"
                                                  object:nil];
}

#pragma mark private api
//获得所有的存在服务器端的推送消息
- (void)getAllUnhandleRemoteNotification
{
    [[RemoteNotificationCenter singleton] loadAllUnHandleRemoteNotifcation];
}

//根据没有处理的远程消息设置badgeNumber
- (void)setBadgeNumberByUnhandleNotification
{
    int count = [[RemoteNotificationCenter singleton] getAllUnHandleRemoteNotifcationCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

- (void)setUsersFirstLanuchSetting
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"UseAddressBookFirstTime"];
    [userDefaults setBool:YES forKey:@"UseEmploymentFirstTime"];
    [userDefaults setBool:YES forKey:@"UseMeetFirstTime"];
    [userDefaults setBool:YES forKey:@"UseNotificationFirstTime"];
}

- (void)jpushInitialWithOpyions:(NSDictionary* )sender
{
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(networkDidSetup:)
                               name:kAPNetworkDidSetupNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(networkDidClose:)
                               name:kAPNetworkDidCloseNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(networkDidRegister:)
                               name:kAPNetworkDidRegisterNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(networkDidLogin:)
                               name:kAPNetworkDidLoginNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(networkDidReceiveMessage:)
                               name:kAPNetworkDidReceiveMessageNotification
                             object:nil];
    
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    [APService setupWithOption:sender];
    [APService setTags:nil alias:@"12"];
}

#pragma mark - 
- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    //[_infoLabel setText:@"已注册"];
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    //[_infoLabel setText:@"已登录"];
    NSLog(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSLog(@"%@",[NSString stringWithFormat:@"收到消息\ndate:%@\ntitle:%@\ncontent:%@", [dateFormatter stringFromDate:[NSDate date]],title,content]);
}

@end
