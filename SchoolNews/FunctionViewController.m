//
//  FunctionViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月19星期三.
//
//

#import "FunctionViewController.h"
#import "SubFunctionViewController.h"
#import "PublicDefines.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
@interface FunctionViewController ()

//模板方法
- (void)doTransformFromNormalToSubFunction;
- (void)doTransformFromSubFunctionToNormal;
//

//模板方法
//- (void)doSomeWhenSubFunctionViewShow;
//- (void)doSomeWhenSubFunctionViewHide;
//

//更新子功能界面
//- (void)updateTheSubFunctionViewController;
//- (void)loadTheShowSubFunctionButton;
//- (void)clickTheShowButton;
- (void)clickTheMaskView;

//动画
- (void)traversalAllSubfunctions;
- (void)hideTheSubfunctions;


//收到推送消息更新通知
- (void)getTheRemoteNotificationChangedNotification:(NSNotification* )sender;
//模板方法，改变主功能图标的数字
- (void)changeTheBadgeOnMainIcon:(NSDictionary* )pushNotifications;
//模板方法，改变二级菜单图标的数字
- (void)doChangeInSubFunctionIcon:(NSDictionary* )pushNotifications;
@end

@implementation FunctionViewController
{
    UIButton* showSubFunctionButton_;
    BOOL subFunctionViewShow_;
    BOOL alreadyTraversalAllSubFunctions_;
}
NSNumber* g_showTabBar;
//@synthesize notInTabBarImage;
@synthesize badgeNumber;
@synthesize subFunction;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self addObserver:self
               forKeyPath:@"mode_"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getTheRemoteNotificationChangedNotification:)
                                                     name:GET_REMOTE_PUSH_NOTIFICATION
                                                   object:nil];
        if (g_showTabBar == nil) {
            g_showTabBar = [NSNumber numberWithBool:YES];
        }
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    //self.view.autoresizesSubviews = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.subFunction == nil && mode_ == SubFunction) {
        [self initialSubFunctions];
        [self updateTheSubFunctionViewController];
    }
    if (mode_ == Normal) {
        [self loadNormalMode];
    }
}

//初始化有子功能菜单的界面
- (void)initialSubFunctions
{
    
}

//初始化正常模式的界面
- (void)loadNormalMode
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectTheSubFunction:(NSString* )sender
{
    
}

- (void)handleThePushNotification
{
    
}

/*- (void)setSubFunctionMode:(Mode )sender
{
    
}*/

- (void)transformToMode:(Mode )sender
{
    if (mode_ != sender) {
        if (sender == Normal) {
            //从子功能模式转换为正常模式
            [self doTransformFromSubFunctionToNormal];
        }
        else
        {
            //从正常模式转化为子功能模式
            [self doTransformFromNormalToSubFunction];
        }
    }
}

- (void)hideTabBar {
    if (![g_showTabBar boolValue]) {
        return;
    }
    UITabBar *tabBar = self.tabBarController.tabBar;
    UIView *parent = tabBar.superview; // UILayoutContainerView
    UIView *content = [parent.subviews objectAtIndex:0];  // UITransitionView
    UIView *window = parent.superview;
    NSLog(@"contentFrame:%@",NSStringFromCGRect(content.frame));
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect tabFrame = tabBar.frame;
                         tabFrame.origin.y = CGRectGetMaxY(window.bounds);
                         tabBar.frame = tabFrame;
                         content.frame = CGRectMake(0, 0, 320, window.bounds.size.height - 20);
                     }];
    g_showTabBar = [NSNumber numberWithBool:NO];
    NSLog(@"contentFrame:%@",NSStringFromCGRect(content.frame));
}

- (void)showTabBar {
    if ([g_showTabBar boolValue]) {
        return;
    }
    UITabBar *tabBar = self.tabBarController.tabBar;
    UIView *parent = tabBar.superview; // UILayoutContainerView
    UIView *content = [parent.subviews objectAtIndex:0];  // UITransitionView
    UIView *window = parent.superview;
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect tabFrame = tabBar.frame;
                         tabFrame.origin.y = CGRectGetMaxY(window.bounds) - 20 - CGRectGetHeight(tabBar.frame);
                         tabBar.frame = tabFrame;
                         
                         CGRect contentFrame = content.frame;
                         contentFrame.size.height -= tabFrame.size.height;
                         [content setFrame:CGRectMake(content.frame.origin.x, content.frame.origin.y, content.frame.size.width, content.frame.size.height - tabFrame.size.height)];
                     }];
    g_showTabBar = [NSNumber numberWithBool:YES];
}

- (void)updateTheSubFunctionViewController
{
    if (maskView_ == nil) {
        maskView_ = [[TouchEnableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:maskView_];
        maskView_.delegate = self;
        maskView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [maskView_ setBackgroundColor:[UIColor blackColor]];
        [maskView_ setAlpha:0];
    }
    if (subfunctionViewController_ == nil) {
        subfunctionViewController_ = [[SubFunctionViewController alloc] init];
        subfunctionViewController_.delegate = self;
        subfunctionViewController_.dataSource = self;
        //[subfunctionViewController_ setMainFunctions:self];
        [subfunctionViewController_.collectionView setFrame:CGRectMake(0, 30, 320, 80)];

    }
    if (subFunctionLocationView_ == nil) {
        subFunctionLocationView_ = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 30, 320, 110)];
        [subFunctionLocationView_ addSubview:subfunctionViewController_.collectionView];
        
    }
    if (dragView_ == nil) {
        dragView_ = [[TouchEnableView alloc] initWithFrame:CGRectMake(85, 0, 150, 40)];
        [subFunctionLocationView_ addSubview:dragView_];
        UIImage* backGroudImage = [UIImage imageNamed:@"箭头.png"];
        [dragView_.layer setContents:(id)backGroudImage.CGImage];
        
        dragView_.movable = YES;
        [dragView_ setDelegate:self];
    }
    
    if (![self.view.subviews containsObject:subFunctionLocationView_]) {
        [self.view addSubview:subFunctionLocationView_];
    }
}

