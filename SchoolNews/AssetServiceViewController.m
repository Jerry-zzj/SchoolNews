//
//  AssetServiceViewController.m
//  SchoolNews
//
//  Created by shuangchi on 11月30星期五.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AssetServiceViewController.h"
#import "UIImage+Scale.h"
@interface AssetServiceViewController ()

@end

@implementation AssetServiceViewController
AssetServiceViewController* g_AssetServiceViewController;
+ (AssetServiceViewController* )singleton
{
    if (g_AssetServiceViewController == nil) {
        g_AssetServiceViewController = [[AssetServiceViewController alloc] init];
    }
    return g_AssetServiceViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* tempImage = [UIImage imageNamed:@"资产服务.png"];
        self.iconImage = tempImage;
        //UIImage* tabBarImage = [tempImage scaleToSize:CGSizeMake(20, 20)];
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"资产服务"
                                                                 image:tempImage
                                                                   tag:0];
        self.tabBarItem = tabBarItem;
    }
    return self;
}

- (void)viewDidLoad
{
    mode_ = Normal;
    [super viewDidLoad];
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
}

#pragma mark Template Method
//模板方法，改变主功能图标的数字
- (void)doChangeTheBadgeOnMainIcon:(NSDictionary* )pushNotifications
{
    NSArray* array = [pushNotifications objectForKey:@"10"];
    int countOfPushNotification = [array count];
    [self setBadgeNumber:countOfPushNotification];
    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%i",countOfPushNotification]];
}
@end
