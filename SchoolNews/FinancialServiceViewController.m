//
//  FinancialServiceViewController.m
//  SchoolNews
//
//  Created by shuangchi on 11月30星期五.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FinancialServiceViewController.h"
#import "UIImage+Scale.h"
@interface FinancialServiceViewController ()

@end

@implementation FinancialServiceViewController
FinancialServiceViewController* g_FinancialServiceViewController;
+ (FinancialServiceViewController* )singleton
{
    if (g_FinancialServiceViewController == nil) {
        g_FinancialServiceViewController = [[FinancialServiceViewController alloc] init];
    }
    return g_FinancialServiceViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* tempImage = [UIImage imageNamed:@"财务管理.png"];
        self.iconImage = tempImage;
        //UIImage* tabBarImage = [tempImage scaleToSize:CGSizeMake(20, 20)];
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"计财服务"
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

@end
