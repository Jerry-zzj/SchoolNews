//
//  RefreshUnableTouchEnableViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月3星期一.
//
//

#import "RefreshUnableTouchEnableViewController.h"
@interface RefreshUnableTouchEnableViewController ()

@end

@implementation RefreshUnableTouchEnableViewController
@synthesize touchMoveDelegate;

- (id)initWithStyle:(UITableViewStyle)style Frame:(CGRect )frame
{
    self = [super initWithStyle:style Frame:frame];
    if (self) {
        
        self.tableView = [[TouchEventTableView alloc] initWithFrame:frame style:style];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [(TouchEventTableView* )self.tableView setMoveDelegate:self];
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
