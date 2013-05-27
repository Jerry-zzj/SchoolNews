//
//  RefreshEnabelTouchEnableViewController.m
//  SchoolNews
//
//  Created by Jerry on 1月9星期三.
//
//

#import "RefreshEnabelTouchEnableViewController.h"

@interface RefreshEnabelTouchEnableViewController ()

@end

@implementation RefreshEnabelTouchEnableViewController
@synthesize touchMoveDelegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    self.tableView = [[TouchEventTableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [(TouchEventTableView* )self.tableView setMoveDelegate:self];
    EGORefreshTableHeaderView* view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0,0 - self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.delegate = self;
    [self.tableView addSubview:view];
    refreshTableHeaderView_ = view;
    
    EGORefreshTableFootView* footView = [[EGORefreshTableFootView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    footView.delegate = self;
    [self.tableView addSubview:footView];
    refreshTableFootView_ = footView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark touch tableView delegate
- (void)touchMoveToLeft
{
    [self.touchMoveDelegate moveToLeft];
}

- (void)touchMoveToRight
{
    [self.touchMoveDelegate moveToRight];
}
@end
