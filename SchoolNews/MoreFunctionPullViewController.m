//
//  MoreFunctionPullViewController.m
//  SchoolNews
//
//  Created by Jerry on 3月18星期一.
//
//

#import "MoreFunctionPullViewController.h"
#import "PublicDefines.h"
#import "FunctionPosition.h"
#import "TouchEventTableView.h"
#import "PullView.h"
#import "SchoolNewsTabBarController.h"
#import "FunctionViewController.h"
#import "FunctionPositionEditViewController.h"
#import "PullViewCell.h"
#import "UserSettingViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface MoreFunctionPullViewController ()

- (void)loadThePullImage;
- (void)getTheReveivePushNotification;
- (void)receiveTheShowMoreFunctionNotification;

@end

@implementation MoreFunctionPullViewController
MoreFunctionPullViewController* g_MoreFunctionPullViewController;
+ (MoreFunctionPullViewController* )singleton
{
    if (g_MoreFunctionPullViewController == nil) {
        g_MoreFunctionPullViewController = [[MoreFunctionPullViewController alloc] init];
    }
    return g_MoreFunctionPullViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        tableView_ = [[TouchEventTableView alloc] initWithFrame:CGRectMake(73, 0, 320 - 73 - PULL_VIEW_RESPONSE_WIDTH, SCREEN_HEIGHT)
                                                          style:UITableViewStylePlain];
        tableView_.dataSource = self;
        tableView_.delegate = self;
        tableView_.moveDelegate = self;
        [tableView_ setBackgroundColor:[UIColor clearColor]];
        [tableView_ setBackgroundView:nil];
        //[tableView_ setSeparatorColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2]];
        [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        tableView_.showsVerticalScrollIndicator = NO;
        pullHeaderViewController_ = [PullHeaderViewController singleton];
        pullHeaderViewController_.delegate = self;
        //[self.view addSubview:tableView_];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getTheReveivePushNotification)
                                                     name:GET_REMOTE_PUSH_NOTIFICATION
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTheShowMoreFunctionNotification)
                                                     name:@"ShowMoreFunction"
                                                   object:nil];
    }
    return self;
}

- (void)loadView
{
    pullView_ = [PullView singleton];
    pullView_.delegate = [SchoolNewsTabBarController singleton];
    self.view = pullView_;
    //[self loadThePullImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadThePullImage];
    [self.view addSubview:tableView_];
    //[tableView_ setTableHeaderView:pullHeaderViewController_.view];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"ShowMoreFunction"
                                                  object:nil];
}

#pragma mark UItableView DataSource
- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* functions = [FunctionPosition singleton].inPullViewControllers;
    //return [functions count];
    return [functions count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return pullHeaderViewController_.view;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"PullTableViewCell";
    PullViewCell* cell = [tableView_ dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PullViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:identifier];
        //设置Cell点击之后的图片
        //UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320 - 73 - PULL_VIEW_RESPONSE_WIDTH, 52)];
        //[imageView setImage:[UIImage imageNamed:@"纹理点击变色.png"]];
        //[cell setSelectedBackgroundView:imageView];
        
    }
    int row = [indexPath row];
    NSArray* viewControllers = [FunctionPosition singleton].inPullViewControllers;
    FunctionViewController* viewControlleInCell = [viewControllers objectAtIndex:row];
    cell.image = viewControlleInCell.iconImage;
    cell.functionName = viewControlleInCell.title;
    cell.badgeNumber = viewControlleInCell.badgeNumber;
    return cell;
}

#pragma mark UItableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    NSArray* viewControllers = [FunctionPosition singleton].inPullViewControllers;
    FunctionViewController* viewController = [viewControllers objectAtIndex:row];
    [[SchoolNewsTabBarController singleton] setLastTabBarItem:viewController];
    [pullView_ pullViewToHidden:YES];
}

#pragma mark TouchEnableTableView Touch Delegate
- (void)touchMoveToRight
{
    
}

- (void)touchMoveToLeft
{
    
}

#pragma mark pullHeader Delegate
- (void)chooseTheFunctionGotoSettingView
{
    UserSettingViewController* settingViewController = [UserSettingViewController singleton];
    //[self presentModalViewController:settingViewController animated:YES];
    [self presentViewController:settingViewController animated:YES completion:nil];
}

- (void)chooseTheFunctionGotoAddSubscriptionView
{
    FunctionPositionEditViewController* viewController = [FunctionPositionEditViewController singleton];
    [self presentViewController:viewController animated:YES completion:^{
    }];
}

- (void)chooseChangeTheEditState
{
    
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"inPullViewControllers"]) {
        [tableView_ reloadData];
    }
}

#pragma mark private API
- (void)loadThePullImage
{
    //float pullImageHeight = 60;
   CALayer* layer = [[CALayer alloc] init];
    //CGRect frame = CGRectMake(73 + tableView_.bounds.size.width, (SCREEN_HEIGHT - pullImageHeight) / 2.0, PULL_VIEW_RESPONSE_WIDTH, pullImageHeight);
    CGRect frame = CGRectMake(73 + tableView_.bounds.size.width, 44, PULL_VIEW_RESPONSE_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT);
    [layer setFrame:frame];
    NSLog(@"%@",NSStringFromCGRect(frame));
    UIImage* image = [UIImage imageNamed:@"Pull线条.png"];
    [layer setContents:(id)image.CGImage];
    [layer setShadowOffset:CGSizeMake(0, 3)];
    [layer setShadowColor:[UIColor blackColor].CGColor];
    [layer setShadowOpacity:1];
    //[layer setBorderColor:[UIColor blueColor].CGColor];
    //[layer setBorderWidth:2];
    [self.view.layer addSublayer:layer];
    /*CGRect frame = CGRectMake(73 + tableView_.bounds.size.width, 0, PULL_VIEW_RESPONSE_WIDTH, SCREEN_HEIGHT);
    NSLog(@"%@",NSStringFromCGRect(frame));
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(73 + tableView_.bounds.size.width, 0, PULL_VIEW_RESPONSE_WIDTH, SCREEN_HEIGHT)];
    UIImage* image = [UIImage imageNamed:@"Pull线条.png"];
    [imageView setImage:image];
    [self.view addSubview:imageView];*/
}

- (void)getTheReveivePushNotification
{
    [tableView_ reloadData];
}

- (void)receiveTheShowMoreFunctionNotification
{
    [(PullView* )self.view pullViewToShow:YES];
}
@end
