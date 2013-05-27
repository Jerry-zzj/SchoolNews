//
//  SchoolTimeTableViewController.m
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import "SchoolTimeTableViewController.h"
#import "PublicDefines.h"
#import "UsersInformation.h"
#import "SchoolTimeTableCollectionViewController.h"
#import "AboutTime.h"
#import "SemesterViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "CustomSegmentControl.h"

@interface SchoolTimeTableViewController ()

- (void)loadCollectionView;                                 //在函数|getCurrentWeek|中加载
- (void)loadSegmetControl;                                  //在函数|getCurrentWeek|中加载
- (void)loadNavigationTitleView;
- (void)loadNavigationRightBarButton;
- (void)segmentControlValueChanged;

- (void)loadModel;

- (void)getCurrentWeek;
- (void)getCurrentWeekDay;

- (void)goToLastWeek;
- (void)goToNextWeek;
- (void)switchBetweenSemesterAndDay:(UIBarButtonItem* )sender;
- (void)goToSemesterClassesView;
@end

@implementation SchoolTimeTableViewController
{
    UISegmentedControl* segmentedControl_;
    SchoolTimeTableCollectionViewController* collectionViewController_;
    int currentWeek_;
    int currentWeekday_;
    NSNumber* quaryWeek_;
    NSNumber* quaryWeekday_;
    UILabel* weekLabel_;
    SchoolTimeTableModel* schoolTimeTableModel_;
    UIImageView* coverImageView_;
}
SchoolTimeTableViewController* g_SchoolTimeTableViewController;
+ (id)singleton
{
    if (g_SchoolTimeTableViewController == nil) {
        g_SchoolTimeTableViewController = [[SchoolTimeTableViewController alloc] init];
    }
    return g_SchoolTimeTableViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"教务服务-学生课表";
        
        [self addObserver:self
               forKeyPath:@"quaryWeek_"
                  options:0
                  context:nil];
        
        [self addObserver:self
               forKeyPath:@"quaryWeekday_"
                  options:0
                  context:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadModel];
    //[self getCurrentWeek];
	//Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[UsersInformation singleton].userRightFunctionSet containsObject:self.title]) {
        if ([self.view.subviews containsObject:coverImageView_]) {
            [coverImageView_ removeFromSuperview];
        }
        coverImageView_ = nil;
        if (collectionViewController_ == nil) {
            [self getCurrentWeekDay];
            [self getCurrentWeek];
        }
    }
    else
    {
        if (coverImageView_ == nil) {
            coverImageView_ = [[UIImageView alloc] initWithFrame:self.view.bounds];
            [coverImageView_ setImage:[UIImage imageNamed:@"没有访问权限.png"]];
        }
        if (![self.view.subviews containsObject:coverImageView_]) {
            [self.view addSubview:coverImageView_];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"quaryWeek_"];
    [self removeObserver:self
              forKeyPath:@"quaryWeekday_"];
}

#pragma mark Model delegate
- (void)getTheWeekIndexByWebService:(int)index
{
    currentWeek_ = index;
    if (currentWeek_ == INT_MAX) {
        return;
    }
    quaryWeek_ = [NSNumber numberWithInt:currentWeek_];
    if (weekLabel_ == nil && segmentedControl_ == nil && collectionViewController_ == nil) {
        [self loadNavigationTitleView];
        [self loadNavigationRightBarButton];
        [self loadSegmetControl];
        [self loadCollectionView];
    }
}

