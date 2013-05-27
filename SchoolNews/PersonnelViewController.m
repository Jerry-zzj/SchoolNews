//
//  PersonnelViewController.m
//  SchoolNews
//
//  Created by shuangchi on 11月30星期五.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonnelViewController.h"
#import "UIImage+Scale.h"

@interface PersonnelViewController ()

@end

@implementation PersonnelViewController
PersonnelViewController* g_PersonnelViewController;
+ (PersonnelViewController* )singleton
{
    if (g_PersonnelViewController == nil) {
        g_PersonnelViewController = [[PersonnelViewController alloc] init];
    }
    return g_PersonnelViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* tempImage = [UIImage imageNamed:@"人事服务.png"];
        self.iconImage = tempImage;
        //UIImage* tabBarImage = [tempImage scaleToSize:CGSizeMake(20, 20)];
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"人事服务"
                                                                 image:tempImage
                                                                   tag:0];
        self.tabBarItem = tabBarItem;
    }
    return self;
}

- (void)viewDidLoad
{
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
    mode_ = Normal;
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
@end