- (void)setBadgeNumber:(int)sender
{
    badgeNumber = sender;
    if (sender == 0) {
        [self.tabBarItem setBadgeValue:nil];
    }
    else
    {
        [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%i",sender]];
    }
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"mode_"]) {
        NSLog(@"%@",change);
    }
}

#pragma mark SubFunctionViewController DataSource
- (int )subFunctionViewController:(SubFunctionViewController* )subFunctionViewController
    BadgeNumberAtSubFunctionTitle:(NSString* )title
{
    return 0;
}

- (float )minimumLineSpacingOfSubFunctionViewController:(SubFunctionViewController* )subFunctionViewController
{
    return 0;
}

- (UIImage* )subFunctionViewController:(SubFunctionViewController* )subFunctionViewController
                 SelectedImageForTitle:(NSString* )title
{
    return nil;
}

- (UIImage* )subFunctionViewController:(SubFunctionViewController *)subFunctionViewController
               UnselectedImageForTitle:(NSString *)title
{
    return nil;
}

- (NSArray* )titlesForSubFunctionViewController:(SubFunctionViewController* )subFunctionViewController
{
    return nil;
}


#pragma mark touchenableView Delegate
- (void)viewtouchDown:(TouchEnableView* )view;
{
    if ([view isEqual:maskView_]) {
        [self clickTheMaskView];
    }
}

- (void)view:(TouchEnableView *)view touchMoveXDistance:(float)xDistance YDistance:(float)yDistance
{
    if ([view isEqual:dragView_]) {
        CGPoint oldCenter = subFunctionLocationView_.center;
        CGPoint newCenter = CGPointMake(oldCenter.x, oldCenter.y + yDistance);
        if (CGRectGetMinY(subFunctionLocationView_.frame) < SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 80) {
            return;
        }
        else
        {
            subFunctionLocationView_.center = newCenter;
        }
        [maskView_ setAlpha:0.5 * ( (SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 50 - CGRectGetMinY(subFunctionLocationView_.frame)) / 50.0)];
        [dragView_ setAlpha:1 - ((SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 30 - CGRectGetMinY(subFunctionLocationView_.frame)) / 50.0)];
    }
}

- (void)view:(TouchEnableView *)view touchMoveEndxDsitance:(float)xDistance yDistance:(float)yDistance
{
    if ([view isEqual:dragView_]) {
        if (yDistance > -20) {
            [UIView beginAnimations:@"location back to old frame" context:nil];
            [UIView setAnimationDuration:0.2];
            [subFunctionLocationView_ setFrame:CGRectMake(0, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 30, 320, 110)];
            [dragView_ setAlpha:1];
            [maskView_ setAlpha:0];
            [UIView commitAnimations];
            //[self traversalAllSubfunctions];
        }
        else
        {
            [UIView beginAnimations:@"location back to old frame" context:nil];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(traversalAllSubfunctions)];
            [subFunctionLocationView_ setFrame:CGRectMake(0, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 110, 320, 110)];
            [dragView_ setAlpha:0];
            [maskView_ setAlpha:0.5];
            [UIView commitAnimations];
        }
    }
}

#pragma mark private API

- (void)clickTheMaskView
{
    
    [UIView beginAnimations:@"show the SubFunctionView" context:nil];
    [UIView setAnimationDuration:0.5];
    
    [subFunctionLocationView_ setFrame:CGRectMake(0, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 30, 320, 110)];
    
    [maskView_ setAlpha:0];
    [dragView_ setAlpha:1];
    [UIView commitAnimations];
    //[self doSomeWhenSubFunctionViewHide];
}

//模板方法
- (void)doTransformFromNormalToSubFunction
{
    
}

- (void)doTransformFromSubFunctionToNormal
{
    
}

//动画
- (void)traversalAllSubfunctions
{
    if (!alreadyTraversalAllSubFunctions_) {
        [subfunctionViewController_ traversalAllItems];
        alreadyTraversalAllSubFunctions_ = YES;
    }
}

- (void)hideTheSubfunctions
{
    //NSArray*
}

//
//收到推送消息更新通知
- (void)getTheRemoteNotificationChangedNotification:(NSNotification* )sender
{
    NSDictionary* allPushNotification = [sender object];
    switch (mode_) {
        case Normal:
            [self changeTheBadgeOnMainIcon:allPushNotification];
            break;
        case SubFunction:
            [self changeTheBadgeOnMainIcon:allPushNotification];
            [self doChangeInSubFunctionIcon:allPushNotification];
            break;
        default:
            break;
    }
}

//模板方法，改变主功能图标的数字
- (void)changeTheBadgeOnMainIcon:(NSDictionary* )pushNotifications
{
    //NSArray* array = [pushNotifications objectForKey:self.functionCode];
    id object = [pushNotifications objectForKey:self.functionCode];
    if (object == nil) {
        return;
    }
    int countOfPushNotification = [object count];
    [self setBadgeNumber:countOfPushNotification];
}

//模板方法，改变二级菜单图标的数字
- (void)doChangeInSubFunctionIcon:(NSDictionary* )pushNotifications
{
    [subfunctionViewController_.collectionView reloadData];
}
@end
