//
//  ResearchServiceViewController.m
//  SchoolNews
//
//  Created by shuangchi on 11月30星期五.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ResearchServiceViewController.h"
#import "UIImage+Scale.h"

@interface ResearchServiceViewController ()

@end

@implementation ResearchServiceViewController
ResearchServiceViewController* g_ResearchServiceViewController;
+ (ResearchServiceViewController* )singleton
{
    if (g_ResearchServiceViewController == nil) {
        g_ResearchServiceViewController = [[ResearchServiceViewController alloc] init];
    }
    return g_ResearchServiceViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* tempImage = [UIImage imageNamed:@"科研服务.png"];
        self.iconImage = tempImage;
        //UIImage* tabBarImage = [tempImage scaleToSize:CGSizeMake(20, 20)];
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"科研服务"
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
