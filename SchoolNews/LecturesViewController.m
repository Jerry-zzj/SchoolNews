//
//  LecturesViewController.m
//  SchoolNews
//
//  Created by shuangchi on 11月30星期五.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LecturesViewController.h"
#import "DataBaseOperating.h"
#import "LecturesShowViewController.h"
#import "UIImage+Scale.h"
#import "LectureObject.h"
#import "PublicDefines.h"
#import "RemotePushNotificationObject.h"
#import "LectureXMLAnalyze.h"
@interface LecturesViewController ()

- (void)loadLectureListTableView;

@end

@implementation LecturesViewController
LecturesViewController* g_LecturesViewController;
+ (LecturesViewController* )singleton
{
    if (g_LecturesViewController == nil) {
        g_LecturesViewController = [[LecturesViewController alloc] init];
    }
    return g_LecturesViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* tempImage = [UIImage imageNamed:@"学术讲座.png"];
        //NSLog(@"%@",NSStringFromCGSize(tempImage.size));
        self.iconImage = tempImage;
        //UIImage* tabBarImage = [tempImage scaleToSize:CGSizeMake(32, 32)];
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"学术讲座"
                                                                 image:tempImage
                                                                   tag:0];
        self.tabBarItem = tabBarItem;
        
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
    [self loadLectureListTableView];
    //NSLog(@"%@",NSStringFromCGRect(lecturesTableViewController_.view.frame));
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

- (void)viewWillAppear:(BOOL)animated
{
    [self showTabBar];
    [lecturesTableViewController_.tableView setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
    //NSLog(@"%@",NSStringFromCGRect(lecturesTableViewController_.view.frame));

}

- (void)viewDidAppear:(BOOL)animated
{
    [self handleThePushNotification];
}

- (void)handleThePushNotification
{
    if (self.badgeNumber == 0) {
        return;
    }
    else if (self.badgeNumber == 1) {
        //显示新闻
        [lecturesTableViewController_ goToDragDownState];
        NSArray* array = [[[RemoteNotificationCenter singleton] getAllUnHandleRemoteNotifcation] objectForKey:self.functionCode];
        RemotePushNotificationObject* remoteNotification = [array objectAtIndex:0];
        NSString* contentID = remoteNotification.contentID;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError* error;
            //NSLog(@"%@",NEWS_TOTAL_INFORMATION_WITHOUT_CONTENT(contentID));
            NSURL* url = [NSURL URLWithString:GET_LECTURE_TOTALINFORMATION(contentID)];
            NSLog(@"%@",url);
            NSString* string = [NSString stringWithContentsOfURL:url
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];
            //NSLog(@"%@",NEWS_TOTAL_INFORMATION_WITHOUT_CONTENT(contentID));
            if (!error) {
                NSLog(@"获得推送消息具体信息失败");
            }
            NSArray* lectures = [LectureXMLAnalyze analyzeXML:string];
            if ([lectures count] > 0) {
                LectureObject* lecture = [lectures objectAtIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self selectLecture:lecture];
                });
            }
            
        });
    }
    else if(self.badgeNumber == 2)
    {
        //刷新新闻列表
        [lecturesTableViewController_ goToDragDownState];
    }
    //清空所属的远程消息
    [[RemoteNotificationCenter singleton] clearTheRemotePushNotificationsForFunctionCode:self.functionCode];
}

#pragma mark table selectedDelegate
- (void)selectLecture:(id)sender;
{
    LectureObject* lecture = (LectureObject* )sender;
    //将原来的lecture中的日期转换为String
    
    LecturesShowViewController* lectureShowViewController = [[LecturesShowViewController alloc] initWithShowLecture:lecture];
    [self.navigationController pushViewController:lectureShowViewController animated:YES];
}

#pragma mark Template Method 
#pragma mark private
- (void)loadLectureListTableView
{
    lecturesTableViewController_ = [[LecturesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [lecturesTableViewController_.tableView setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
    //NSLog(@"%@",NSStringFromCGRect(lecturesTableViewController_.view.frame));

    [self addChildViewController:lecturesTableViewController_];
    [self.view addSubview:lecturesTableViewController_.tableView];
    //NSDictionary* lectureDictionary = [[DataBaseOperating singleton] getLectures];
    //lecturesTableViewController_.showDataDictionary = lectureDictionary;
    lecturesTableViewController_.delegate = self;
}

@end
