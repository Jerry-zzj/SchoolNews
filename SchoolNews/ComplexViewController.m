//
//  ComplexViewController.m
//  SchoolNews
//
//  Created by Jerry on 4月23星期二.
//
//

#import "ComplexViewController.h"
#import "CampusHotlineViewController.h"
#import "SchoolBusViewController.h"
#import "SubFunctionViewController.h"
#import "PublicDefines.h"
@interface ComplexViewController ()

- (void)showTheViewForSubtitle:(NSString* )subtitle;
- (void)loadSubFunctionView;
- (void)loadTheHomeBarButton;
- (void)goToHomeView;

@end

@implementation ComplexViewController
{
    //SubFunctionViewController* subfunctionViewController_;
}
ComplexViewController* g_ComplexViewController;
+ (ComplexViewController* )singleton
{
    if (g_ComplexViewController == nil) {
        g_ComplexViewController = [[ComplexViewController alloc] init];
    }
    return g_ComplexViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* tempImage = [UIImage imageNamed:@"综合服务.png"];
        self.iconImage = tempImage;
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"综合服务"
                                                                 image:tempImage
                                                                   tag:0];
        self.tabBarItem = tabBarItem;

    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.autoresizesSubviews = YES;
}

- (void)viewDidLoad
{
    mode_ = SubFunction;
    [super viewDidLoad];
    //[self loadTheHomeBarButton];
    //[self initialSubFunctions];
    //[self loadSubFunctionView];
	// Do any additional setup after loading the view.
}