#pragma mark collectionViewController delegate
- (void)collectionViewControl:(SchoolTimeTableCollectionViewController *)sender scrollToIndex:(int)index
{
    int item = index;
    int weekday = item % 7 + 1;
    int week = item / 7 + 1;
    quaryWeekday_ = [NSNumber numberWithInt:weekday];
    quaryWeek_ = [NSNumber numberWithInt:week];
    [segmentedControl_ setSelectedSegmentIndex:[quaryWeekday_ intValue] - 1];
    NSString* weekString = [NSString stringWithFormat:@"第%i周",[quaryWeek_ intValue]];
    [weekLabel_ setText:weekString];
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"quaryWeek_"]) {
        [collectionViewController_ setWeek:[quaryWeek_ intValue] Weekday:[quaryWeekday_ intValue] Animated:YES];
    }
    if ([keyPath isEqualToString:@"quaryWeekday_"]) {
        [collectionViewController_ setWeek:[quaryWeek_ intValue] Weekday:[quaryWeekday_ intValue] Animated:YES];

    }
    NSString* weekString = [NSString stringWithFormat:@"第%i周",[quaryWeek_ intValue]];
    [weekLabel_ setText:weekString];

}



#pragma mark private API

#define SEGMENTEDCONTROL_HEIGHT                     30
- (void)loadSegmetControl
{
    NSArray* items = [NSArray arrayWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"日", nil];
    segmentedControl_ = [[UISegmentedControl alloc] initWithItems:items];
    [segmentedControl_ setFrame:CGRectMake(0, 0, 320, SEGMENTEDCONTROL_HEIGHT)];
    [segmentedControl_ addTarget:self
                          action:@selector(segmentControlValueChanged)
                forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl_];
    [segmentedControl_ setSelectedSegmentIndex:currentWeekday_ - 1];
}

#define ITEM_SIZE
- (void)loadCollectionView
{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - SEGMENTEDCONTROL_HEIGHT);
    //layout.itemSize = CGSizeMake(200,200);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewController_ = [[SchoolTimeTableCollectionViewController alloc] initWithCollectionViewLayout:layout];
    collectionViewController_.delegate = self;
    [collectionViewController_.collectionView setFrame:CGRectMake(0, SEGMENTEDCONTROL_HEIGHT, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - SEGMENTEDCONTROL_HEIGHT)];
    [self.view addSubview:collectionViewController_.collectionView];
    [collectionViewController_ setWeek:currentWeek_ Weekday:currentWeekday_ Animated:NO];
}

- (void)loadNavigationTitleView
{
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, NAVIGATIONBAR_HEIGHT)];
    
    UIButton* lastWeekButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastWeekButton setImage:[UIImage imageNamed:@"后退.png"]
                    forState:UIControlStateNormal];
    [lastWeekButton setFrame:CGRectMake(0, 0, 40, NAVIGATIONBAR_HEIGHT)];
    [lastWeekButton addTarget:self
                       action:@selector(goToLastWeek)
             forControlEvents:UIControlEventTouchUpInside];
    [lastWeekButton setShowsTouchWhenHighlighted:YES];
    [titleView addSubview:lastWeekButton];
    
    UIButton* nextWeekButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextWeekButton setImage:[UIImage imageNamed:@"前进.png"] forState:UIControlStateNormal];
    [nextWeekButton setFrame:CGRectMake(160, 0, 40, NAVIGATIONBAR_HEIGHT)];
    [nextWeekButton addTarget:self
                       action:@selector(goToNextWeek)
             forControlEvents:UIControlEventTouchUpInside];
    [nextWeekButton setShowsTouchWhenHighlighted:YES];
    [titleView addSubview:nextWeekButton];
    
    if (weekLabel_ == nil) {
        weekLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 120, NAVIGATIONBAR_HEIGHT)];
    }
    NSString* weekString = [NSString stringWithFormat:@"第%i周",currentWeek_];
    [weekLabel_ setText:weekString];
    [weekLabel_ setTextAlignment:NSTextAlignmentCenter];
    [weekLabel_ setBackgroundColor:[UIColor clearColor]];
    [weekLabel_ setTextColor:[UIColor whiteColor]];
    [weekLabel_ setFont:[UIFont systemFontOfSize:25]];
    [titleView addSubview:weekLabel_];
    
    UIViewController* viewController = self.parentViewController;
    viewController.navigationItem.titleView = titleView;
}

- (void)loadNavigationRightBarButton
{
    UIViewController* viewController = self.parentViewController;
    UIBarButtonItem* semesterClasses = [[UIBarButtonItem alloc] initWithTitle:@"学期课表"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(switchBetweenSemesterAndDay:)];
    viewController.navigationItem.rightBarButtonItem = semesterClasses;
}

