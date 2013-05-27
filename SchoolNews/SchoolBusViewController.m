//
//  SchoolBusViewController.m
//  SchoolNews
//
//  Created by Jerry on 4月23星期二.
//
//

#import "SchoolBusViewController.h"
#import "RouteTableViewController.h"
#import "PublicDefines.h"
#import "CustomSegmentControl.h"
@interface SchoolBusViewController ()

- (void)loadTheSegmentedControl;
- (void)loadAllRouteInformation;
- (void)loadRouteTableViewController;

@end

@implementation SchoolBusViewController
{
    CustomSegmentControl* segmentedControl_;
    RouteTableViewController* routeTableViewController_;
    NSDictionary* allRouteDictionary_;
}
SchoolBusViewController* g_SchoolBusViewController;
+ (SchoolBusViewController* )singleton
{
    if (g_SchoolBusViewController == nil) {
        g_SchoolBusViewController = [[SchoolBusViewController alloc] init];
    }
    return g_SchoolBusViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"校车路线";
        [self loadAllRouteInformation];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor grayColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTheSegmentedControl];
    [self loadRouteTableViewController];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTheSegmentedControl
{
    NSArray* array = [NSArray arrayWithObjects:@"杭州<->桐乡",@"杭州<->下沙",@"下沙<->桐乡",nil];
    segmentedControl_ = [[CustomSegmentControl alloc]initWithFrame:CGRectMake(0, 0, 320, 40)
                                                        TitleArray:array
                                                     SelectedImage:[UIImage imageNamed:@"标签.png"]
                                                   UnselectedImage:[UIImage imageNamed:@"标签2.png"]];
    [segmentedControl_ setBackgroundImage:[UIImage imageNamed:@"标签背景.png"]];
    [segmentedControl_ setUpGap:5 DownGap:1 leftAndRightGap:5];
    segmentedControl_.delegate = self;
    //[segmentedControl_ setBackgroundImage:[UIImage imageNamed:@"标签背景.png"]];
    
    [self.view addSubview:segmentedControl_];
    //[segmentedControl_ setBackgroundImage:<#(UIImage *)#> forState:<#(UIControlState)#> barMetrics:<#(UIBarMetrics)#>];
}

- (void)loadAllRouteInformation
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"SchoolBus" ofType:@"plist"];
    allRouteDictionary_ = [NSDictionary dictionaryWithContentsOfFile:filePath];
}

- (void)loadRouteTableViewController
{
    routeTableViewController_ = [[RouteTableViewController alloc] init];
    [routeTableViewController_.tableView setFrame:CGRectMake(0, 40, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 40)];
    routeTableViewController_.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSArray* toShowRoute = [allRouteDictionary_ objectForKey:@"杭州<-->桐乡"];
    if (toShowRoute != nil) {
        [routeTableViewController_ setShowData:toShowRoute];
    }
    [self.view addSubview:routeTableViewController_.view];
}

#pragma mark CustomSegmentControl Delegate
- (void)selectTheItenAtIndex:(int )selectedIndex
{
    if (allRouteDictionary_ == nil) {
        [self loadAllRouteInformation];
    }
    NSArray* toShowRoute = nil;
    switch (selectedIndex) {
        case 0:
            toShowRoute = [allRouteDictionary_ objectForKey:@"杭州<-->桐乡"];
            break;
        case 1:
            toShowRoute = [allRouteDictionary_ objectForKey:@"杭州<-->下沙"];
            break;
        case 2:
            toShowRoute = [allRouteDictionary_ objectForKey:@"下沙<-->桐乡"];
            break;
        default:
            break;
    }
    if (routeTableViewController_ == nil) {
        [self loadRouteTableViewController];
    }
    if (toShowRoute != nil) {
        [routeTableViewController_ setShowData:toShowRoute];
    }

}
@end