//初始化有子功能菜单的界面
- (void)initialSubFunctions
{
    if (self.subFunction == nil) {
        self.subFunction = [NSMutableArray array];
    }
    CampusHotlineViewController* campusHotlineViewController = [CampusHotlineViewController singleton];
    [campusHotlineViewController.view setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    //NSLog(@"%@",NSStringFromCGRect(CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 50)));
    [self addChildViewController:campusHotlineViewController];
    
    //NSLog(@"%@",NSStringFromCGRect(CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 50)));
    SchoolBusViewController* schoolBusViewController = [SchoolBusViewController singleton];
    [schoolBusViewController.view setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    [self addChildViewController:schoolBusViewController];
    
    [self.subFunction addObject:schoolBusViewController];
    [self.subFunction addObject:campusHotlineViewController];
    //[self.view addSubview:schoolBusViewController.view];
    //[self.view insertSubview:campusHotlineViewController.view atIndex:0];

    [self.view insertSubview:schoolBusViewController.view atIndex:0];
    [self.view insertSubview:campusHotlineViewController.view atIndex:1];
}

//初始化正常模式的界面
- (void)loadNormalMode
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar];
    [super viewWillAppear:animated];
    //[self hideTabBar];
    /*for (UIViewController* object in self.subFunction) {
        [object.view setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 50)];
    }*/
    //CampusHotlineViewController* a = [self.subFunction objectAtIndex:1];
    //NSLog(@"%@",NSStringFromCGRect(a.view.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SubFunctionView Delegate
- (void)selectTheSubFunction:(NSString* )subTitle
{
    if ([subTitle isEqualToString:@"首页"]) {
        [self goToHomeView];
    }
    else
    {
        [self showTheViewForSubtitle:subTitle];
        self.title = [NSString stringWithFormat:@"综合服务-%@",subTitle];
    }
}

#pragma mark SubfunctionViewController DataSource

- (int )subFunctionViewController:(SubFunctionViewController* )subFunctionViewController
    BadgeNumberAtSubFunctionTitle:(NSString* )title
{
    if ([title isEqualToString:@"浙传资讯"] ||
        [title isEqualToString:@"首页"]) {
        return 0;
    }
    NSDictionary* allNotificationDictionary = [[RemoteNotificationCenter singleton] getAllUnHandleRemoteNotifcation];
    NSDictionary* subFunctionsDictionary = [allNotificationDictionary objectForKey:self.functionCode];
    if ([title isEqualToString:@"校内热线"]) {
        NSArray* notifications = [subFunctionsDictionary objectForKey:@"01"];
        return [notifications count];
    }
    else if ([title isEqualToString:@"校车路线"])
    {
        NSArray* notifications = [subFunctionsDictionary objectForKey:@"02"];
        return [notifications count];
    }
    return 0;
}

- (float )minimumLineSpacingOfSubFunctionViewController:(SubFunctionViewController* )subFunctionViewController
{
    return 0;
}

- (UIImage* )subFunctionViewController:(SubFunctionViewController* )subFunctionViewController
                 SelectedImageForTitle:(NSString* )title
{
    NSString* imageName;
    if ([title isEqualToString:@"浙传资讯"]) {
        imageName = @"浙传资讯.png";
    }
    else if ([title isEqualToString:@"首页"])
    {
        imageName = @"Home.png";
    }
    else if ([title isEqualToString:@"校内热线"])
    {
        imageName = @"校内热线.png";
    }
    else if ([title isEqualToString:@"校车路线"])
    {
        imageName = @"校车路线.png";
    }
    return [UIImage imageNamed:imageName];
}

- (UIImage* )subFunctionViewController:(SubFunctionViewController *)subFunctionViewController
               UnselectedImageForTitle:(NSString *)title
{
    NSString* imageName;
    if ([title isEqualToString:@"浙传资讯"]) {
        imageName = @"浙传资讯(灰色).png";
    }
    else if ([title isEqualToString:@"首页"])
    {
        imageName = @"Home(灰色).png";
    }
    else if ([title isEqualToString:@"校内热线"])
    {
        imageName = @"校内热线(灰色).png";
    }
    else if ([title isEqualToString:@"校车路线"])
    {
        imageName = @"校车路线(灰色).png";
    }
    return [UIImage imageNamed:imageName];
}

- (NSArray* )titlesForSubFunctionViewController:(SubFunctionViewController* )subFunctionViewController
{
    NSArray* allTitles = [NSArray arrayWithObjects:@"浙传资讯",@"首页",@"校内热线",@"校车路线",@"首页",@"浙传资讯", nil];
    return allTitles;
}

#pragma mark Template Method

#pragma mark privateAPI
- (void)loadSubFunctionView
{
    if (subfunctionViewController_ == nil) {
        subfunctionViewController_ = [[SubFunctionViewController alloc] init];
    }
    subfunctionViewController_.delegate = self;
    if (![self.view.subviews containsObject:subfunctionViewController_.collectionView]) {
        //[subfunctionViewController_ setMainFunctions:self];
        [self.view addSubview:subfunctionViewController_.collectionView];
    }
}

- (void)showTheViewForSubtitle:(NSString* )subtitle
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
    
	//[UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
	//	[UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:parentView cache:YES];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	//	[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:parentView cache:YES];
    //NSInteger maroon = [[parentView subviews] indexOfObject:[parentView viewWithTag:1001]];
    int toShowIndex = 0;
    //NSArray* array = self.subFunction;
    for (UIViewController* object in self.subFunction) {
        NSString* viewControllerTitle = object.title;
        if ([viewControllerTitle isEqualToString:subtitle]) {
            toShowIndex = [self.subFunction indexOfObject:object];
            break;
        }
    }
    NSLog(@"%i",[self.subFunction count]);
    NSLog(@"%i",toShowIndex);
    [self.view exchangeSubviewAtIndex:1
                   withSubviewAtIndex:toShowIndex];
    [UIView commitAnimations];
    [self.subFunction exchangeObjectAtIndex:toShowIndex
                          withObjectAtIndex:1];
}

- (void)loadTheHomeBarButton
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 25, 25)];
    [button setImage:[UIImage imageNamed:@"Home.png"] forState:UIControlStateNormal];
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(goToHomeView)
     forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)goToHomeView
{
    [self.tabBarController setSelectedIndex:0];
}
@end
