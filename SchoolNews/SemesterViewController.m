//
//  SemesterViewController.m
//  SchoolNews
//
//  Created by Jerry on 5月9星期四.
//
//

#import "SemesterViewController.h"
#import "PublicDefines.h"
#import "SemesterClassCell.h"
@interface SemesterViewController ()

- (void)loadTableView;
//- (void)loadNavigationBar;
- (void)loadSemesterModel;
- (void)backToDayClass;
- (ClassObject* )getClassAtIndexPath:(NSIndexPath* )indexPath;

@end

@implementation SemesterViewController
{
    UITableView* tableView_;
    UINavigationBar* navigationBar_;
    NSDictionary* classes_;
    NSArray* keys_;
    SemesterClassModel* model_;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        keys_ = [NSArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self loadSemesterModel];
    [self loadTableView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView DataSource
- (int )numberOfSectionsInTableView:(UITableView *)tableView
{
    return [classes_ count];
}

- (int )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* key = [keys_ objectAtIndex:section];
    NSArray* classes = [classes_ objectForKey:key];
    return [classes count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSString* )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* key = [keys_ objectAtIndex:section];
    NSArray* classes = [classes_ objectForKey:key];
    if ([classes count] > 0) {
        return key;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"identifier";
    SemesterClassCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SemesterClassCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:identifier];
    }
    ClassObject* class = [self getClassAtIndexPath:indexPath];
    [cell setClass:class];
    return cell;
}

#pragma mark SemesterClass Model Delegate
- (void)getTheClassFromWebservice:(id)sender
{
    classes_ = sender;
    [tableView_ reloadData];
}

#pragma mark privateAPI
- (void)loadTableView
{
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)
                                              style:UITableViewStylePlain];
    tableView_.dataSource = self;
    tableView_.delegate = self;
    [self loadSemesterModel];
    classes_ = [model_ getAllClass];
    [self.view addSubview:tableView_];
}

/*- (void)loadNavigationBar
{
    navigationBar_ = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"学期课表"];
    
    UIBarButtonItem* cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"每天课表"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(BackToDayClass)];
    navigationItem.rightBarButtonItem = cancelBarButton;
    [navigationBar_ pushNavigationItem:navigationItem animated:YES];
}*/

- (void)loadSemesterModel
{
    model_ = [SemesterClassModel singleton];
    model_.delegate = self;
}

- (void)backToDayClass
{
    [self.view removeFromSuperview];
}

- (ClassObject* )getClassAtIndexPath:(NSIndexPath* )indexPath
{
    int section = [indexPath section];
    NSString* key = [keys_ objectAtIndex:section];
    NSArray* classes = [classes_ objectForKey:key];
    int row = [indexPath row];
    ClassObject* classObject = [classes objectAtIndex:row];
    return classObject;
}
@end
