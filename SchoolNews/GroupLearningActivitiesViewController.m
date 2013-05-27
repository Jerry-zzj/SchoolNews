//
//  GroupLearningActivitiesViewController.m
//  SchoolNews
//
//  Created by shuangchi on 11月30星期五.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GroupLearningActivitiesViewController.h"
#import "TextSortedByDateViewController.h"
#import "DataBaseOperating.h"
#import "UIImage+Scale.h"
@interface GroupLearningActivitiesViewController ()

@end

@implementation GroupLearningActivitiesViewController
GroupLearningActivitiesViewController* g_GroupLearningActivitiesViewController;
+ (GroupLearningActivitiesViewController* )singleton
{
    if (g_GroupLearningActivitiesViewController == nil) 
    {
        g_GroupLearningActivitiesViewController = [[GroupLearningActivitiesViewController alloc] init];
    }
    return g_GroupLearningActivitiesViewController;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* tempImage = [UIImage imageNamed:@"团学活动.png"];
        self.iconImage = tempImage;
        //UIImage* tabBarImage = [tempImage scaleToSize:CGSizeMake(20, 20)];
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"团学活动"
                                                                 image:tempImage
                                                                   tag:0];
        self.tabBarItem = tabBarItem;
        
        groupLearningActivitiesTableView_ = [[TextSortedByDateViewController alloc] initWithStyle:UITableViewStylePlain Frame:CGRectMake(0, 0, 320, 367)];
        [self addChildViewController:groupLearningActivitiesTableView_];
        [self.view addSubview:groupLearningActivitiesTableView_.tableView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    mode_ = Normal;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//初始化有子功能菜单的界面
- (void)initialSubFunctions
{
    
}

//初始化正常模式的界面
- (void)loadNormalMode
{
    
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