- (void)segmentControlValueChanged
{
    int selectedIndex = [segmentedControl_ selectedSegmentIndex];
    [self setValue:[NSNumber numberWithInt:selectedIndex] forKeyPath:@"quaryWeekday_"];
    //[collectionViewController_ setWeek:quaryWeek_ Weekday:quaryWeekday_ Animated:YES];
}

- (void)loadModel
{
    if (schoolTimeTableModel_ == nil) {
        schoolTimeTableModel_ = [[SchoolTimeTableModel alloc] init];
        schoolTimeTableModel_.delegate = self;
    }
}

- (void)getCurrentWeek
{
    currentWeek_ = [schoolTimeTableModel_ getTheWeekIndex];
    if (currentWeek_ != INT_MAX) {
        quaryWeek_ = [NSNumber numberWithInt:currentWeek_];
        if (weekLabel_ == nil && segmentedControl_ == nil && collectionViewController_ == nil) {
            [self loadNavigationTitleView];
            [self loadNavigationRightBarButton];
            [self loadSegmetControl];
            [self loadCollectionView];
        }
    }
}

- (void)getCurrentWeekDay
{
    int weekday = [[AboutTime singleton] getWeekDayReturnInt:[NSDate date]];
    currentWeekday_ = weekday;
    quaryWeekday_ = [NSNumber numberWithInt:weekday];
}

- (void)goToLastWeek
{
    if ([quaryWeek_ intValue] > 1) {
        int newWeek = [quaryWeek_ intValue] - 1;
        NSString* weekString = [NSString stringWithFormat:@"第%i周",newWeek];
        [weekLabel_ setText:weekString];
        [self setValue:[NSNumber numberWithInt:newWeek] forKey:@"quaryWeek_"];
    }
    
}

- (void)goToNextWeek
{
    int newWeek = [quaryWeek_ intValue] + 1;
    NSString* weekString = [NSString stringWithFormat:@"第%i周",newWeek];
    [weekLabel_ setText:weekString];
    [self setValue:[NSNumber numberWithInt:newWeek] forKey:@"quaryWeek_"];
}

- (void)switchBetweenSemesterAndDay:(UIBarButtonItem *)sender
{
    NSString* title = [sender title];
    if ([title isEqualToString:@"学期课表"]) {
        [sender setTitle:@"当天课表"];
        [self goToSemesterClassesView];
        UIViewController* viewController = self.parentViewController;
        //[UIView beginAnimations:@"semesterView appear" context:nil];
        //[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        //[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:viewController.navigationController.view cache:YES];
        CATransition* animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromLeft;
        viewController.navigationItem.titleView = nil;
        viewController.navigationItem.title = @"学期课表";
        [[viewController.navigationController.navigationBar layer] addAnimation:animation forKey:@"Title Animation"];
        //[UIView commitAnimations];
        
    }
    else
    {
        [sender setTitle:@"学期课表"];
        [self loadNavigationTitleView];
        SemesterViewController* semesterViewController = [self.childViewControllers lastObject];
        if ([self.view.subviews containsObject:semesterViewController.view]) {
            CATransition* animation = [CATransition animation];
            animation.delegate = self;
            animation.duration = 0.5;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = @"rippleEffect";
            [semesterViewController.view removeFromSuperview];
            [semesterViewController removeFromParentViewController];
            [[self.view layer] addAnimation:animation forKey:@"animation"];
        }
    }
}

- (void)goToSemesterClassesView
{
    SemesterViewController* semesterViewController = [[SemesterViewController alloc] init];
    [self addChildViewController:semesterViewController];
    [semesterViewController.view setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    //[UIView beginAnimations:@"semesterView appear" context:nil];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:semesterViewController.view cache:YES];
    CATransition* animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    [self.view addSubview:semesterViewController.view];
    [[self.view layer] addAnimation:animation forKey:@"animation"];
}
@end
