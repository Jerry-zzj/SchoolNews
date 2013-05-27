//
//  SchoolNewsTabBarController.m
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SchoolNewsTabBarController.h"
#import "FunctionModuleFactory.h"
#import "DataBaseOperating.h"
#import "LoginViewController.h"
#import "UsersInformation.h"
#import "CustomNavigationController.h"
#import "PublicDefines.h"
#import "FunctionPosition.h"
#import <QuartzCore/QuartzCore.h>
@interface SchoolNewsTabBarController ()

- (void)loadTheViewControllers:(NSArray* )sender;

- (void)updateTheBadgeNumber:(NSNotification* )sender;

@end

@implementation SchoolNewsTabBarController
@synthesize lastSelectedViewController;
SchoolNewsTabBarController* g_SchoolNewsTabBarController;
+ (SchoolNewsTabBarController* )singleton
{
    if (g_SchoolNewsTabBarController == nil) {
        g_SchoolNewsTabBarController = [[SchoolNewsTabBarController alloc] init];
    }
    return g_SchoolNewsTabBarController;
}

-(id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userCancelLogin)
                                                     name:@"UserCancelLogin"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateTheBadgeNumber:)
                                                     name:@"SetTabBarBadge"
                                                   object:nil];
        nameIndexArray_ = [[NSMutableArray alloc] initWithObjects:@"新闻",@"会议",@"通知",@"通讯录", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTheViewControllers:[FunctionPosition singleton].inTabbarViewControllers];
    topView_ = [[TouchEnableView alloc] initWithFrame:self.view.bounds];
    [topView_ setBackgroundColor:[UIColor blackColor]];
    [topView_ setAlpha:0];
    topView_.delegate = self;
    [self.view addSubview:topView_];
	// Do any additional setup after loading the view.
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

- (void)setLastTabBarItem:(FunctionViewController* )sender
{
    NSArray* array = [FunctionPosition singleton].inTabbarViewControllers;
    NSMutableArray* inTabBarViewControllers = [NSMutableArray arrayWithArray:array];
    [inTabBarViewControllers addObject:sender];
    [self loadTheViewControllers:inTabBarViewControllers];
    [self setSelectedIndex:[inTabBarViewControllers count] - 1];
}

- (void)setTabBarHidden:(BOOL )hiddenSender Animated:(BOOL )animatedSender
{
    
}

- (void)moveTabBarControllerToRight
{
    [UIView beginAnimations:@"Tab Bar Hide" context:nil];
    [UIView setAnimationDuration:0.2];
    [self.view setFrame:CGRectMake(320 - 73 - PULL_VIEW_RESPONSE_WIDTH, 20, 320, SCREEN_HEIGHT)];
    [topView_ setAlpha:150.0 / 320.0];
    [topView_ setMovable:YES];
    [UIView commitAnimations];
}

- (void)moveTabBarControllerToNormal
{
    [UIView beginAnimations:@"Tab Bar Show" context:nil];
    [UIView setAnimationDuration:0.2];
    [self.view setFrame:CGRectMake(0, 20, 320, SCREEN_HEIGHT)];
    [topView_ setAlpha:0];
    topView_.movable = NO;
    [UIView commitAnimations];
}

#pragma mark pullView delegate
- (void)pullViewMoveDistance:(float )distance
{
    CGPoint center = self.view.center;
    CGPoint newCenter = CGPointMake(center.x + distance, center.y);
    [self.view setCenter:newCenter];
    
    topView_.movable = YES;
    float oldAlpha = topView_.alpha;
    float newAlpha = oldAlpha + distance / 320.0;
    topView_.alpha = newAlpha;
    
}

- (void)pullViewHidden
{
    [self moveTabBarControllerToNormal];
}

- (void)pullViewShowTotal
{
    [self moveTabBarControllerToRight];
}

#pragma mark SubFunctionViewController Delegate
- (void)subFunctionShow
{
    [UIView beginAnimations:@"FunctionShow" context:nil];
    [UIView setAnimationDuration:0.2];
    [topView_ setAlpha:150.0 / 320.0];
    [topView_ setMovable:NO];
    [UIView commitAnimations];
}

#pragma mark touchEnableView Delegate
//- (void)view:(TouchEnableView *)view touchMoveDistance:(float)distance
- (void)view:(TouchEnableView *)view touchMoveXDistance:(float)xDistance YDistance:(float)yDistance
{
    CGPoint oldCenter = self.view.center;
    CGPoint newCenter = CGPointMake(oldCenter.x + xDistance, oldCenter.y);
    [self.view setCenter:newCenter];
    [[PullView singleton] movePullViewDistance:xDistance animated:NO];
}

//- (void)view:(TouchEnableView *)view touchMoveEnd:(float)allDistance
- (void)view:(TouchEnableView *)view touchMoveEndxDsitance:(float)xDistance yDistance:(float)yDistance
{
    //如果pullView不是正在展示的
    if (![[PullView singleton] moreFunctionShow]) {
        return;
    }
    //加入pullView正在展示
    if (xDistance < -100) {
        [self pullViewHidden];
        [[PullView singleton] pullViewToHidden:YES];
    }
    else
    {
        [self pullViewShowTotal];
        [[PullView singleton] pullViewToShow:YES];
    }
}

/*- (void)touchDown
{
    [[SubFunctionViewController singleton] setSubFunctionViewShow:NO Animated:YES];
    [UIView beginAnimations:@"FunctionShow" context:nil];
    [UIView setAnimationDuration:0.2];
    [topView_ setAlpha:0];
    [topView_ setMovable:NO];
    [UIView commitAnimations];
}*/

#pragma mark tabBarController delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    /*NSArray* functions = [self viewControllers];
    int index = [self selectedIndex];
    FunctionViewController* mainFunctionViewCOntroller = [functions objectAtIndex:index];
    dispatch_async(dispatch_get_global_queue(0, 0), ^(){
        [[SubFunctionViewController singleton] setMainFunctions:mainFunctionViewCOntroller];
    });*/
    
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"inTabbarViewControllers"]) {
        [self loadTheViewControllers:[FunctionPosition singleton].inTabbarViewControllers];
        [self setSelectedIndex:0];
    }
}

#pragma mark private
- (void)loadTheViewControllers:(NSArray* )sender
{
    NSMutableArray* viewControllers = [NSMutableArray array];
    for (FunctionViewController* key in sender) {
        CustomNavigationController* navigationController = [[CustomNavigationController alloc] initWithRootViewController:key];
        [viewControllers addObject:navigationController];
    }
    [self setViewControllers:viewControllers];
    
}

- (void)updateTheBadgeNumber:(NSNotification* )sender
{
    NSDictionary* changeDictionary = [sender object];
    int badgeNumber;
    int tabBarIndex;
    NSString* tabBarItemName = [changeDictionary objectForKey:@"tabBarItemName"];
    tabBarIndex = [nameIndexArray_ indexOfObject:tabBarItemName];
    UITabBarItem* toSetItem = [self.tabBar.items objectAtIndex:tabBarIndex];
    badgeNumber = [[changeDictionary objectForKey:@"NumberOfBadge"] intValue];
    if (badgeNumber > 0) {
        toSetItem.badgeValue = [NSString stringWithFormat:@"%i",badgeNumber];
    }
    else
    {
        toSetItem.badgeValue = nil;
    }
}
@end
